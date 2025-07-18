# AirVix Smart AC Remote Control - Setup Guide

## 🔧 Firebase Setup Instructions

This project uses Firebase for authentication and real-time database. Follow these steps to set up Firebase:

### 1. Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or use existing one
3. Enable Firebase Authentication (Email/Password)
4. Enable Firebase Realtime Database

### 2. Configure Android App
1. Add an Android app to your Firebase project
2. Use package name: `com.example.airvix`
3. Download `google-services.json` file
4. Place it in `android/app/google-services.json`

### 3. Generate Firebase Options
1. Install Firebase CLI: `npm install -g firebase-tools`
2. Login: `firebase login`
3. Run: `flutterfire configure`
4. This will generate `lib/firebase_options.dart`

### 4. Update Database URL
Replace the database URL in the following files with your Firebase project URL:
- `lib/main.dart`
- `lib/screens/geofencing_page.dart`

Example URL format: `https://your-project-id-default-rtdb.region.firebasedatabase.app/`

### 5. Security Rules
Set up Firebase Realtime Database rules for your use case.

## 🔐 Security Notes
- Never commit `firebase_options.dart` or `google-services.json` to public repositories
- These files are automatically ignored by `.gitignore`
- Use the template files as reference for structure

## 📱 Running the App
1. Ensure all Firebase files are properly configured
2. Run `flutter pub get`
3. Run `flutter run`
