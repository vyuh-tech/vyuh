import { readFileSync, readdirSync } from 'node:fs';
import path from 'node:path';

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
function walk(directory) {
  for (const entry of readdirSync(directory, { withFileTypes: true })) {
    const file = path.join(directory, entry.name);
    if (entry.isDirectory()) { if (!SKIP.has(entry.name)) walk(file); }
    else if (file.endsWith('.md')) {
      const source = readFileSync(file, 'utf8');
      if (/^(?:\.\/)?(intro|concepts|guides|examples)\//.test(file)) {
        assert(!/\b(?:CMSRoute|ContentExtensionDescriptor|SanityContentProvider|SanityConfig)\b/.test(source), `${file} contains integration-specific implementation`);
      }
    }
  }
}
walk('.');
if (failures.length) throw new Error(failures.join('\n'));
console.log('Validated core/CMS sidebars and core page content.');
