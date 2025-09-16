setup:
	flutter clean && flutter pub get

build:
	flutter build apk --release

test:
	flutter test

format:
	dart format .

runner:
	flutter pub run build_runner build --delete-conflicting-outputs

tr:
	dart run generate/strings/main.dart

