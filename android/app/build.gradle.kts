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
    namespace = "com.varungg.popapp"
    compileSdk = 36
    defaultConfig {
        applicationId = "com.varungg.popapp"
        minSdk = flutter.minSdkVersion
        targetSdk = 36
        versionCode = 1
        versionName = "1.0"
    }

    signingConfigs {
        create("release") {
            keyAlias = "key"        
            keyPassword = "Varun@4044"           
            storeFile = file("my-release-key.jks")
            storePassword = "Varun@4044"          
        }
    }

    buildTypes {
        getByName("debug") {
            isMinifyEnabled = false  
            isShrinkResources = false
        }

        getByName("release") {
            isMinifyEnabled = true          // R8/ProGuard ON
            isShrinkResources = true        // Strip unused resources
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            signingConfig = signingConfigs.getByName("release")
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }
}


flutter {
    source = "../.."
}
