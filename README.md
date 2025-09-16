📦 Custom Clean Architecture Template for Flutter
This repository provides a highly customizable and scalable Clean Architecture boilerplate for Flutter applications. It is designed to help developers build maintainable, testable, and modular apps by applying best practices in software architecture.

🔧 Features
✅ Clean Architecture Layers: Presentation, Domain, and Data layers are clearly separated.

✅ Modular Structure: Supports code reusability and scalability.

✅ Dependency Injection: Easy service management using get_it.

✅ State Management: Supports BLoC / Cubit (or other plugable options).

✅ Repository Pattern: Abstract data sources for flexibility and testability.

✅ Error Handling: Centralized failure management and clean result modeling.

✅ Easy to Extend: Ideal for medium to large-scale projects.

📁 Folder Structure
bash
نسخ
تحرير
lib/
│
├── core/                # Common utilities and base classes
├── features/            # Feature-wise module separation
│   └── feature_name/
│       ├── data/
│       ├── domain/
│       └── presentation/
├── injection_container.dart
└── main.dart
🚀 Getting Started
Clone the repo.

Run flutter pub get.

Start adding your features inside the features/ directory.

🧱 Tech Stack
Flutter

BLoC / Cubit (or your choice of state management)

GetIt (Dependency Injection)

Multi_Result (Optional - functional programming helpers)

Equatable

Retrofit or Dio (for networking)

📌 Why Use This Template?
This template is intended to reduce boilerplate and encourage separation of concerns from the start of your Flutter project. It is perfect for developers who want a head start on building production-level apps using clean architectural principles.

#------------------------------------------- APP_Guide --------------------------------------------------
# Project Title :  APP_NAM#

# Project BackEnd : PHP OR ASP.NET

## Project Description : APP_SECRIPTION

**The main idea**

**Types of users**

1. USERS


**FLUTTER_VERSION** : 3.35.1

## Links for development :

1. [postman collection](ADD_LINK_HERE)

2. [UI](https://www.figma.com/file/s9QmhNNydNNXmi0zDY2bmi/%D9%85%D8%B3%D8%A7%D8%B9%D8%AF%20%D8%A7%D9%84%D8%AC%D9%87%D9%86%D9%8A?node-id=3%3A2&fuid=1516736957570962438)

3. [Test_file](TEST_FILE_LINK)

## Dashboard :

1. [Link](DASHBOARD_LINK)
2. dashboard account :
   - email : EMAIL
   - password : PASS

## Accounts for App :
[USER]===> 


## Links for project :

1. [App in app store]()
2. [App in google play]()

## Google Key Data :

- GOOGLE_MAP_KEY

## App Bundle :

- APP_BUNDLE

## FireBase :

1. FIREBASE_ACCOUNT_HOLDER
   - 
2. PROJECT_NAME_IN_FIREBASE
   - 

## Team members :

1. **Flutter**
   - DEVELOPER_NAME

2. **Backend**
   - DEVELOPER_NAME

3. **Testing**
   - DEVELOPER_NAME

## Image :

![Logo](assets/svg/logo.svg)


## Localization Generator:

### Run this Command to generate localization files
```bash
dart run generate/strings/main.dart
```

## Assets Generator:
### Run this command to activate assets generator
```bash
dart pub global activate flutter_gen
```

### Run this Command to generate app icons
```bash
dart run build_runner build
```
### Run This Command To Generate Feature Used in This Project By Script
```bash
dart scripts/create_feature.dart +feature name
```

### Run This Command To Generate Models 
```bash
dart run tool/generate_models.dart
```
### After Files generate Run This Command 
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

