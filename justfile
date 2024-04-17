#!/usr/bin/env just --justfile
export PATH := "./node_modules/.bin:" + env_var('PATH')

gen-vyuh_core: (_generate-json "packages/system/vyuh_core" "watch")
gen-vyuh_extension_script: (_generate-json "packages/system/vyuh_extension_script" "watch")
gen-vyuh_extension_content: (_generate-json "packages/system/vyuh_extension_content" "watch")
gen-vyuh_feature_system: (_generate-json "packages/system/vyuh_feature_system" "watch")
gen-feature_sample: (_generate-json "features/feature_sample" "watch")

sync-npm:
    syncpack fix-mismatches format

_generate-json package command="build":
    #!/usr/bin/env bash
    echo "Building JSON-Serializable in {{package}}"
    cd {{package}}
    dart run build_runner {{command}} --delete-conflicting-outputs
