plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.aait.flutter.sitr"
    compileSdk = 36
    ndkVersion = "28.2.13676358"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }


    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.aait.flutter.sitr"

        minSdk = flutter.minSdkVersion
        targetSdk = 36

        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
//            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
            // لازم الاتنين ميتفتحوش الا عند التسليم والرفع الاستور لانهم وظيفتهم لتقليل حجم التطبيق ودمج الكلاسات ويحذف الللغات واللاي اوت اللي مش مستخدم
            isMinifyEnabled = true     // ✅ صحيح
            isShrinkResources = true  // ✅ أضف السطر ده
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )

        }
        debug {
            signingConfig = signingConfigs.getByName("debug")
        }
    }

}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5") // ✅
}

flutter {
    source = "../.."
}
