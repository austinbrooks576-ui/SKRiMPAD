# SKRiMPAD APK Build Guide

## Prerequisites

1. **Android Studio** (latest version recommended)
   - Download from: https://developer.android.com/studio
   
2. **Android SDK** (API 34 - required by this project)
   - Installed via Android Studio SDK Manager
   
3. **Java Development Kit (JDK) 11+**
   - Included with Android Studio
   
4. **Gradle** (8.2.2)
   - Handled by Android Studio

## Build Instructions

### Option 1: Android Studio (Easiest)

1. **Open Project**
   ```
   File → Open → Select the android/ folder
   ```

2. **Sync Gradle**
   - Android Studio will automatically sync dependencies
   - Wait for "Gradle sync finished" message

3. **Build Release APK**
   ```
   Build → Build Bundle(s) / APK(s) → Build APK(s)
   ```

4. **Find Your APK**
   - Located at: `android/app/build/outputs/apk/release/app-release.apk`
   - Or click "Locate" in the build complete dialog

### Option 2: Command Line (Advanced)

1. **Navigate to Android Directory**
   ```bash
   cd android
   ```

2. **Clean Build (Optional)**
   ```bash
   ./gradlew clean
   ```

3. **Build Release APK**
   ```bash
   ./gradlew assembleRelease
   ```

4. **Find APK**
   ```bash
   app/build/outputs/apk/release/app-release.apk
   ```

## Signing the APK (Production Release)

For distribution on Google Play or sharing widely, sign the APK:

1. **Generate Keystore** (one-time)
   ```bash
   keytool -genkey -v -keystore ~/my-release-key.keystore \
     -keyalg RSA -keysize 2048 -validity 10000 \
     -alias my-key-alias
   ```

2. **Configure Signing in `build.gradle`**
   ```gradle
   signingConfigs {
       release {
           storeFile file(System.getenv("KEYSTORE_PATH") ?: "path/to/keystore")
           storePassword System.getenv("KEYSTORE_PASSWORD")
           keyAlias System.getenv("KEY_ALIAS")
           keyPassword System.getenv("KEY_PASSWORD")
       }
   }
   
   buildTypes {
       release {
           signingConfig signingConfigs.release
           minifyEnabled false
           proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
       }
   }
   ```

3. **Build Signed APK**
   ```bash
   export KEYSTORE_PATH=~/my-release-key.keystore
   export KEYSTORE_PASSWORD=your_password
   export KEY_ALIAS=my-key-alias
   export KEY_PASSWORD=your_password
   
   ./gradlew assembleRelease
   ```

## Testing the APK

### On Emulator
1. Open Android Emulator (AVD Manager)
2. Run the emulator
3. Drag & drop APK onto emulator, or:
   ```bash
   adb install app/build/outputs/apk/release/app-release.apk
   ```

### On Physical Device
1. Enable USB Debugging on device (Settings → Developer Options)
2. Connect via USB
3. ```bash
   adb install app/build/outputs/apk/release/app-release.apk
   ```

4. Launch "SKRiMPAD" from app drawer

## Build Variants

### Debug Build (Faster, includes debugger)
```bash
./gradlew assembleDebug
# Output: app/build/outputs/apk/debug/app-debug.apk
```

### Release Build (Optimized, smaller, faster)
```bash
./gradlew assembleRelease
# Output: app/build/outputs/apk/release/app-release.apk
```

## Troubleshooting

### Gradle Sync Fails
- File → Sync Now
- Check Android SDK is installed (Tools → SDK Manager)
- Update Gradle: File → Settings → Build Tools → Gradle

### Build Fails: "compileSdk 34 not found"
```bash
# Open SDK Manager and install API 34
sdkmanager "platforms;android-34"
```

### Emulator Not Detecting APK
- Ensure emulator is running
- Restart adb: `adb kill-server && adb start-server`
- Reinstall: `adb install -r app/build/outputs/apk/release/app-release.apk`

### JavaScript Not Loading
- Verify `index.html` exists at `app/src/main/assets/index.html`
- Check WebView settings in `MainActivity.kt` line 44-52

## App Details

- **Package Name**: `com.firstriff.studio`
- **Min SDK**: 24 (Android 7.0)
- **Target SDK**: 34 (Android 14)
- **Version**: 1.0.0
- **Main Activity**: `MainActivity.kt`
- **Web Root**: `android/app/src/main/assets/index.html`

## Distribution

### Google Play Store
1. Create Google Play Developer account ($25 one-time)
2. Prepare app listing, screenshots, description
3. Upload signed APK (or AAB format recommended)
4. Set pricing and availability
5. Submit for review (24-48 hours typically)

### Direct Distribution
- Share APK file directly (works on Android 7.0+)
- Users must enable "Unknown Sources" in Security settings
- No review process, but less discoverable

## Build Optimization

For smaller APK size:
```gradle
buildTypes {
    release {
        minifyEnabled true
        proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
    }
}
```

## Support

For Android build issues:
- https://developer.android.com/build
- https://stackoverflow.com/questions/tagged/android-gradle
- Check logcat for WebView or permission errors: `adb logcat`