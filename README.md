# 📱 Smart AC Remote Control – AirVix

This project is a **smart air conditioning remote control app** built using **Flutter** and **Firebase**, developed by [Your Name/Team Name]. Designed for Android, it enables users to control their AC unit remotely with features like geofencing, AI-driven temperature adjustments, and scheduling for enhanced comfort and energy efficiency.

---

## 📌 Overview

The **Smart AC Remote Control** is an Android mobile application that:

* Allows users to **control their AC** (power, temperature, mode) remotely.
* Integrates **geofencing** to automatically turn the AC on/off based on the user's location.
* Uses **AI-based smart control** to adjust settings based on sensor data and user feedback.
* Provides **scheduling** for automated AC operation.
* Displays real-time **sensor data** (temperature, humidity, occupancy, weather).
* Integrates with **Firebase Realtime Database** for seamless data management.

It’s an intuitive solution for smart home automation, ideal for Android users seeking convenience and energy savings.

---

## 🔍 Key Features

* 🚀 **AC Control**: Turn AC on/off, set temperature, and select modes (Cool, Heat, Fan, Dry).
* 📍 **Geofencing**: Automatically control AC based on user’s proximity to home.
* 🧠 **Smart AI Control**: AI adjusts temperature based on occupancy, sensor data, and user feedback.
* ⏰ **Scheduling**: Set timers and actions for automated AC control.
* 📊 **Real-Time Data**: View indoor/outdoor temperature, humidity, occupancy, and weather.
* 💬 **User Feedback**: Provide feedback (e.g., too hot, too cold) and activity type for AI optimization.
* 🔥 **Firebase Integration**: Real-time data sync with Firebase Realtime Database.
* 🔒 **Secure Login**: Email-based authentication using Firebase UI Auth.

---

## 🔧 Technologies & Tools Used

* **Flutter** – Cross-platform mobile app framework (Android-only build)
* **Firebase Realtime Database** – Real-time data storage and synchronization
* **Firebase UI Auth** – Secure email-based authentication
* **Geolocator** – Location-based geofencing functionality
* **Fluttertoast** – User notifications and feedback
* **Dart** – Programming language for Flutter
* **Android Studio** – Recommended IDE for development

> ![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?logo=flutter&logoColor=white)
> ![Firebase](https://img.shields.io/badge/Firebase-%23FFCA28.svg?logo=firebase&logoColor=black)
> ![Dart](https://img.shields.io/badge/Dart-%230175C2.svg?logo=dart&logoColor=white)
> ![Android Studio](https://img.shields.io/badge/Android_Studio-%233DDC84.svg?logo=android-studio&logoColor=white)

---

## ⚙️ How It Works

1. Users **log in** using email authentication.
2. The **Home Page** displays real-time sensor data and allows manual AC control (power, temperature, mode).
3. **Geofencing** detects the user’s location and triggers predefined AC actions (e.g., turn on when entering home).
4. **Smart Control** uses AI to adjust settings based on occupancy and user feedback.
5. **Scheduler** allows setting timers and actions for automated AC operation.
6. All data and commands are synced with **Firebase Realtime Database**.

---

## 🧰 Setup & Run Guide (Android Studio)

### ✅ Requirements

* Flutter 3.0.0+
* Dart (compatible with Flutter version)
* Firebase Account ([Firebase Console](https://console.firebase.google.com/))
* Android Studio
* Git
* Android device or emulator

---

### 🔐 Set Up Firebase

1. Create a Firebase project in the [Firebase Console](https://console.firebase.google.com/).
2. Add an Android app and download the `google-services.json` file to `android/app/`.
3. Update the Firebase Realtime Database URL in `geofencing_page.dart`:
   ```dart
   final dbRef = FirebaseDatabase.instanceFor(
     app: Firebase.app(),
     databaseURL: 'https://your-project-id.firebaseio.com/',
   ).ref();
   ```
4. Enable Firebase Realtime Database and configure rules.

---

### 🚀 Run the Project Locally

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/your-username/smart-ac-remote-control.git
   cd smart-ac-remote-control
   ```

2. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

3. **Add Assets**:
   - Place `icon1.png` in `assets/images/`.
   - Update `pubspec.yaml`:
     ```yaml
     assets:
       - assets/images/icon1.png
     ```

4. **Run the App**:
   - Connect an Android device or start an emulator.
   - Run:
     ```bash
     flutter run
     ```

---

## 📲 APK Download

Download the latest APK for Android devices:

📁 [Download APK](apk/app-release.apk)

> **Note**: Ensure your Android device allows installation from unknown sources.

---

## 🧪 Demo

Here’s a quick video demo of how the Smart AC Remote Control works:

🎥 **Demo Video**:  
👉 [Click to watch the demo video](demo/demo_vid.mp4)

📸 **Login Page**
<table>
  <tr>
    <td>
      <img width="200" height="854" src="https://raw.githubusercontent.com/SahanUday/AirVix-App_Smart-AC-Remote-Control-App/main/demo/login.png" />
    </td>
    <td>
      Features a simple email-based login using Firebase UI Auth. Users enter their credentials, and upon successful login, they are redirected to the Home Page. The app logo (`icon1.png`) is displayed prominently.
    </td>
  </tr>
</table>

📸 **Home Page**
<table>
  <tr>
    <td>
      <img width="200" height="854" src="https://raw.githubusercontent.com/SahanUday/AirVix-App_Smart-AC-Remote-Control-App/main/demo/home.png" />
    </td>
    <td>
      Displays real-time sensor data (indoor/outdoor temperature, humidity, weather, occupancy) synced from Firebase. Users can manually control the AC (power toggle, temperature adjustment with +/- buttons, and mode selection: Cool, Heat, Fan, Dry) via an intuitive interface with a circular temperature display.
    </td>
  </tr>
</table>

📸 **Smart Control Page**
<table>
  <tr>
    <td>
      <img width="200" height="854" src="https://raw.githubusercontent.com/SahanUday/AirVix-App_Smart-AC-Remote-Control-App/main/demo/smart_control.png" />
    </td>
    <td>
      Enables AI-driven temperature adjustments based on sensor data and user input. Features toggles for Smart AC Control and Occupancy Auto-ON/OFF, along with dropdowns for feedback (e.g., too hot, comfortable) and activity type (e.g., relaxing, working) to refine AI recommendations.
    </td>
  </tr>
</table>

📸 **Geofencing Page**
<table>
  <tr>
    <td>
      <img width="200" height="854" src="https://raw.githubusercontent.com/SahanUday/AirVix-App_Smart-AC-Remote-Control-App/main/demo/geofencing.png" />
    </td>
    <td>
      Allows users to enable geofencing to automatically control the AC based on their location. Includes options to set entry/exit actions (e.g., AC_ON, cool_24) and edit the geofence area (latitude, longitude, radius) with real-time status updates (Home/Away).
    </td>
  </tr>
</table>

📸 **Scheduler Page**
<table>
  <tr>
    <td>
      <img width="200" height="854" src="https://raw.githubusercontent.com/SahanUday/AirVix-App_Smart-AC-Remote-Control-App/main/demo/schedule.png" />
    </td>
    <td>
      Offers scheduling functionality with a toggle to enable/disable schedules, duration selection (e.g., 30s, 1h, 4h) using choice chips, and an action dropdown (e.g., AC_OFF, cool_20) to automate AC commands based on set timers.
    </td>
  </tr>
</table>

> 🏠 Control your AC effortlessly with smart automation and real-time insights!

---

## 🤝 Contribution

We welcome contributions to enhance features like:
* 📊 Energy usage analytics
* 🧠 Advanced AI algorithms for temperature optimization
* ⏱️ Support for multiple AC units
* 🔐 Enhanced security features

To contribute:
1. Fork the repo.
2. Create a feature branch (`git checkout -b feature/your-feature`).
3. Commit changes (`git commit -m "Add your feature"`).
4. Push to the branch (`git push origin feature/your-feature`).
5. Create a pull request.

---

## 🛠 Built With

* 🖥️ Flutter – Mobile app framework for Android
* 🔥 Firebase Realtime Database – Real-time data management
* 🔒 Firebase UI Auth – Secure authentication
* 📍 Geolocator – Location-based services
* 🔔 Fluttertoast – Notification toasts
* 🐍 Dart – Programming language
* 🧩 Android Studio – Development environment

---

## 📜 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
