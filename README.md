<h1 align="center">🩺 Health Insight Tracker</h1>

<p align="center">
  <strong>Premium Flutter Health Tracking Application</strong><br/>
  Clean Architecture • Provider State Management • Hive NoSQL • Glassmorphic UI
</p>

<p align="center">
  A professional-grade, offline-first mobile app for tracking daily health vitals 
  including mood, sleep duration, and water intake — built with scalability and 
  architectural discipline in mind.
</p>

---

## 📌 Overview

**Health Insight Tracker** is a high-fidelity Flutter application designed to demonstrate:

- Advanced state management using **Provider**
- Feature-first **Clean Architecture**
- High-performance local persistence with **Hive (NoSQL)**
- Glassmorphic UI system with custom painters
- Offline-first reliability
- Reactive analytics with 7-day trend intelligence

This project serves as both a production-ready foundation and a portfolio-level showcase of modern Flutter engineering.

---

## 🚀 Key Features

### 📝 Daily Health Logging
- Mood tracking
- Sleep duration input (with 24-hour validation cap)
- Water intake recording
- One-entry-per-day enforcement

### 📊 7-Day Analytics Engine
- Automatic rolling average calculations
- Mood frequency insights
- Week-over-week comparison indicators
- Performance trend visualization

### 🛡 Intelligent Data Validation
- Input guardrails for data integrity
- Logical sleep boundaries
- Duplicate-entry prevention

### 🎨 Premium User Experience
- Custom glassmorphism design system
- Parallax onboarding transitions
- Staggered list animations
- Micro-interaction feedback

### 🌐 Offline-First Architecture
- Instant read/write operations
- Zero network dependency
- Persistent local storage using Hive

---

## 🏗 Architecture

This project follows a **Feature-First Clean Architecture** pattern for scalability and maintainability.

### 📂 Layer Breakdown

#### Data Layer
- Hive database initialization
- TypeAdapters
- Local repository implementations

#### Domain Layer
- Business logic abstraction
- Centralized state authority via `HealthProvider`
- Single Source of Truth principle

#### Presentation Layer
- Reusable widgets
- Modular UI components
- Custom painters (e.g., `GridPainter`)
- Strict separation of concerns

---

## 🛠 Tech Stack

| Category | Technology |
|----------|------------|
| Framework | Flutter |
| Language | Dart |
| State Management | Provider |
| Local Database | Hive (NoSQL) |
| Architecture | Clean Architecture (Feature-First) |
| Code Generation | build_runner |
| Testing | Flutter Test |

---

## 📊 Project Structure

```plaintext
lib/
├── core/               # Themes, constants, custom painters
├── features/
│   └── health/
│       ├── data/       # Models, data sources, repositories
│       ├── domain/     # Use cases (optional abstraction)
│       └── presentation/
│           ├── providers/
│           ├── screens/
│           └── widgets/
└── main.dart
```

---

## 🎥 App Walkthrough

> Includes entry logging flow, analytics calculations, and theme toggling.
<img width="360" height="720" alt="Screenshot_20260303_222442" src="https://github.com/user-attachments/assets/3083bd8a-5e26-4779-b6e2-a56ac79e341f" />
<img width="360" height="720" alt="Screenshot_20260303_222458" src="https://github.com/user-attachments/assets/79c20ecb-4449-43dd-bf3b-28ae40f0cd33" />
<img width="360" height="720" alt="Screenshot_20260303_222507" src="https://github.com/user-attachments/assets/52b622f9-b46c-42f4-a075-bb64fc129cf0" />
<img width="360" height="720" alt="Screenshot_20260303_222405" src="https://github.com/user-attachments/assets/2f15a3c3-36ac-436f-80ee-665275cece8d" />
<img width="360" height="720" alt="Screenshot_20260303_222627" src="https://github.com/user-attachments/assets/d2ea4fcd-f584-462a-8433-f03817941671" />
<img width="360" height="720" alt="Screenshot_20260303_222603" src="https://github.com/user-attachments/assets/190a9a90-d337-4edc-8958-a1d4646b78c3" />
<img width="360" height="720" alt="Screenshot_20260303_222545" src="https://github.com/user-attachments/assets/24c36f7d-8329-4d1f-996e-c89cf42d5af4" />
<img width="360" height="720" alt="Screenshot_20260303_222524" src="https://github.com/user-attachments/assets/39c0c883-d62a-41c0-906c-08ae6d54982b" />
<img width="360" height="720" alt="Screenshot_20260304_142302" src="https://github.com/user-attachments/assets/eb9d7ace-cf88-407a-94a4-5a9660b69569" />
<img width="360" height="720" alt="Screenshot_20260304_142315" src="https://github.com/user-attachments/assets/2cee2a69-b1ff-42c5-a3fd-8fe91aa85af8" />


> video
 


https://github.com/user-attachments/assets/b9b2ef19-ca9d-4d48-83e3-162db8bc0364



---

## ⚙️ Getting Started

### 1️⃣ Prerequisites
- Flutter (latest stable)
- Dart SDK

### 2️⃣ Install Dependencies
```bash
flutter pub get
```

### 3️⃣ Generate Hive TypeAdapters
```bash
flutter pub run build_runner build
```

### 4️⃣ Run Tests
```bash
flutter test
```

### 5️⃣ Launch the App
```bash
flutter run
```

---

## 🔮 Future Roadmap

- 📈 PDF & CSV data export
- 🔔 Smart reminder notifications
- ⌚ Google Fit integration
- 🍎 Apple Health sync
- 🌙 OLED-optimized true dark mode
- ☁ Cloud sync capability

---

## 💡 Why This Project Stands Out

- Demonstrates advanced Flutter architecture
- Production-ready folder structure
- Strong separation of business logic
- Optimized local database performance
- Portfolio-quality UI system
- Scalable foundation for real-world health apps

---

## 🤝 Contributing

Contributions, suggestions, and feature requests are welcome.

1. Fork the repository
2. Create a new branch
3. Commit your changes
4. Submit a Pull Request

---

## 📄 License

This project is open-source and available under the MIT License.

---

## 👨‍💻 Author

Developed with precision and passion by  
**Ashraf**

---

<p align="center">
  Elevating daily health tracking through engineering excellence.
</p>
