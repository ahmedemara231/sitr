# ==============================
# Flutter Makefile
# ==============================

.PHONY: clean run apk ios upgrade handlePods openXcode translations gradleFix buildIos

# Clean Flutter build and get packages
clean:
	flutter clean && flutter pub get

# Run the app on a connected device
run:
	flutter run

# Build APK
apk:
	flutter build apk --split-per-abi

# Build iOS (for macOS users with Xcode)
ios:
	flutter build ios

# Upgrade Flutter packages
upgrade:
	flutter pub upgrade

# Install & update CocoaPods
handlePods:
	cd ios && pod install && pod update && cd ..

# Open project in Xcode
openXcode:
	open ios/Runner.xcworkspace

# Generate translations
translations:
	dart run generate/strings/main.dart

# Fix Gradle lock issues
gradleFix:
	@echo "Stopping Gradle daemons..."
	-cd android && ./gradlew --stop
	@echo "Killing Gradle and Java processes..."
	-pkill -9 -f gradle || true
	-pkill -9 -f java || true
	@echo "Removing lock files..."
	-find android/.gradle -name "*.lock" -delete 2>/dev/null || true
	-find ~/.gradle -name "*.lock" -delete 2>/dev/null || true
	@echo "Gradle locks cleared!"

# Upload iOS build
buildIos:
	sh upload_ios.sh