import { readFileSync, writeFileSync } from 'node:fs';
const framework = new URL('../../../', import.meta.url);
const source = readFileSync(new URL('packages/system/vyuh_core/example/first_app.dart', framework), 'utf8').trimEnd();
writeFileSync(new URL('../theme/components/FirstApp.md', import.meta.url), '```dart\n' + source + '\n```\n');
console.log('Synced the analyzed Flutter example.');
const composed = readFileSync(new URL('packages/system/vyuh_core/example/composed_app.dart', framework), 'utf8').trimEnd();
writeFileSync(new URL('../theme/components/ComposedApp.md', import.meta.url), '```dart\n' + composed + '\n```\n');
console.log('Synced the composition example.');
