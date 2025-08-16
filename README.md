# gojo
An AI powered language learning app · flutter · django.

### 📸 Screenshots

| Login Screen | Sign In Screen | Sign Up Screen | 
| ----------- | ----------- | --------------- |
| ![Login Screen](https://github.com/bugrahankaramollaoglu/gojo/blob/main/readme_files/login_screen.png) | ![Sign In Screen](https://github.com/bugrahankaramollaoglu/gojo/blob/main/readme_files/signin_screen.png) | ![Sign Up Screen](https://github.com/bugrahankaramollaoglu/gojo/blob/main/readme_files/signup_screen.png) |

| Home Screen | Personas Screen | Chat Screen | 
| ----------- | ---------------- | ----------- |
| ![Home Screen](https://github.com/bugrahankaramollaoglu/gojo/blob/main/readme_files/home_screen.png) | ![Personas Screen](https://github.com/bugrahankaramollaoglu/gojo/blob/main/readme_files/personas_screen.png) | ![Chat Screen](https://github.com/bugrahankaramollaoglu/gojo/blob/main/readme_files/chat_screen.png) |


## 🛠 Technologies Used so far & Planned

### 🧱 Frontend (Mobile)

| Layer                | Technology                     | Purpose / Notes                                     |
|---------------------|---------------------------------|-----------------------------------------------------|
| Frontend (Mobile)   | Flutter 3+                      | Cross-platform, modern UI framework                 |
| Architecture        | Clean Architecture 	        | Scalable, testable, layered separation              |
| State Management    | Riverpod                        | Robust, testable, declarative                       |
| Navigation          | go_router                       | Declarative routing, URL-based navigation           |
| Networking          | Dio                             | HTTP client with interceptors, ideal for Clean Arch |
| Local Storage       | Hive                            | Lightweight NoSQL DB, good for offline storage      |
| Localization        | intl package                    | Multi-language support                              |

---

### 🧠 AI Integration

| Component           | Technology                      | Purpose / Notes                                     |
|---------------------|----------------------------------|-----------------------------------------------------|
| AI Service          | Gemini API (Google)             | Grammar correction, explanations, chatbot, etc.     |
| Abstraction Layer   | GeminiService / UseCase (Flutter)| Wrap AI calls inside use cases for testability      |

---

### 🌐 Backend (Custom API)

| Component           | Technology                      | Purpose / Notes                                     |
|---------------------|----------------------------------|-----------------------------------------------------|
| Framework           | Django + Django REST Framework  | Custom backend API, great for AI and admin tasks    |
| Auth                | Token-based (JWT or session)    | Secure login and premium features                   |
| AI Integration      | Gemini API via Python           | Direct API calls from backend for centralized control |
| Database            | PostgreSQL                      | Relational DB, scalable and production-ready        |

---

### 🛠 Optional Enhancements (Planned)

| Feature             | Tool/Tech                       | Purpose                                              |
|---------------------|----------------------------------|------------------------------------------------------|
| Error Monitoring    | Sentry                          | Crash and error tracking in production              |
| Secure Storage      | flutter_secure_storage          | Store auth tokens securely on device                 |
| Analytics           | Firebase Analytics              | Track user behavior, improve UX                      |
| Testing             | mocktail, flutter_test, pytest  | Unit and integration testing on both ends            |
| Subscription System | in_app_purchase + Django        | Premium feature unlock and backend verification      |
| Admin Panel         | Django Admin                    | Manage users, content, grammar logs, etc.            |

### Clean Architecture 

lib/
├── core/                      # Global utilities, themes, errors
│   ├── exceptions/
│   ├── network/
│   ├── utils/
│   └── theme/
│
├── features/                  # Each feature is self-contained
│   └── language_learning/
│       ├── data/
│       │   ├── datasources/   # Remote & local data sources
│       │   ├── models/        # DTOs for API or local DB
│       │   └── repositories/  # Data layer repository impl
│       │
│       ├── domain/
│       │   ├── entities/      # Core business models
│       │   ├── repositories/  # Abstract repository interfaces
│       │   └── usecases/      # Application-specific logic
│       │
│       ├── application/       # Riverpod Providers & state
│       │   ├── providers/     
│       │   └── notifiers/     # StateNotifiers, AsyncNotifiers
│       │
│       └── presentation/      
│           ├── pages/         # UI screens
│           ├── widgets/       # Reusable widgets
│           └── routes/        # go_router routes
│
├── app.dart                   # App root widget + go_router config
├── main.dart                  # Entry point
└── injection.dart             # Dependency injection setup

