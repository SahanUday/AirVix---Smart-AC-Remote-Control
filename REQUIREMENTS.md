# AirVix Smart AC Remote Control - Requirements

## 📋 System Requirements

### Development Environment
- **Flutter SDK**: 3.7.2 or higher
- **Dart SDK**: Compatible with Flutter version
- **Android Studio**: Latest stable version (recommended IDE)
- **VS Code**: Alternative IDE option
- **Git**: For version control

### Platform Requirements
- **Android**: API level 23 (Android 6.0) or higher
- **Target SDK**: Latest stable Android SDK
- **NDK Version**: 27.2.12479018

### Hardware Requirements
- **Android Device/Emulator**: For testing
- **Minimum RAM**: 4GB (8GB recommended)
- **Storage**: At least 10GB free space

## 📦 Flutter Dependencies

### Production Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  firebase_core: ^3.14.0
  firebase_ui_auth: ^1.17.0
  firebase_auth: ^5.6.0
  firebase_database: ^11.3.8
  intl: ^0.19.0
  fluttertoast: ^8.2.12
  geolocator: ^14.0.2
```

### Development Dependencies
```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.14.4
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
```

## 🔥 Firebase Services Required

### Firebase Configuration
- **Firebase Authentication**: Email/Password sign-in
- **Firebase Realtime Database**: Real-time data synchronization
- **Firebase Core**: Base Firebase functionality

### Firebase Setup Requirements
1. Firebase project with Authentication enabled
2. Realtime Database configured
3. `google-services.json` file (Android)
4. `firebase_options.dart` file (generated via FlutterFire CLI)

## 🛠 Build Tools & Gradle

### Android Build Configuration
- **Gradle**: Kotlin DSL
- **Compile SDK**: Flutter's compile SDK version
- **Min SDK**: 23
- **Target SDK**: Flutter's target SDK version
- **Java Version**: 11
- **Kotlin JVM Target**: 11

### Required Gradle Plugins
- `com.android.application`
- `com.google.gms.google-services` (Firebase)
- `kotlin-android`
- `dev.flutter.flutter-gradle-plugin`

## 📱 Permissions Required

### Android Permissions
- **Location Access**: For geofencing functionality
  - `ACCESS_FINE_LOCATION`
  - `ACCESS_COARSE_LOCATION`
- **Internet Access**: For Firebase connectivity
  - `INTERNET`
  - `ACCESS_NETWORK_STATE`

## 🔧 Additional Tools

### Development Tools
- **Firebase CLI**: For project configuration
- **FlutterFire CLI**: For Firebase setup
- **Android SDK**: For Android development
- **Node.js**: Required for Firebase CLI

### Installation Commands
```bash
# Install Flutter dependencies
flutter pub get

# Install Firebase CLI (requires Node.js)
npm install -g firebase-tools

# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Check Flutter environment
flutter doctor
```

## 🌐 External Services

### Required Services
- **Firebase Project**: Active Firebase project with proper configuration
- **Google Services**: Google Play Services on target devices
- **Location Services**: Device location services enabled

## 📊 Performance Requirements

### Minimum Device Specifications
- **RAM**: 2GB minimum, 4GB recommended
- **Storage**: 100MB free space for app
- **Network**: Internet connection required for Firebase features
- **GPS**: For location-based features

## 🔒 Security Requirements

### API Keys & Configuration
- Firebase API keys (kept in ignored files)
- Google Services configuration
- Proper signing certificates for release builds

### Development vs Production
- **Debug Mode**: Uses debug signing
- **Release Mode**: Requires proper signing configuration
- **Environment Variables**: For sensitive data management

## 📋 Pre-Installation Checklist

- [ ] Flutter SDK installed and configured
- [ ] Android Studio/VS Code installed
- [ ] Firebase project created
- [ ] Firebase services enabled
- [ ] `google-services.json` downloaded
- [ ] Firebase CLI installed
- [ ] FlutterFire CLI installed
- [ ] Android device/emulator ready

## 🚀 Quick Start

1. **Clone Repository**:
   ```bash
   git clone <repository-url>
   cd AirVix_Smart-AC-Remote-Control
   ```

2. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**:
   - Follow instructions in `FIREBASE_SETUP.md`

4. **Run Application**:
   ```bash
   flutter run
   ```

## 📞 Support

For issues related to:
- **Flutter**: [Flutter Documentation](https://docs.flutter.dev/)
- **Firebase**: [Firebase Documentation](https://firebase.google.com/docs)
- **Android**: [Android Developer Documentation](https://developer.android.com/)

---

**Note**: This project is configured for Android development. iOS support would require additional setup and dependencies.
