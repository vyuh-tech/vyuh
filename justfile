#!/usr/bin/env just --justfile
export PATH := "./node_modules/.bin:" + env_var('PATH')

gen-vyuh_core: (_generate-json "packages/system/vyuh_core" "watch")
gen-vyuh_extension_script: (_generate-json "packages/system/vyuh_extension_script" "watch")
gen-feature_sample: (_generate-json "features/sample/feature_sample" "watch")

_generate-json package command="build":
    #!/usr/bin/env bash
    echo "Building JSON-Serializable in {{package}}"
    cd {{package}}
    dart run build_runner {{command}} --delete-conflicting-outputs
