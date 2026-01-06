# Development Documentation

Complete technical documentation for the Addiction Quit mobile application.

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Technology Stack](#technology-stack)
3. [Project Structure](#project-structure)
4. [Database Schemas](#database-schemas)
5. [API Documentation](#api-documentation)
6. [State Management](#state-management)
7. [Local-First Architecture](#local-first-architecture)
8. [Development Setup](#development-setup)
9. [Testing](#testing)
10. [Deployment](#deployment)

---

## Architecture Overview

### Three-Tier Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     CLIENT LAYER (Flutter)                   │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │ Presentation │  │  Logic/BLoC  │  │  Data Layer  │      │
│  │   (Screens)  │→│   (Cubits)   │→│ (Repositories)│      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
│         ↓                                     ↓              │
│  ┌──────────────────────────────────────────────────┐      │
│  │         Local Storage (SQLite + SharedPrefs)      │      │
│  └──────────────────────────────────────────────────┘      │
└─────────────────────────────────────────────────────────────┘
                            ↓ HTTP/REST
┌─────────────────────────────────────────────────────────────┐
│                   SERVER LAYER (Flask)                       │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │    Routes    │→│   Services   │→│   Database   │      │
│  │  (REST API)  │  │  (Business)  │  │   Service    │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└─────────────────────────────────────────────────────────────┘
                            ↓ PostgreSQL Client
┌─────────────────────────────────────────────────────────────┐
│                DATABASE LAYER (Supabase)                     │
│  ┌──────────────────────────────────────────────────┐      │
│  │         PostgreSQL + Row Level Security           │      │
│  └──────────────────────────────────────────────────┘      │
└─────────────────────────────────────────────────────────────┘
```

### Design Principles

1. **Local-First**: App works offline, syncs when online
2. **Repository Pattern**: Abstract data sources behind interfaces
3. **BLoC/Cubit**: Predictable state management with streams
4. **RESTful API**: Standard HTTP methods and status codes
5. **Secure by Default**: JWT tokens, RLS policies, encrypted storage

---

## Technology Stack

### Client (Flutter)
- **Framework**: Flutter 3.8.1+ (Dart)
- **State Management**: flutter_bloc 9.1.1
- **Local Database**: sqflite 2.4.2
- **Local Storage**: shared_preferences 2.5.3, flutter_secure_storage 9.2.2
- **HTTP Client**: dio 5.4.0
- **Localization**: flutter_localizations (en, ar)

### Server (Flask)
- **Framework**: Flask 3.0.0
- **CORS**: flask-cors 4.0.0
- **Authentication**: PyJWT 2.8.0, bcrypt 4.1.2
- **Validation**: pydantic 2.5.3
- **Database Client**: supabase 2.3.4

### Database (Supabase)
- **RDBMS**: PostgreSQL 15+
- **Authentication**: Supabase Auth with RLS
- **Storage**: Supabase Storage (for future assets)

---

## Project Structure

```
addiction-quit/
├── lib/                          # Flutter application
│   ├── main.dart                 # App entry point
│   ├── api/
│   │   └── api_service.dart      # REST API client
│   ├── data/
│   │   ├── databases/
│   │   │   ├── db_helper.dart    # SQLite setup
│   │   │   └── tables/           # CRUD operations per table
│   │   ├── repositories/         # Data access abstractions
│   │   │   ├── addiction_repository.dart
│   │   │   ├── check_in_repository.dart
│   │   │   ├── milestone_repository.dart
│   │   │   ├── savings_repository.dart
│   │   │   └── sobriety_repository.dart
│   │   └── storage/
│   │       └── token_storage.dart # Secure JWT storage
│   ├── logic/
│   │   └── cubits/               # State management
│   │       ├── auth_cubit.dart   # Authentication
│   │       ├── dashboard_cubit.dart
│   │       ├── daily_checkin_cubit.dart
│   │       └── language_cubit.dart
│   ├── presentation/
│   │   ├── screens/              # UI screens
│   │   │   ├── login_screen.dart
│   │   │   ├── signup_screen.dart
│   │   │   ├── home_screen.dart
│   │   │   └── dashboard_screen.dart
│   │   └── widgets/              # Reusable components
│   ├── l10n/                     # Localization files
│   └── modules/                  # Feature modules
│
├── flask_server/                 # Backend API
│   ├── app.py                    # Flask app factory
│   ├── config.py                 # Environment configs
│   ├── schema.sql                # Supabase schema
│   ├── models/
│   │   └── schemas.py            # Pydantic models
│   ├── routes/
│   │   ├── auth_routes.py
│   │   ├── addiction_routes.py
│   │   ├── survey_routes.py
│   │   └── milestone_routes.py
│   └── services/
│       ├── auth_service.py       # JWT + bcrypt
│       └── database_service.py   # Supabase client
│
├── test/                         # Unit & widget tests
├── assets/                       # Images, fonts
├── pubspec.yaml                  # Flutter dependencies
└── README.md                     # User documentation
```

---

## Database Schemas

### Local Database (SQLite)

Used for offline-first functionality. Auto-syncs with cloud when online.

#### Users Table
```sql
CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  email TEXT UNIQUE,
  dob TEXT,
  score INTEGER DEFAULT 0,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP
);
```

#### Addictions Table
```sql
CREATE TABLE addictions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  addiction_type TEXT NOT NULL,
  counter_start_at TEXT NOT NULL,
  target_date TEXT,
  goal_type TEXT NOT NULL,
  daily_target INTEGER,
  weekly_target INTEGER,
  time_saved_per_day INTEGER DEFAULT 0,
  money_saved_per_day REAL DEFAULT 0.0,
  streak INTEGER DEFAULT 0,
  slips INTEGER DEFAULT 0,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id)
);
```

#### Surveys Table (Check-ins)
```sql
CREATE TABLE surveys (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  addiction_id INTEGER NOT NULL,
  date TEXT NOT NULL,
  slipped INTEGER NOT NULL DEFAULT 0,
  slip_amount INTEGER,
  mood TEXT NOT NULL,
  urge_level INTEGER NOT NULL,
  coping_strategy TEXT,
  stress_level INTEGER,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (addiction_id) REFERENCES addictions(id),
  UNIQUE(addiction_id, date)
);
```

#### Milestones Table
```sql
CREATE TABLE milestones (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  addiction_id INTEGER NOT NULL,
  title TEXT NOT NULL,
  target_value INTEGER NOT NULL,
  reward_points INTEGER DEFAULT 0,
  is_achieved INTEGER DEFAULT 0,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  achieved_at TEXT,
  FOREIGN KEY (addiction_id) REFERENCES addictions(id)
);
```

### Cloud Database (Supabase PostgreSQL)

Identical schema but with UUIDs for users and Row Level Security.

Key differences:
- `users.id` is UUID instead of INTEGER
- RLS policies enforce data isolation per user
- Timestamps use TIMESTAMPTZ (timezone-aware)
- Foreign keys cascade on delete
- Triggers auto-update `updated_at` columns

See [flask_server/schema.sql](flask_server/schema.sql) for complete Supabase schema.

---

## API Documentation

### Base URL
- Development: `http://localhost:5000`
- Android Emulator: `http://10.0.2.2:5000`
- Production: `https://your-domain.com`

### Response Format

All endpoints return JSON with consistent structure:

**Success:**
```json
{
  "success": true,
  "message": "Operation successful",
  "data": { ... }
}
```

**Error:**
```json
{
  "success": false,
  "message": "Error description",
  "errors": [ ... ]  // Optional validation errors
}
```

### Authentication

Protected endpoints require JWT in Authorization header:
```
Authorization: Bearer <access_token>
```

### Endpoints

#### Authentication

**POST /api/auth/register**
```json
Request:
{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "secure123",
  "dob": "1990-01-01"  // Optional
}

Response:
{
  "success": true,
  "data": {
    "user": {
      "id": "uuid",
      "name": "John Doe",
      "email": "john@example.com"
    },
    "access_token": "jwt_token",
    "refresh_token": "jwt_token"
  }
}
```

**POST /api/auth/login**
```json
Request:
{
  "email": "john@example.com",
  "password": "secure123"
}

Response: Same as register
```

**POST /api/auth/logout**
- No body required
- Returns success message

#### Addictions

**GET /api/addictions**
- Returns array of user's addictions
- Requires authentication

**POST /api/addictions**
```json
Request:
{
  "addiction_type": "Smoking",
  "counter_start_at": "2026-01-01T00:00:00Z",
  "target_date": "2026-12-31",
  "goal_type": "daily",
  "daily_target": 0,
  "time_saved_per_day": 30,
  "money_saved_per_day": 10.0
}
```

**PUT /api/addictions/{id}**
- Update addiction fields
- Only provided fields are updated

**DELETE /api/addictions/{id}**
- Soft or hard delete addiction

**POST /api/addictions/{id}/reset**
- Reset sobriety counter
- Increments slip count

#### Surveys (Check-ins)

**GET /api/surveys?addiction_id={id}&date={YYYY-MM-DD}**
- Get surveys filtered by addiction and optional date

**POST /api/surveys**
```json
Request:
{
  "addiction_id": 1,
  "date": "2026-01-06",
  "slipped": false,
  "mood": "happy",
  "urge_level": 3,
  "coping_strategy": "Exercise",
  "stress_level": 2
}
```

#### Milestones

**GET /api/milestones?addiction_id={id}**
- Get milestones for addiction

**POST /api/milestones**
```json
Request:
{
  "addiction_id": 1,
  "title": "7 Days Sober",
  "target_value": 7,
  "reward_points": 50
}
```

**PUT /api/milestones/{id}/claim**
- Claim milestone reward
- Updates user score

**POST /api/milestones/{id}/reset**
- Reset milestone progress on slip

---

## State Management

### BLoC/Cubit Architecture

Using `flutter_bloc` for predictable state management.

#### Auth Flow

```dart
AuthState:
  - AuthInitial: App starting
  - AuthLoading: Authentication in progress
  - AuthAuthenticated: User logged in
  - AuthUnauthenticated: No valid session
  - AuthError: Auth failed with message

AuthCubit Methods:
  - checkAuthStatus(): Check stored tokens
  - login(email, password): Authenticate user
  - register(name, email, password): Create account
  - logout(): Clear session
```

#### Dashboard Flow

```dart
DashboardState:
  - DashboardInitial
  - DashboardLoading
  - DashboardLoaded: Has addictions/milestones/stats
  - DashboardError

DashboardCubit Methods:
  - loadDashboard(userId): Fetch all dashboard data
  - claimMilestoneReward(milestoneId): Claim and update score
```

#### Check-in Flow

```dart
CheckInState:
  - CheckInInitial
  - CheckInInProgress: User filling form
  - CheckInSubmitting: Saving to backend
  - CheckInSuccess
  - CheckInError

DailyCheckInCubit Methods:
  - updateMood(mood)
  - updateUrgeLevel(level)
  - updateSlipped(bool)
  - submitCheckIn(): Validate and save
```

---

## Local-First Architecture

### Sync Strategy

1. **On App Start**: Load from SQLite immediately
2. **Background Sync**: Fetch updates from server
3. **Conflict Resolution**: Server timestamp wins
4. **Queue Changes**: Store unsaved changes locally
5. **Retry Logic**: Auto-retry failed syncs

### Offline Support

- All core features work offline
- Check-ins saved to SQLite first
- Queued for upload when online
- Visual indicator for pending syncs

### Data Flow

```
User Action
    ↓
Cubit/State Update
    ↓
Repository (Interface)
    ↓
┌───────────────┐
│ Write to SQLite │ → UI updates immediately
└───────────────┘
    ↓
┌───────────────┐
│ Queue API call  │ → Background sync
└───────────────┘
    ↓
Server Update
```

---

## Development Setup

### Prerequisites

- Flutter SDK 3.8.1+
- Dart 3.0+
- Python 3.10+
- Android Studio / Xcode
- Git

### Flutter App Setup

```bash
# Clone repository
git clone <repo-url>
cd addiction-quit

# Install dependencies
flutter pub get

# Run code generation (if needed)
flutter pub run build_runner build

# Run on device/emulator
flutter run

# Build APK
flutter build apk --release

# Build iOS
flutter build ios --release
```

### Flask Backend Setup

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

# Run development server
python app.py

# Or with Flask CLI
export FLASK_APP=app.py
flask run --port 5000
```

### Supabase Setup

1. Create project at https://app.supabase.com
2. Copy Project URL and service_role key
3. Add to `flask_server/.env`
4. Run schema:
   - Open SQL Editor in Supabase dashboard
   - Paste contents of `flask_server/schema.sql`
   - Execute

### Environment Variables

**Flutter (.env not used, hardcoded in api_service.dart):**
```dart
static const String baseUrl = 'http://10.0.2.2:5000'; // Change for production
```

**Flask (.env):**
```bash
FLASK_ENV=development
SECRET_KEY=your-secret-key
JWT_SECRET_KEY=your-jwt-secret
SUPABASE_URL=https://xxxxx.supabase.co
SUPABASE_KEY=service_role_key
PORT=5000
```

---

## Testing

### Flutter Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Widget tests
flutter test test/widget_test.dart

# Integration tests
flutter drive --target=test_driver/app.dart
```

### Backend Tests

```bash
cd flask_server

# Install test dependencies
pip install pytest pytest-cov

# Run tests
pytest

# With coverage
pytest --cov=. --cov-report=html
```

---

## Deployment

### Flutter App

**Android:**
```bash
flutter build apk --release
# APK at: build/app/outputs/flutter-apk/app-release.apk

flutter build appbundle
# AAB at: build/app/outputs/bundle/release/app-release.aab
```

**iOS:**
```bash
flutter build ios --release
# Open Xcode, archive and upload
```

### Flask Backend

**Docker Deployment:**
```dockerfile
FROM python:3.10-slim

WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .

CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:5000", "app:create_app()"]
```

**Environment Variables:**
- Set `FLASK_ENV=production`
- Use secure random keys
- Configure CORS_ORIGINS for your domain

### Supabase

- Already hosted and managed
- Enable RLS policies in production
- Set up backups and monitoring

---

## Security Considerations

1. **JWT Tokens**: 15-min access, 7-day refresh
2. **Password Hashing**: bcrypt with salt rounds
3. **Secure Storage**: flutter_secure_storage for tokens
4. **RLS Policies**: Database-level access control
5. **Input Validation**: Pydantic schemas on backend
6. **HTTPS Only**: Enforce TLS in production
7. **Rate Limiting**: Add to Flask routes (future)

---

## Troubleshooting

### Common Issues

**Flutter won't connect to backend:**
- Check baseUrl in api_service.dart
- Android emulator: use `10.0.2.2`
- iOS simulator: use `localhost`
- Physical device: use computer's IP

**Database sync fails:**
- Verify Supabase credentials in .env
- Check network connectivity
- Review Flask logs for errors

**Build errors:**
- Run `flutter clean && flutter pub get`
- Delete `build/` folder
- Check Flutter/Dart SDK versions

---

## Contributing

1. Fork repository
2. Create feature branch
3. Write tests for new features
4. Ensure `flutter analyze` passes
5. Submit pull request

---

## License

[Your License Here]

---

## Support

For issues and questions:
- GitHub Issues: [repo-url]/issues
- Email: support@example.com
