🩺 Health Insight Tracker
A Premium, Professional-Grade Health Monitoring Solution

This application is a high-fidelity Flutter solution built to track daily health vitals. It showcases a refined balance between aesthetic excellence and technical rigor, featuring a custom glassmorphic design system and a strictly decoupled Clean Architecture.

🚀 Key Features
Daily Vital Logging: A streamlined interface for recording mood, sleep duration, and water intake in seconds.

Intelligent Validation: Proprietary guardrails ensuring data integrity, including 24h sleep caps and a "one-entry-per-day" restriction.

Deep Analytics: Interactive 7-day trend reports that calculate averages and mood frequency.

Trend Intelligence: Visual indicators that compare current performance against the previous week to provide actionable feedback.

Premium UX: Featuring a custom glassmorphism design system, parallax onboarding effects, and staggered list animations.

Offline-First Reliability: Robust local persistence ensures data is available anywhere, anytime.

🛠 Tech Stack & Architecture
State Management: Provider
I implemented Provider to manage the application state. It was selected for its efficiency in handling dependency injection and its ability to maintain a highly performant, reactive UI while keeping the business logic strictly separated from the presentation layer.

Architecture: Clean Architecture (Feature-First)
The codebase follows a modular, feature-first Clean Architecture to ensure scalability and ease of testing.

Data Layer: Encapsulates Hive database initialization, TypeAdapters, and local storage repositories.

Domain/Logic Layer: Centralized via HealthProvider, acting as the "Single Source of Truth" for the app’s state.

Presentation Layer: Utilizes a library of reusable widgets and custom painters (e.g., GridPainter) to maintain a DRY (Don't Repeat Yourself) codebase.

Local Persistence: Hive NoSQL
Hive was chosen over traditional SQL solutions for its superior speed and lightweight footprint. As a NoSQL store, it provides near-instant read/write capabilities, which is critical for a fluid mobile experience.

🏗 Key Decisions & Assumptions
Data Sovereignty: Given the sensitivity of health data, I assumed a "Privacy-First" stance. All data is stored 100% on-device with zero cloud exposure.

Boutique Design: I moved away from standard Material Design to a custom, purple-branded "Glassmorphic" theme to differentiate the product in a crowded market.

Comparative Analytics: Trends are calculated by comparing the current 7-day window against the previous 7-day window to offer a true sense of progress.

🔮 Future Roadmap
📈 Data Portability: Implementation of PDF/CSV export functionality for clinical sharing.

🔔 Smart Reminders: Local notification system to encourage consistent logging.

⌚ Ecosystem Integration: Syncing with Google Fit and Apple Health for automated vital tracking.

🌙 True Dark Mode: An optimized OLED-friendly theme for nighttime use.

⚙️ Getting Started
Environment: Ensure Flutter (latest stable) is installed.

Dependencies: Run flutter pub get.

Code Generation: Run flutter pub run build_runner build to generate Hive TypeAdapters.

Deployment: Launch on a physical device or emulator.
