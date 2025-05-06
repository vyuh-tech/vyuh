#!/usr/bin/env just --justfile
export PATH := "./node_modules/.bin:" + env_var('PATH')

# Core Packages
gen-flutter_sanity_portable_text: (_generate-json "packages/sanity/flutter_sanity_portable_text" "watch")
gen-sanity_client: (_generate-json "packages/sanity/sanity_client" "watch")
gen-vyuh_core: (_generate-json "packages/system/vyuh_core" "watch")
gen-vyuh_extension_content: (_generate-json "packages/system/vyuh_extension_content" "watch")
gen-vyuh_content_widget: (_generate-json "packages/system/vyuh_content_widget" "watch")

# Vyuh Features
gen-vyuh_feature_system: (_generate-json "packages/system/vyuh_feature_system" "watch")
gen-feature_onboarding: (_generate-json "packages/system/vyuh_feature_onboarding" "watch")
gen-vyuh_feature_auth: (_generate-json "packages/system/vyuh_feature_auth" "watch")

# Example Features
gen-feature_conference: (_generate-json "examples/conference/feature_conference" "watch")
gen-feature_counter: (_generate-json "examples/feature_counter" "watch")
gen-feature_food: (_generate-json "examples/food/feature_food" "watch")
gen-feature_misc: (_generate-json "examples/misc/feature_misc" "watch")
gen-feature_puzzles: (_generate-json "examples/puzzles/feature_puzzles")
gen-feature_settings: (_generate-json "examples/settings/feature_settings" "watch")
gen-feature_tmdb: (_generate-json "examples/tmdb/feature_tmdb" "watch")
gen-feature_unsplash: (_generate-json "examples/unsplash/feature_unsplash" "watch")
gen-feature_wonderous: (_generate-json "examples/wonderous/feature_wonderous" "watch")

# Packages
gen-tmdb_client: (_generate-json "packages/tmdb_client" "watch")

# Launch images and Icons
gen-launcher-icons:
    #!/usr/bin/env fish
    cd apps/vyuh_demo
    flutter pub run flutter_launcher_icons

gen-splash-screen:
    #!/usr/bin/env fish
    cd apps/vyuh_demo
    flutter pub run flutter_native_splash:create


_generate-json package command="build":
    #!/usr/bin/env fish
    echo "Building JSON-Serializable in {{package}}"
    cd {{package}}
    dart run build_runner {{command}} --delete-conflicting-outputs

# Publish to Testflight for testing on devices
build-and-upload-ipa: _build-ipa _upload-to-testflight

_build-ipa:
    #!/usr/bin/env fish
    cd apps/vyuh_demo
    rm -rf build/ios/ipa
    melos bootstrap
    flutter build ipa --obfuscate --split-debug-info=build/ios/symbols

_upload-to-testflight:
    #!/usr/bin/env fish
    cd apps/vyuh_demo/ios
    fastlane beta
