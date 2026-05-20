# Addiction Quit App

A comprehensive mobile application to help users overcome addictions through tracking, motivation, and community support. Built with Flutter and powered by a Flask backend with Supabase cloud database.

![Flutter](https://img.shields.io/badge/Flutter-3.8.1+-02569B?logo=flutter)
![Python](https://img.shields.io/badge/Python-3.10+-3776AB?logo=python)
![License](https://img.shields.io/badge/License-MIT-green)

---

## 🎯 Features

### Core Functionality

- **🕐 Sobriety Counter**: Real-time tracking of clean time (days, hours, minutes)
- **📊 Multi-Addiction Support**: Track multiple addictions simultaneously
- **✅ Daily Check-ins**: Record mood, urge levels, and slip incidents
- **💰 Savings Calculator**: Visualize time and money saved
- **🏆 Milestone System**: Earn rewards for achieving sobriety goals
- **📈 Progress Dashboard**: Comprehensive statistics and visualizations
- **📱 Offline-First**: Full functionality without internet connection

### User Experience

- **🔐 Secure Authentication**: JWT-based login with encrypted token storage
- **🌍 Multi-Language**: English and Arabic support (easily extensible)
- **🎨 Material Design 3**: Modern, intuitive user interface
- **🔄 Cloud Sync**: Automatic backup to cloud when online
- **💾 Local Storage**: SQLite for fast offline access

### Advanced Features

- **Slip Tracking**: Record amounts and automatically reset counters
- **Streak Monitoring**: Track consecutive days without incidents
- **Gamification**: Points system with milestone rewards
- **Detailed Insights**: Mood patterns, urge trends, coping strategies

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

**Local-First Approach:**
- Data stored locally in SQLite
- Background sync with cloud
- Works completely offline
- Automatic conflict resolution

---

## 📱 Screenshots

[Add screenshots here]

---

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK**: 3.8.1 or higher
- **Dart**: 3.0 or higher
- **Android Studio** / **Xcode** (for mobile development)
- **Python**: 3.10+ (for backend)
- **Supabase Account** (free tier available)

### Installation

#### 1. Clone Repository

```bash
git clone https://github.com/yourusername/addiction-quit.git
cd addiction-quit
```

#### 2. Flutter App Setup

```bash
# Install dependencies
flutter pub get

# Run on emulator/device
flutter run

# Build for release
flutter build apk --release  # Android
flutter build ios --release  # iOS
```

#### 3. Backend Setup (Optional - for cloud sync)

```bash
cd flask_server

# Create virtual environment
python3 -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Configure environment
cp .env.example .env
# Edit .env with your Supabase credentials

# Run server
python app.py
```

#### 4. Supabase Setup

1. Create account at [supabase.com](https://supabase.com)
2. Create new project
3. Copy Project URL and service_role key
4. Add to `flask_server/.env`
5. Run SQL schema:
   - Open SQL Editor in Supabase dashboard
   - Copy content from `flask_server/schema.sql`
   - Execute in SQL Editor

---

## 📖 Usage

### First Launch

1. **Sign Up**: Create account with email and password
2. **Add Addiction**: Track smoking, alcohol, gaming, etc.
3. **Set Goals**: Define daily/weekly targets
4. **Start Tracking**: Begin your recovery journey

### Daily Routine

1. **Check Counter**: View your progress
2. **Daily Check-in**: Record mood and urge levels
3. **Review Stats**: See savings and streaks
4. **Claim Milestones**: Earn rewards for achievements

### In Case of Slip

1. Click "Reset Counter" on home screen
2. Enter amount (e.g., cigarettes smoked)
3. Answer check-in questions
4. Counter resets, milestones restart
5. Continue your journey

---

## 🛠️ Technology Stack

### Client (Flutter)

| Package | Version | Purpose |
|---------|---------|---------|
| flutter_bloc | 9.1.1 | State management |
| sqflite | 2.4.2 | Local database |
| dio | 5.4.0 | HTTP client |
| flutter_secure_storage | 9.2.2 | Encrypted storage |
| shared_preferences | 2.5.3 | App settings |
| intl | 0.20.2 | Internationalization |

### Server (Flask)

| Package | Version | Purpose |
|---------|---------|---------|
| Flask | 3.0.0 | Web framework |
| flask-cors | 4.0.0 | CORS handling |
| pyjwt | 2.8.0 | JWT tokens |
| bcrypt | 4.1.2 | Password hashing |
| supabase | 2.3.4 | Database client |
| pydantic | 2.5.3 | Data validation |

### Database

- **Supabase**: PostgreSQL with Row Level Security
- **SQLite**: Local offline storage

---

## 📂 Project Structure

```
addiction-quit/
├── lib/
│   ├── api/              # REST API client
│   ├── data/             # Data layer (repos, DB, storage)
│   ├── logic/            # Business logic (cubits)
│   ├── presentation/     # UI (screens, widgets)
│   ├── l10n/             # Localization files
│   └── main.dart         # App entry point
│
├── flask_server/
│   ├── routes/           # API endpoints
│   ├── services/         # Business logic
│   ├── models/           # Data models
│   ├── app.py            # Flask app
│   └── schema.sql        # Database schema
│
├── assets/               # Images, fonts
├── test/                 # Unit & widget tests
└── pubspec.yaml          # Flutter dependencies
```

---

## 🔧 Configuration

### API Endpoint

Edit `lib/api/api_service.dart`:

```dart
static const String baseUrl = 'http://your-server-url:5000';
```

**Default values:**
- Android Emulator: `http://10.0.2.2:5000`
- iOS Simulator: `http://localhost:5000`
- Physical Device: `http://YOUR_COMPUTER_IP:5000`

### Backend Environment

Edit `flask_server/.env`:

```bash
SUPABASE_URL=https://xxxxx.supabase.co
SUPABASE_KEY=your_service_role_key
SECRET_KEY=random_secret_key
JWT_SECRET_KEY=random_jwt_key
```

---

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

## 📦 Building for Production

### Android

```bash
# APK (direct install)
flutter build apk --release

# App Bundle (Google Play)
flutter build appbundle --release
```

Output: `build/app/outputs/`

### iOS

```bash
flutter build ios --release
```

Then use Xcode to archive and submit to App Store.

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

## 🤝 Contributing

Contributions are welcome!

1. Fork the repository
2. Create feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open Pull Request

---

## 📄 License

This project is licensed under the MIT License - see [LICENSE](LICENSE) file.

---
