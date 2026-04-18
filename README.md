# 🎓 VVCE Timetable App

A beautiful, feature-rich Flutter timetable app for **VVCE Mysore** — 2nd Semester, CSE, Section G.

![Flutter](https://img.shields.io/badge/Flutter-3.24-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0-blue?logo=dart)
![Android](https://img.shields.io/badge/Platform-Android-green?logo=android)
![License](https://img.shields.io/badge/License-MIT-yellow)

---

## 📱 Screens

| Screen | Description |
|--------|-------------|
| **Splash** | Animated VVCE logo with gradient background |
| **Login** | Student name, USN, section with validation |
| **Timetable** | Daily schedule with subject cards, live indicator |

---

## ✨ Features

- 🎨 **Material 3 Design** with beautiful UI
- 🌙 **Dark / Light Mode** toggle with persistence
- 📅 **Mon–Fri timetable** with swipe navigation
- 🟢 **Live class indicator** — highlights the ongoing class
- 📊 **Weekly stats** — subject count overview
- 👤 **Personalized** with student name & USN
- 💾 **SharedPreferences** — login data persists across sessions
- 🔐 **Logout** with confirmation dialog
- 🎭 **Smooth animations** using `flutter_animate`
- 📱 **Portrait-locked** for consistent layout

---

## 🎨 Subject Color Coding

| Subject | Icon | Color |
|---------|------|-------|
| Mathematics | 🧮 calculate | Purple |
| Chemistry | 🔬 science | Teal |
| C Programming (PLCS) | 💻 code | Blue |
| Electrical & Civil (IECK) | ⚡ electrical_services | Red |
| Artificial Intelligence | 🤖 smart_toy | Orange |
| English | 📖 menu_book | Green |
| Labs | 🧬 biotech | Brown |
| Physical Education | ⚽ sports_soccer | Cyan |

---

## 🗂️ Project Structure

```
lib/
├── main.dart                    # App entry point
├── models/
│   └── timetable_model.dart     # Data models
├── data/
│   └── timetable_data.dart      # Full Section G timetable
├── utils/
│   ├── app_theme.dart           # Theme, colors, icons
│   └── prefs_service.dart       # SharedPreferences wrapper
├── screens/
│   ├── splash_screen.dart       # Splash with animation
│   ├── login_screen.dart        # Login form
│   └── timetable_screen.dart    # Main timetable view
└── widgets/
    ├── subject_card.dart        # Subject slot card
    ├── day_selector.dart        # Horizontal day tabs
    ├── stats_widget.dart        # Weekly subject stats
    └── vvce_logo.dart           # Custom painted VVCE logo
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter 3.24+
- Android Studio / VS Code
- Android SDK (for APK build)

### Run Locally
```bash
git clone https://github.com/YOUR_USERNAME/vvce_timetable.git
cd vvce_timetable
flutter pub get
flutter run
```

### Build APK
```bash
# Debug APK
flutter build apk --debug

# Release APK (split by ABI)
flutter build apk --release --split-per-abi
```

---

## 🤖 GitHub Actions (Auto Build APK)

This repo includes a CI/CD workflow at `.github/workflows/build_apk.yml`.

**Triggers:**
- Push to `main` or `master`
- Pull requests
- Manual trigger via "Run workflow"

**Outputs:**  
APKs are available under **Actions → Artifacts** after each build.

### To create a versioned release:
```bash
git tag v1.0.0
git push origin v1.0.0
```
This automatically creates a GitHub Release with all APK variants attached.

---

## 📦 Dependencies

```yaml
shared_preferences: ^2.2.2   # Persistent storage
google_fonts: ^6.1.0          # Poppins font
flutter_animate: ^4.5.0       # Smooth animations
intl: ^0.19.0                  # Date/time formatting
lottie: ^3.0.0                 # Lottie animations (ready to use)
```

---

## 👨‍💻 Timetable Data (Section G)

| Day | Subjects |
|-----|---------|
| **Monday** | MAT → CHE → PLCS → IECK → AIK → ENG → PLCS |
| **Tuesday** | ENG → MAT → AIK → IECK → CHE → **CHELAB (3hr)** |
| **Wednesday** | PLCS → IECK → MAT → CHE → ENG → AIK → PE |
| **Thursday** | AIK → ENG → CHE → MAT → PLCS → **PLCSLAB (3hr)** |
| **Friday** | IECK → PLCS → ENG → AIK → MAT → IECK → CHE |

---

## 📄 License

MIT License © 2024 VVCE Timetable Project
