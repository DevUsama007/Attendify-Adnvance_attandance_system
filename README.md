# Attendify - Advanced Attendance System

<p align="center">
  <img src="https://github.com/DevUsama007/Attendify-Adnvance_attandance_system/blob/main/attendify.png" alt="Attendify Logo" width="150"/>
  <br>
  <strong>A modern, secure, and automated attendance management system built with Flutter.</strong>
  <br>
  Combines geolocation fencing and facial recognition to eliminate proxy attendance.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.19.5-blue?style=for-the-badge&logo=flutter" alt="Flutter"/>
  <img src="https://img.shields.io/badge/Dart-3.3.0-blue?style=for-the-badge&logo=dart" alt="Dart"/>
  <img src="https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black" alt="Firebase"/>
  <img src="https://img.shields.io/badge/GetX-State%20Management-green?style=for-the-badge" alt="GetX"/>
  <img src="https://img.shields.io/badge/MVVM-Architecture-orange?style=for-the-badge" alt="MVVM"/>
</p>

---

## 📖 Overview

Attendify is a robust, dual-panel attendance application designed for organizations that require a reliable and fraud-proof method to track employee attendance. It leverages **Geofencing** via Google Maps and **on-device Facial Authentication** to ensure that attendance is only marked when an employee is physically present at the designated location.

- **Admin Panel:** Manage employees, register their facial data, and monitor real-time attendance reports.
- **User Panel:** Employees can securely check in and out by verifying their location and identity.

---

## ✨ Key Features

### 🔐 Multi-Factor Authentication
- **Geolocation Verification:** Uses Google Maps Polygon to create a virtual geofence around the office. Attendance is only allowed if the user's device is inside this boundary.
- **Facial Biometric Authentication:** Captures a live image via the device camera and uses ML Kit & TFLite to match the employee's face against pre-registered embeddings stored securely in Firebase.

### 👨‍💻 Admin Panel
- Add, view, and manage employees.
- Register facial data for new employees through an intuitive camera interface.
- View and export detailed attendance reports for any employee or date range.

### 👤 User Panel
- Secure login using credentials provided by the admin.
- Simple check-in/check-out workflow that automatically triggers location and face verification.
- View personal attendance history.

### 📊 Real-Time Dashboard
- Admins get a live overview of who is currently checked in, late, or absent.
- Data is synced in real-time using Cloud Firestore.

### 🔔 Push Notifications
- Users receive instant confirmation upon successful check-in/out.
- Admins can be alerted for specific events (e.g., failed authentication attempts).

---

## 🛠️ Tech Stack & Tools

| Category          | Technology                                                                                             |
| ----------------- | ------------------------------------------------------------------------------------------------------ |
| **Framework**     | Flutter                                                                                                |
| **Language**      | Dart                                                                                                   |
| **Architecture**  | MVVM (Model-View-ViewModel)                                                                            |
| **State Management** | GetX                                                                                                 |
| **Backend & Database** | Firebase (Authentication, Cloud Firestore)                                                         |
| **Geolocation**   | `geolocator`, `google_maps_flutter` (Polygon drawing and point-in-polygon checks)                      |
| **Camera**        | `camera`                                                                                               |
| **Machine Learning** | `google_ml_kit` (Face Detection), `tflite_flutter` (Facial Recognition & Embedding Matching)         |
| **Notifications** | `flutter_local_notifications`                                                                          |
| **Development**   | Android Studio, Git                                                                                    |

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.19.5)
- Dart SDK (>=3.3.0)
- A Firebase project with Firestore and Authentication enabled.
- Google Maps API key (for geofencing).

### Installation

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/your_username/attendify.git
    cd attendify
    ```

2.  **Get dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Setup Firebase:**
    - Create a new project in the [Firebase Console](https://console.firebase.google.com/).
    - Enable **Authentication** and **Firestore Database**.
    - Download your `google-services.json` file and place it in the `android/app` directory.

4.  **Configure Google Maps:**
    - Get an API key from the [Google Cloud Platform](https://cloud.google.com/).
    - Add the key in `android/app/src/main/AndroidManifest.xml` and `ios/Runner/AppDelegate.swift`.

5.  **Run the app:**
    ```bash
    flutter run
    ```

---

## 📱 Usage

1.  **Admin Flow:**
    - Log in to the admin panel.
    - Add an employee by filling in details (name, email) and registering their face via the camera.
    - View the dashboard to see live attendance.

2.  **Employee Flow:**
    - Log in with provided credentials.
    - Press "Check In." The app will verify your location and then your face.
    - Upon success, your attendance is recorded, and you receive a notification.

---

## 🔧 Configuration

Important configuration files and steps:
- `lib/firebase_options.dart`: Configure your Firebase options.
- `android/app/src/main/AndroidManifest.xml`: Add your Google Maps API key.
- `ios/Runner/AppDelegate.swift`: Add your Google Maps API key for iOS.

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](https://github.com/your_username/attendify/issues).

1. Fork the Project.
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`).
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`).
4. Push to the Branch (`git push origin feature/AmazingFeature`).
5. Open a Pull Request.

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Developer

**Usama Basharat**

- Portfolio: [Your Portfolio Link]
- LinkedIn: [Your LinkedIn Profile Link]
- Email: your.email@example.com

---

## 🙏 Acknowledgments

- Flutter team for the amazing framework.
- Firebase and Google ML Kit for powerful backend and ML tools.
- The open-source community for invaluable packages.
