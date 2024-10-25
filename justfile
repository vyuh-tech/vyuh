#!/usr/bin/env just --justfile
export PATH := "./node_modules/.bin:" + env_var('PATH')

# Core Packages
gen-flutter_sanity_portable_text: (_generate-json "packages/sanity/flutter_sanity_portable_text" "watch")
gen-sanity_client: (_generate-json "packages/sanity/sanity_client" "watch")
gen-vyuh_core: (_generate-json "packages/system/vyuh_core" "watch")
gen-vyuh_extension_content: (_generate-json "packages/system/vyuh_extension_content" "watch")
gen-vyuh_feature_system: (_generate-json "packages/system/vyuh_feature_system" "watch")
gen-feature_onboarding: (_generate-json "packages/system/vyuh_feature_onboarding" "watch")
gen-vyuh_feature_auth: (_generate-json "packages/system/vyuh_feature_auth" "watch")

# Example Features
gen-feature_sample: (_generate-json "features/feature_sample" "watch")
gen-feature_tmdb: (_generate-json "features/tmdb/feature_tmdb" "watch")
gen-feature_wonderous: (_generate-json "features/wonderous/feature_wonderous" "watch")
gen-feature_puzzles: (_generate-json "features/puzzles/feature_puzzles")
gen-feature_food: (_generate-json "features/food/feature_food" "watch")
gen-feature_settings: (_generate-json "features/settings/feature_settings" "watch")
gen-feature_misc: (_generate-json "features/misc/feature_misc" "watch")

# Packages
gen-tmdb_client: (_generate-json "packages/tmdb_client" "watch")

# Launch images and Icons
gen-launcher-icons:
    #!/usr/bin/env bash
    cd apps/vyuh_demo
    flutter pub run flutter_launcher_icons

gen-splash-screen:
    #!/usr/bin/env bash
    cd apps/vyuh_demo
    flutter pub run flutter_native_splash:create


_generate-json package command="build":
    #!/usr/bin/env bash
    echo "Building JSON-Serializable in {{package}}"
    cd {{package}}
    dart run build_runner {{command}} --delete-conflicting-outputs
