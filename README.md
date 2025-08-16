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
|---------------------|----------------------------------|----------------------------------------------------|
| AI Service          | Gemini API (Google)             | Grammar correction, explanations, chatbot, etc.     |
| Abstraction Layer   | GeminiService / UseCase (Flutter)| Wrap AI calls inside use cases for testability     |

---

### 🌐 Backend (Custom API)

| Component           | Technology                      | Purpose / Notes                                     |
|---------------------|----------------------------------|----------------------------------------------------|
| Framework           | Django + Django REST Framework  | Custom backend API, great for AI and admin tasks    |
| Auth                | Token-based (JWT or session)    | Secure login and premium features                   |
| AI Integration      | Gemini API via Python           | API calls from backend for centralized control      |
| Database            | PostgreSQL                      | Relational DB, scalable and production-ready        |

---

### 🛠 Optional Enhancements (Planned)

| Feature             | Tool/Tech                       | Purpose                                              |
|---------------------|----------------------------------|-----------------------------------------------------|
| Error Monitoring    | Sentry                          | Crash and error tracking in production               |
| Secure Storage      | flutter_secure_storage          | Store auth tokens securely on device                 |
| Analytics           | Firebase Analytics              | Track user behavior, improve UX                      |
| Testing             | mocktail, flutter_test, pytest  | Unit and integration testing on both ends            |
| Subscription System | in_app_purchase + Django        | Premium feature unlock and backend verification      |
| Admin Panel         | Django Admin                    | Manage users, content, grammar logs, etc.            |

### Clean Architecture 

| Section | Description | Details |
|---------|-------------|---------|
| **Overview** | Clean Architecture Principles | The project follows **Clean Architecture** with three main layers: **Presentation** (UI and user interactions), **Domain** (business logic, entities, repository interfaces), and **Data** (data sources, repository implementations). This ensures modularity, testability, and maintainability. |
| **Project Structure** | `lib/` | Main directory containing all app code. |
| | `core/` | Global utilities, themes, and configurations.<br>- `exceptions/`: Custom error handling.<br>- `network/`: Network-related utilities.<br>- `utils/`: Reusable utilities.<br>- `theme/`: App-wide themes and styles. |
| | `features/` | Self-contained feature modules (e.g., `language_learning/`). |
| | `features/language_learning/data/` | Data layer.<br>- `datasources/`: Remote and local data sources.<br>- `models/`: DTOs for API or local DB.<br>- `repositories/`: Repository implementations. |
| | `features/language_learning/domain/` | Domain layer.<br>- `entities/`: Core business models.<br>- `repositories/`: Abstract repository interfaces.<br>- `usecases/`: Application-specific business logic. |
| | `features/language_learning/application/` | Application layer.<br>- `providers/`: Riverpod providers.<br>- `notifiers/`: StateNotifiers and AsyncNotifiers for state management. |
| | `features/language_learning/presentation/` | Presentation layer.<br>- `pages/`: UI screens.<br>- `widgets/`: Reusable UI components.<br>- `routes/`: go_router routes for navigation. |
| | `app.dart` | App root widget and go_router configuration. |
| | `main.dart` | Application entry point. |
| | `injection.dart` | Dependency injection setup. |
| **Tools & Technologies** | Error Monitoring | **Sentry**: Crash and error tracking in production. |
| | Secure Storage | **flutter_secure_storage**: Store auth tokens securely on device. |
| | Analytics | **Firebase Analytics**: Track user behavior to improve UX. |
| | Testing | **mocktail, flutter_test, pytest**: Unit and integration testing for both frontend and backend. |
| | Subscription System | **in_app_purchase + Django**: Premium feature unlock with backend verification. |
| | Admin Panel | **Django Admin**: Manage users, content, grammar logs, etc. |
