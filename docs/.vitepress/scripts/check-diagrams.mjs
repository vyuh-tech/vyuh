import { readdirSync, readFileSync } from 'node:fs';
import { join } from 'node:path';
import { Window } from 'happy-dom';

// Mermaid's parser uses DOMPurify for labels, even when no SVG is rendered.
const window = new Window();
globalThis.window = window;
globalThis.document = window.document;
const { default: mermaid } = await import('mermaid');
mermaid.initialize({ startOnLoad: false, securityLevel: 'strict', htmlLabels: false });

let checked = 0;
const failures = [];
async function check(file) {
  const source = readFileSync(file, 'utf8');
  for (const match of source.matchAll(/```mermaid\s*\n([\s\S]*?)```/g)) {
    checked++;
    try {
      await mermaid.parse(match[1]);
    } catch (error) {
      const line = source.slice(0, match.index).split('\n').length;
      failures.push(`${file}:${line}: ${error.message}`);
    }
  }
}
const SKIP = new Set(['node_modules', '.vitepress', 'public']);
async function walk(directory) {
  for (const entry of readdirSync(directory, { withFileTypes: true })) {
    const path = join(directory, entry.name);
    if (entry.isDirectory()) { if (!SKIP.has(entry.name)) await walk(path); }
    else if (path.endsWith('.md')) await check(path);
  }
}
await walk('.');
await walk('.vitepress/theme/components');
await window.happyDOM.close();
if (failures.length) {
  console.error(failures.join('\n\n'));
  process.exitCode = 1;
} else {
  console.log(`Validated ${checked} Mermaid diagrams.`);
}
