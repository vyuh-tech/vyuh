import { readFileSync, readdirSync } from 'node:fs';
import path from 'node:path';

const routes = JSON.parse(readFileSync('.vitepress/scripts/legacy-routes.json', 'utf8'));
const failures = [];
const SKIP = new Set(['node_modules', '.vitepress', 'public']);
const assert = (condition, message) => { if (!condition) failures.push(message); };
const configuration = readFileSync('.vitepress/config.ts', 'utf8');
const start = configuration.indexOf('    sidebar: ');
const end = configuration.indexOf('\n    socialLinks:', start);
const sidebars = JSON.parse(configuration.slice(start + '    sidebar: '.length, end).trim().replace(/,$/, ''));
function links(items) {
  return items.flatMap(item => [item.link, ...links(item.items ?? [])].filter(Boolean));
}
for (const href of links(sidebars['/'])) {
  assert(!href.startsWith('/cms/') || href === '/cms/', `Core sidebar contains integration detail: ${href}`);
}
for (const href of links(sidebars['/cms/'])) {
  assert(href.startsWith('/cms/') || href === '/intro/', `CMS sidebar contains misplaced page: ${href}`);
}
for (const [from, to] of Object.entries(routes)) {
  const redirect = readFileSync('.' + from + '.md', 'utf8');
  assert(redirect.includes('search: false') && redirect.includes(`<RedirectPage to="${to}"`), `Invalid redirect: ${from}`);
  assert(!redirect.includes('```'), `Redirect retains duplicate documentation: ${from}`);
  assert(readFileSync('.' + to + '.md', 'utf8').includes('# '), `Missing canonical content: ${to}`);
}
function walk(directory) {
  for (const entry of readdirSync(directory, { withFileTypes: true })) {
    const file = path.join(directory, entry.name);
    if (entry.isDirectory()) { if (!SKIP.has(entry.name)) walk(file); }
    else if (file.endsWith('.md')) {
      const source = readFileSync(file, 'utf8');
      const original = '/' + file.replace(/\.md$/, '');
      for (const match of source.matchAll(/\]\(([^\s)]+)\)/g)) {
        const href = match[1];
        if (/^(?:[a-z]+:|#|\/\/)/i.test(href)) continue;
        const clean = href.split(/[?#]/)[0];
        const resolved = (clean.startsWith('/') ? clean : path.posix.resolve(path.posix.dirname(original), clean)).replace(/\.md$/, '').replace(/\/$/, '');
        assert(!(resolved in routes), `${file} links to legacy documentation: ${href}`);
      }
      if (/^(?:\.\/)?(intro|concepts|guides|examples)\//.test(file) && !source.includes('<RedirectPage')) {
        assert(!/\b(?:CMSRoute|ContentExtensionDescriptor|SanityContentProvider|SanityConfig)\b/.test(source), `${file} contains integration-specific implementation`);
      }
    }
  }
}
walk('.');
if (failures.length) throw new Error(failures.join('\n'));
console.log(`Validated core/CMS sidebars, ${Object.keys(routes).length} canonical routes, and internal references.`);
