plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("org.jetbrains.kotlin.android") // Corrected Kotlin plugin ID for Kotlin DSL
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.chat_vibe"
    compileSdk = flutter.compileSdkVersion // Automatically uses the Flutter SDK's compile SDK version
    ndkVersion = "27.3.13750724" // Good to specify if you have NDK dependencies

    defaultConfig {
        applicationId = "com.example.chat_vibe"
        minSdk = 24 // Keep your minimum SDK
        targetSdk = 34 // Keep your target SDK

        // Required for desugaring support when targeting older minSdk with Java 8+ features
        multiDexEnabled = true
    }

    compileOptions {
        // Align these with your desired Java version.
        // If you are using Java 17 for your project/JVM, set these to 17.
        // Otherwise, keep it at 11 or a version that matches your actual JDK/JVM environment.
        sourceCompatibility = JavaVersion.VERSION_21
        targetCompatibility = JavaVersion.VERSION_21
        isCoreLibraryDesugaringEnabled = true 
    }

    kotlinOptions {
        // Align this with your compileOptions and java.toolchain.languageVersion
        jvmTarget = 21
        //JavaVersion.VERSION_17.toString() // Recommended to align
    }

    // This section ensures Gradle uses a specific JDK version for compiling Java/Kotlin code.
    // It's highly recommended for build reproducibility.
    // Ensure you have JDK 17 installed on your system or let Gradle download it.
    java.toolchain.languageVersion.set(JavaLanguageVersion.of(17))

    buildTypes {
        getByName("debug") {
            // Debug builds typically do not minify or shrink resources for faster iteration
            isMinifyEnabled = false
            isShrinkResources = false // Also disable resource shrinking for debug
        }
        getByName("release") {
            // !!! IMPORTANT: This is currently using your debug signing config.
            // FOR PRODUCTION: You MUST replace this with your actual release signing config!
            // Example: signingConfig = signingConfigs.getByName("release")
            // And define your "release" signing config earlier in the 'android' block or in your 'signingConfigs' block.
            signingConfig = signingConfigs.getByName("debug") // <-- CHANGE THIS FOR PRODUCTION APKS

            // Crucial: Enable R8 for code shrinking and obfuscation
            isMinifyEnabled = true

            // Optional: Enable resource shrinking (highly recommended for smaller APKs)
            isShrinkResources = true

            // Crucial: Point to your ProGuard rules file.
            // "proguard-android-optimize.txt" is Android's default.
            // "proguard-rules.pro" is your custom rules file.
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.." // Standard Flutter project source location
}

// THIS `dependencies` BLOCK MUST BE AT THE ROOT LEVEL OF THE build.gradle.kts FILE,
// OUTSIDE of the `android { ... }` and `flutter { ... }` blocks.
dependencies {
    // Only keep the newer, single desugaring library. Remove the duplicate 2.0.4.
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
    
    // MultiDex is needed for apps with a large number of methods when minSdk is < 21,
    // which your minSdk 24 benefits from if you have many libraries.
    implementation("androidx.multidex:multidex:2.0.1")

    // Add any other app-level dependencies here (e.g., if you had specific native Android libraries)
    // For example:
    // implementation("com.google.android.material:material:1.x.x")
}