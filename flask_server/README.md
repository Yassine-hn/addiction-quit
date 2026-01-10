# Flask Backend Server

Backend API for the Addiction Quit mobile application.

## Setup

1. Create virtual environment:
```bash
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

2. Install dependencies:
```bash
pip install -r requirements.txt
```

3. Configure environment variables:
```bash
cp .env.example .env
# Edit .env with your configuration
```

4. Run the server:
```bash
# Development mode
python app.py

# Or with Flask CLI
flask run
```

## Environment Variables

Required variables (see `.env.example`):
- `FLASK_ENV`: development/production/testing
- `SECRET_KEY`: Flask secret key for sessions
- `JWT_SECRET_KEY`: JWT token signing key
- `SUPABASE_URL`: Supabase project URL
- `SUPABASE_KEY`: Supabase service role key
- `PORT`: Server port (default: 5000)

## API Endpoints

### Authentication
- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - Login user
- `POST /api/auth/logout` - Logout user

### Addictions
- `GET /api/addictions` - Get user's addictions
- `GET /api/addictions/<id>` - Get specific addiction
- `POST /api/addictions` - Create addiction
- `PUT /api/addictions/<id>` - Update addiction
- `DELETE /api/addictions/<id>` - Delete addiction
- `POST /api/addictions/<id>/reset` - Reset counter

### Surveys (Check-ins)
- `GET /api/surveys?addiction_id=<id>&date=<date>` - Get surveys
- `POST /api/surveys` - Submit check-in

### Milestones
- `GET /api/milestones?addiction_id=<id>` - Get milestones
- `POST /api/milestones` - Create milestone
- `PUT /api/milestones/<id>/claim` - Claim reward
- `POST /api/milestones/<id>/reset` - Reset on slip

## Project Structure

```
flask_server/
├── app.py                      # Application factory & entry point
├── config.py                   # Configuration classes
├── requirements.txt            # Python dependencies
├── .env.example                # Environment template
├── models/
│   └── schemas.py              # Pydantic validation schemas
├── routes/
│   ├── auth_routes.py          # Authentication endpoints
│   ├── addiction_routes.py     # Addiction CRUD
│   ├── survey_routes.py        # Check-in endpoints
│   └── milestone_routes.py     # Milestone endpoints
└── services/
    ├── database_service.py     # Supabase client wrapper
    └── auth_service.py         # JWT & password utilities
```

## Response Format

All endpoints return JSON with consistent structure:

```json
{
  "success": true,
  "message": "Operation successful",
  "data": { ... }
}
```

Error responses:
```json
{
  "success": false,
  "message": "Error description",
  "errors": [ ... ]  // Optional validation errors
}
```

## Authentication

Protected endpoints require JWT token in Authorization header:
```
Authorization: Bearer <access_token>
```

Tokens are obtained from `/api/auth/register` or `/api/auth/login`.
