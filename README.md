# Addiction Quit App

A Flutter mobile app that helps users track sobriety, build streaks, and stay motivated with local storage and optional cloud sync.

![Flutter](https://img.shields.io/badge/Flutter-3.8.1+-02569B?logo=flutter)
![Python](https://img.shields.io/badge/Python-3.10+-3776AB?logo=python)
![License](https://img.shields.io/badge/License-MIT-green)

---

## Demo

- Video: https://www.youtube.com/shorts/LVtnUAinF6s

## Features

- **🕐 Sobriety Counter**: Real-time tracking of clean time (days, hours, minutes)
- **📊 Multi-Addiction Support**: Track multiple addictions simultaneously
- **✅ Daily Check-ins**: Record mood, urge levels, and slip incidents
- **💰 Savings Calculator**: Visualize time and money saved
- **🏆 Milestone System**: Earn rewards for achieving sobriety goals
- **📈 Progress Dashboard**: Comprehensive statistics and visualizations
- **📱 Offline-First**: Full functionality without internet connection
- **🔐 Secure Authentication**: JWT-based login with encrypted token storage
- **🌍 Multi-Language**: English and Arabic support
- **🎨 Material Design 3**: Modern user interface
- **🔄 Cloud Sync**: Optional backup through the Flask backend and Supabase
- **💾 Local Storage**: SQLite for fast offline access

---

## 🏗️ Architecture

### Three-Tier Design

```
Flutter App (Client)
    ↓
Flask REST API (Server)
    ↓
Supabase PostgreSQL (Database)
```

**Local-first approach:**
- Data stored locally in SQLite
- Background sync with cloud
- Works completely offline
- Automatic conflict resolution

---

## Getting Started

### Prerequisites

- **Flutter SDK**: 3.8.1 or higher
- **Dart**: 3.0 or higher
- **Python**: 3.10+ if you want to run the backend

### Run the app

```bash
flutter pub get
flutter run
```

### Optional backend

```bash
cd flask_server
pip install -r requirements.txt
cp .env.example .env
python app.py
```

Copy the example config files before running the backend or Firebase-enabled builds:
- `flask_server/.env.example` to `flask_server/.env`
- `android/app/google-services.json.example` to `android/app/google-services.json` if needed

---

## Tech Stack

### Client

| Package | Version | Purpose |
|---------|---------|---------|
| flutter_bloc | 9.1.1 | State management |
| sqflite | 2.4.2 | Local database |
| dio | 5.4.0 | HTTP client |
| flutter_secure_storage | 9.2.2 | Encrypted storage |
| shared_preferences | 2.5.3 | App settings |
| intl | 0.20.2 | Internationalization |

### Server

| Package | Version | Purpose |
|---------|---------|---------|
| Flask | 3.0.0 | Web framework |
| flask-cors | 4.0.0 | CORS handling |
| pyjwt | 2.8.0 | JWT tokens |
| bcrypt | 4.1.2 | Password hashing |
| supabase | 2.3.4 | Database client |
| pydantic | 2.5.3 | Data validation |

### Data

- **Supabase**: PostgreSQL with Row Level Security
- **SQLite**: Local offline storage

---

## Notes

- The backend is optional for local use.
- The app is designed to work offline first.

## 🧪 Testing

```bash
# Run Flutter tests
flutter test

# Run with coverage
flutter test --coverage

# Analyze code
flutter analyze

# Backend tests
cd flask_server
pytest
```

---

## 🔐 Security

- **JWT Authentication**: Secure token-based auth
- **Encrypted Storage**: Tokens stored with flutter_secure_storage
- **Password Hashing**: bcrypt with salt
- **Row Level Security**: Database-level access control
- **HTTPS Only**: Enforce TLS in production

---

## 🌐 Localization

Currently supports:
- 🇬🇧 English (en)
- 🇸🇦 Arabic (ar)

Add more languages in `lib/l10n/` directory.

---

## 📄 License

This project is licensed under the MIT License - see [LICENSE](LICENSE) file.

---
