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

# Fix Gradle lock issues
gradleFix:
	@echo "Stopping Gradle daemons..."
	-cd android && ./gradlew --stop
	@echo "Killing Gradle and Java processes..."
	-pkill -9 -f gradle
	-pkill -9 -f java
	@echo "Removing lock files..."
	-find android/.gradle -name "*.lock" -delete 2>/dev/null
	-find ~/.gradle -name "*.lock" -delete 2>/dev/null
	@echo "Gradle locks cleared!"

buildIos:
    sh upload_ios.sh
# put:
#     export PATH="$PATH:/path/to/your/app/bin"

