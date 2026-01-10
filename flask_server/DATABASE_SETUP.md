# Supabase Database Setup Guide

## Quick Setup Steps

### 1. Apply Database Schema

Open your Supabase project SQL Editor:
1. Go to https://app.supabase.com
2. Select your project
3. Navigate to **SQL Editor** (left sidebar)
4. Click **New Query**
5. Copy the entire contents of `schema.sql`
6. Paste into the SQL editor
7. Click **Run** (or press Ctrl+Enter)

You should see: `Success. No rows returned`

### 2. Verify Tables Created

Go to **Table Editor** in Supabase dashboard and confirm these tables exist:
- ✅ `users`
- ✅ `addictions`
- ✅ `surveys`
- ✅ `milestones`

### 3. Check Row Level Security (RLS)

In **Authentication → Policies**, verify RLS policies are active for all tables.

### 4. Test Connection

Run the Flask server to test database connection:

```bash
cd flask_server
source venv/bin/activate  # or venv\Scripts\activate on Windows
python app.py
```

Expected output:
```
Starting server on port 5000 in development mode...
 * Running on http://0.0.0.0:5000
```

Visit http://localhost:5000/health - should return:
```json
{
  "success": true,
  "message": "Server is running",
  "environment": "development"
}
```

## Database Schema Overview

### Users Table
- Stores user accounts with UUID primary keys
- Password hashing with bcrypt
- Tracks scores and login timestamps

### Addictions Table
- Links to users via `user_id` (UUID foreign key)
- Tracks sobriety counter, streak, slips
- Stores savings data (time/money per day)

### Surveys Table
- Daily check-ins for each addiction
- Records mood, urge level, slip data
- Unique constraint on (addiction_id, date)

### Milestones Table
- Achievement tracking per addiction
- Reward points for gamification
- Timestamps for creation and achievement

## RLS Policies

All tables have Row Level Security enabled:
- Users can only access their own data
- Addictions/surveys/milestones verified via addiction.user_id
- Service role key bypasses RLS for backend operations

## Helper Functions

- `update_updated_at_column()` - Auto-updates timestamps
- Triggers on users/addictions tables

## Views

- `addiction_stats` - Aggregated statistics for addictions
  - Days sober, total check-ins, time/money saved

## Troubleshooting

### Connection Errors
- Verify SUPABASE_URL and SUPABASE_KEY in `.env`
- Ensure using **service_role** key, not anon key
- Check Supabase project is not paused

### Schema Errors
- Drop tables and re-run if needed: `DROP TABLE IF EXISTS milestones, surveys, addictions, users CASCADE;`
- Check for typos in SQL editor

### RLS Policy Issues
- Backend uses service_role key which bypasses RLS
- Mobile app will need anon key + user JWT tokens

## Next Steps

After database is set up:
1. ✅ Test user registration via `/api/auth/register`
2. ✅ Test addiction CRUD operations
3. ✅ Verify survey submission
4. ✅ Test milestone creation and claiming
