import {readFileSync,writeFileSync,mkdirSync} from 'node:fs';
import {fileURLToPath} from 'node:url';
import { apiDiagrams } from './api-diagrams';
const root = fileURLToPath(new URL('../..', import.meta.url)).replace(/\/$/, '');
// The CLI is a tool, documented in the CLI guide, not an API to program against.
const packages=(JSON.parse(readFileSync(root + '/.vitepress/scripts/api-source.json','utf8')) as any[]).filter(p => p.name !== 'vyuh_cli');
const cmsPackages = new Set(['vyuh_extension_content', 'vyuh_feature_system', 'vyuh_feature_auth', 'vyuh_feature_onboarding', 'vyuh_feature_developer', 'vyuh_content_widget', 'sanity_client', 'flutter_sanity_portable_text', 'vyuh_plugin_content_provider_sanity', 'vyuh_widgetbook']);
mkdirSync(root+'/api',{recursive:true});mkdirSync(root+'/cms/api',{recursive:true});

const intros:Record<string,string>={
vyuh_core:'Compose features with FeatureDescriptor, choose shared capabilities with PluginDescriptor, and launch through runApp. This package owns platform lifecycle, base plugin contracts, navigation integration, dependency injection, events, analytics, and telemetry.',
vyuh_extension_content:'Register content and configuration types through ContentExtensionDescriptor and ContentExtensionBuilder. DefaultContentPlugin deserializes registered types, selects layouts, applies modifiers, and builds routes. Actions execute configurations; conditions produce string values for case matching.',
vyuh_feature_system:'The system feature contributes built-in content blocks, route types, layouts, actions, conditions, and responsive/theme services. Include its feature descriptor when your application consumes those types; importing a type alone does not register it.',
vyuh_feature_auth:'Authentication UI and content configurations consume the AuthPlugin capability. Include the feature and an appropriate auth provider to support the sign-in methods your app exposes.',
vyuh_feature_onboarding:'The onboarding feature supplies a content type, step data, and a default layout. It composes text, imagery, and actions using the normal content extension pipeline.',
vyuh_feature_developer:'Developer tools inspect registered features, plugins, content types, and previews. Include the feature during development and follow the preview guide when exposing content to the playground.',
vyuh_content_widget:'Embed framework content in an existing Flutter app using VyuhContentBinding and VyuhContentWidget. Initialize the binding before Flutter runApp, await widgetReady for service access, and use your host app for navigation ownership.',
vyuh_cache:'Cache<V> wraps CacheStorage<V> with a configured TTL. Use get for expiration-aware reads, build to retrieve or generate, set to store, remove to invalidate a key, and clear to remove stored entries. Concurrent build misses for a key share generation in the audited source.',
sanity_client:'SanityClient runs GROQ queries using an injected or default HTTP client. SanityConfig selects project, dataset, API version, perspective, and CDN behavior. The client also builds image/file URLs and provides a live query stream.',
vyuh_plugin_content_provider_sanity:'SanityContentProvider implements ContentProvider with query-response caching, typed conversion, route projections, media URLs, and a LiveContentProvider. useCache: false performs a fresh provider request; it does not invalidate Sanity CDN caches.',
flutter_sanity_portable_text:'Deserialize Portable Text blocks and spans, then render with registered block and mark builders. Configuration determines styling and the supported inline or embedded content.',
vyuh_plugin_storage_hive:'HiveStoragePlugin persists general values in a Hive box. The boxName selects the store. This is general storage, not the SecureStoragePlugin contract.',
vyuh_plugin_storage_secure:'FlutterSecureStoragePlugin implements string persistence through flutter_secure_storage. Use the secureStorage slot in PluginDescriptor and consult the package setup for each target platform.',
vyuh_plugin_storage_shared_preferences:'SharedPreferencesStoragePlugin stores values as strings: write uses value.toString() and read uses getString. Choose this for simple string preferences rather than expecting arbitrary objects to round-trip.',
vyuh_plugin_telemetry_provider_console:'ConsoleLoggerTelemetryProvider is a telemetry provider used inside TelemetryPlugin.providers. It logs messages and errors; startTrace returns a NoOpTrace and does not record trace metrics.',
vyuh_test:'Test utilities help wait for the platform to reach ready/error and provide a mocked BuildContext. Use them with flutter_test and await disposal between independently initialized platforms.',
vyuh_widgetbook:'Adapters expose content previews as Widgetbook use cases. This package is developer tooling; the production content registry remains owned by the framework.',
vyuh_cli:'Dart command runner for vyuh create, doctor, and update. Bundled App, feature, and capability-plugin scaffolds are the primary path; CMS item and schema templates are optional; see the CLI guide for end-user commands.'};
const escape=(s:string)=>s.replaceAll('<','&lt;').replaceAll('>','&gt;').replaceAll('|','\\|').replaceAll('\n',' ');
const summary=(s:string)=>escape(s.split('\n\n')[0].replace(/\[([^\]]+)\]/g,'`$1`').replace(/```[\s\S]*/g,'').trim());
let index='---\ntitle: API Reference\ndescription: Public APIs for composition, shared capabilities, and tooling, derived from source.\nprev: false\n---\n\n# API reference\n\nStart with the contract you need, then follow its source link for implementation details. These pages list declarations and directly declared public members from the checked-out framework source. They exclude generated serializers, inherited Flutter members, and external package APIs. The catalog includes all public top-level library entry points; library-specific exports determine which import exposes each symbol.\n\nFor release-specific inherited documentation, use each package’s linked pub.dev API. Source references point to the owning repository; the current audit includes local fixes that have not been published.\n\n| Package | What it owns | Public declarations |\n| --- | --- | --- |\n';
for(const pkg of packages.sort((a,b)=>a.name === 'vyuh_core' ? -1 : b.name === 'vyuh_core' ? 1 : a.name.localeCompare(b.name))) {
 const slug=pkg.name.replaceAll('_','-');
 const anchors = new Map<string, number>();
 for (const symbol of pkg.symbols) {
  const base = symbol.name.toLowerCase().replaceAll('_', '-');
  const count = (anchors.get(base) ?? 0) + 1;
  anchors.set(base, count);
  symbol.anchor = count === 1 ? base : `${base}-${count}`;
 }
 if (!cmsPackages.has(pkg.name)) index+=`| [${pkg.name}](${slug}) | ${escape(intros[pkg.name].split('. ')[0])}. | ${pkg.symbols.length} |\n`;
 let md=`---\ntitle: ${pkg.name} API\ndescription: Public declarations and contracts for ${pkg.name}.\noutline: 2\n---\n\n# ${pkg.name}\n\n${escape(intros[pkg.name])}\n\n\`\`\`mermaid\n${apiDiagrams[pkg.name]}\n\`\`\`\n\n[Package source](https://github.com/vyuh-tech/vyuh/tree/main/${pkg.path}) · [Released API](https://pub.dev/documentation/${pkg.name}/latest/)\n\n## Choose a declaration\n\n`;
 md+=pkg.symbols.map((s:any)=>`[${s.name}](#${s.anchor})`).join(' · ')+ '\n\n';
 for(const symbol of pkg.symbols) {
  md+=`## ${symbol.name} {#${symbol.anchor}}\n\n[Source](https://github.com/vyuh-tech/vyuh/blob/main/${symbol.file}#L${symbol.line})\n\n${summary(symbol.doc) || 'Public declaration in this package.'}\n\n\`\`\`dart\n${symbol.signature}\n\`\`\`\n\n`;
  if(symbol.members.length) {
   md+='Directly declared public members:\n\n';
   for(const m of symbol.members) md+=`\`\`\`dart\n${m.signature};\n\`\`\`\n\n${summary(m.doc)}\n\n`;
  }
 }
 const directory = cmsPackages.has(pkg.name) ? '/cms/api/' : '/api/';
 writeFileSync(root+directory+slug+'.md',md.trimEnd()+'\n');
}
index+='\n## Learn the runtime contracts\n\n- [Architecture and ownership](/concepts/features-and-plugins)\n- [Startup and lifecycle](/concepts/runtime-lifecycle)\n- [Caching and correctness](/concepts/performance)\n\nThe optional integration packages have their own [CMS API catalog](/cms/api).\n';
writeFileSync(root+'/api/index.md',index);
