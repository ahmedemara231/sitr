#!/bin/bash

# ====== CONFIG ======
APP_NAME="ستر"
IPA_PATH="build/ios/ipa/$APP_NAME.ipa"
APPLE_ID="your@email.com"
APP_PASSWORD="xxxx-xxxx-xxxx-xxxx"
BUNDLE_ID="com.aait.flutter.sitr"
PLATFORM="ios"

echo "🚀 Cleaning project..."
flutter clean

echo "📦 Getting packages..."
flutter pub get

echo "🏗 Building IPA..."
flutter build ipa --release

if [ ! -f "$IPA_PATH" ]; then
  echo "❌ IPA file not found!"
  exit 1
fi

echo "🧪 Validating IPA..."
xcrun altool --validate-app \
-f "$IPA_PATH" \
-t "$PLATFORM" \
-u "$APPLE_ID" \
-p "$APP_PASSWORD"

echo "☁️ Uploading to App Store Connect..."
xcrun altool --upload-app \
-f "$IPA_PATH" \
-t "$PLATFORM" \
-u "$APPLE_ID" \
-p "$APP_PASSWORD"

echo "✅ Done! Check App Store Connect."