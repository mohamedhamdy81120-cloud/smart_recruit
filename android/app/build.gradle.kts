plugins {
    id("com.android.application")
    id("kotlin-android")

    // Flutter Gradle Plugin (لازم بعد Android & Kotlin)
    id("dev.flutter.flutter-gradle-plugin")

    // Google Services (Firebase)
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.smart_recruit"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        applicationId = "com.example.smart_recruit"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    // Firebase BoM (مهم جدًا)
    implementation(platform("com.google.firebase:firebase-bom:34.9.0"))

    // Firebase Analytics (كفاية كبداية)
    implementation("com.google.firebase:firebase-analytics")
}

flutter {
    source = "../.."
}