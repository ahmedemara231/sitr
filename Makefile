# Makefile

# Clean Flutter build and get packages
clean:
	flutter clean && flutter pub get

# Run the app on a connected device
run:
	flutter run

# Build APK
apk:
	flutter build apk

# Build iOS (for macOS users with Xcode)
ios:
	flutter build ios

# Upgrade Flutter packages
upgrade:
	flutter pub upgrade

handlePods:
	cd ios && pod install && pod update && cd ..

openXcode:
	open ios/Runner.xcworkspace

translations:
	dart run generate/strings/main.dart
