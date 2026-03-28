# ==============================
# Flutter Makefile
# ==============================

.PHONY: clean run apk ios upgrade handlePods openXcode translations gradleFix buildIos \
        distribute addTesters removeTesters createGroup deleteGroup \
        distributeAndroid

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

# ==============================
# Firebase App Distribution
# ==============================

FIREBASE_APP_ID = 1:573182601628:ios:0f791a99a4520abdeb4059
IPA_PATH       ?= build/ios/ipa/Runner.ipa

# Distribute IPA to testers/groups
# Usage: make distribute NOTES="my release notes" TESTERS="a@b.com" GROUPS="qa-team"
distribute:
	firebase appdistribution:distribute $(IPA_PATH) \
		--app $(FIREBASE_APP_ID) \
		$(if $(NOTES),--release-notes "$(NOTES)") \
		$(if $(NOTES_FILE),--release-notes-file "$(NOTES_FILE)") \
		$(if $(TESTERS),--testers "$(TESTERS)") \
		$(if $(TESTERS_FILE),--testers-file "$(TESTERS_FILE)") \
		$(if $(GROUPS),--groups "$(GROUPS)") \
		$(if $(GROUPS_FILE),--groups-file "$(GROUPS_FILE)")

# Add testers
# Usage: make addTesters EMAILS="a@b.com c@d.com"
#        make addTesters FILE=testers.txt
#        make addTesters EMAILS="a@b.com" GROUP=qa-team
addTesters:
	firebase appdistribution:testers:add \
		$(if $(GROUP),--group-alias $(GROUP)) \
		$(if $(FILE),--file $(FILE)) \
		$(EMAILS)

# Remove testers
# Usage: make removeTesters EMAILS="a@b.com c@d.com"
#        make removeTesters FILE=testers.txt
#        make removeTesters EMAILS="a@b.com" GROUP=qa-team
removeTesters:
	firebase appdistribution:testers:remove \
		$(if $(GROUP),--group-alias $(GROUP)) \
		$(if $(FILE),--file $(FILE)) \
		$(EMAILS)

# Create a tester group
# Usage: make createGroup NAME="QA Team" ALIAS=qa-team
createGroup:
	firebase appdistribution:group:create "$(NAME)" $(ALIAS)

# Delete a tester group
# Usage: make deleteGroup ALIAS=qa-team
deleteGroup:
	firebase appdistribution:group:delete $(ALIAS)

# ==============================
# Firebase App Distribution (Android)
# ==============================

FIREBASE_ANDROID_APP_ID = 1:573182601628:android:b9b24bf4217e710feb4059
APK_PATH               ?= build/app/outputs/flutter-apk/app-release.apk

# Distribute APK to testers/groups
# Usage: make distributeAndroid NOTES="my release notes" TESTERS="a@b.com" GROUPS="qa-team"
distributeAndroid:
	firebase appdistribution:distribute $(APK_PATH) \
		--app $(FIREBASE_ANDROID_APP_ID) \
		$(if $(NOTES),--release-notes "$(NOTES)") \
		$(if $(NOTES_FILE),--release-notes-file "$(NOTES_FILE)") \
		$(if $(TESTERS),--testers "$(TESTERS)") \
		$(if $(TESTERS_FILE),--testers-file "$(TESTERS_FILE)") \
		$(if $(GROUPS),--groups "$(GROUPS)") \
		$(if $(GROUPS_FILE),--groups-file "$(GROUPS_FILE)")