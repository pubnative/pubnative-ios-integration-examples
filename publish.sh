# Create IPA with Fastlane GYM
fastlane gym --use_legacy_build_api \
--include_bitcode false \
--include_symbols false \
--clean \
--workspace sample.xcworkspace \
--scheme sample.small \
--archive_path $CIRCLE_ARTIFACTS/archive.xcarchive \
--output_directory $CIRCLE_ARTIFACTS/ipa \
