-- Addiction Quit Database Schema for Supabase
-- Run this script in your Supabase SQL Editor to create all tables

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =====================================================
-- USERS TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    dob DATE,
    score INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    last_login_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ
);

-- Index for email lookups
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);

-- =====================================================
-- ADDICTIONS TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS addictions (
    id SERIAL PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    addiction_type TEXT NOT NULL,
    counter_start_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    target_date DATE,
    goal_type TEXT NOT NULL,
    daily_target INTEGER,
    weekly_target INTEGER,
    time_saved_per_day INTEGER NOT NULL DEFAULT 0, -- in minutes
    money_saved_per_day NUMERIC(10, 2) NOT NULL DEFAULT 0.00,
    streak INTEGER DEFAULT 0,
    slips INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ,
    
    CONSTRAINT valid_goal_type CHECK (goal_type IN ('daily', 'weekly', 'total')),
    CONSTRAINT positive_targets CHECK (
        (daily_target IS NULL OR daily_target >= 0) AND
        (weekly_target IS NULL OR weekly_target >= 0)
    )
);

-- Indexes for queries
CREATE INDEX IF NOT EXISTS idx_addictions_user_id ON addictions(user_id);
CREATE INDEX IF NOT EXISTS idx_addictions_created_at ON addictions(created_at);

-- =====================================================
-- SURVEYS TABLE (Daily Check-ins)
-- =====================================================
CREATE TABLE IF NOT EXISTS surveys (
    id SERIAL PRIMARY KEY,
    addiction_id INTEGER NOT NULL REFERENCES addictions(id) ON DELETE CASCADE,
    date DATE NOT NULL,
    slipped BOOLEAN NOT NULL DEFAULT false,
    slip_amount INTEGER,
    mood TEXT NOT NULL,
    urge_level INTEGER NOT NULL,
    coping_strategy TEXT,
    stress_level INTEGER,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    
    CONSTRAINT valid_mood CHECK (mood IN ('happy', 'sad', 'anxious', 'calm', 'stressed', 'motivated')),
    CONSTRAINT valid_urge_level CHECK (urge_level >= 0 AND urge_level <= 10),
    CONSTRAINT valid_stress_level CHECK (stress_level IS NULL OR (stress_level >= 0 AND stress_level <= 10)),
    CONSTRAINT valid_slip_amount CHECK (
        (slipped = false AND slip_amount IS NULL) OR
        (slipped = true AND slip_amount IS NOT NULL AND slip_amount > 0)
    ),
    CONSTRAINT unique_addiction_date UNIQUE(addiction_id, date)
);

-- Indexes for queries
CREATE INDEX IF NOT EXISTS idx_surveys_addiction_id ON surveys(addiction_id);
CREATE INDEX IF NOT EXISTS idx_surveys_date ON surveys(date);
CREATE INDEX IF NOT EXISTS idx_surveys_addiction_date ON surveys(addiction_id, date);

-- =====================================================
-- MILESTONES TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS milestones (
    id SERIAL PRIMARY KEY,
    addiction_id INTEGER NOT NULL REFERENCES addictions(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    target_value INTEGER NOT NULL,
    reward_points INTEGER NOT NULL DEFAULT 0,
    is_achieved BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    achieved_at TIMESTAMPTZ,
    
    CONSTRAINT positive_target CHECK (target_value > 0),
    CONSTRAINT positive_reward CHECK (reward_points >= 0)
);

-- Indexes for queries
CREATE INDEX IF NOT EXISTS idx_milestones_addiction_id ON milestones(addiction_id);
CREATE INDEX IF NOT EXISTS idx_milestones_is_achieved ON milestones(is_achieved);

-- =====================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- =====================================================

-- Enable RLS on all tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE addictions ENABLE ROW LEVEL SECURITY;
ALTER TABLE surveys ENABLE ROW LEVEL SECURITY;
ALTER TABLE milestones ENABLE ROW LEVEL SECURITY;

-- Users: Can only read/update their own profile
CREATE POLICY "Users can view own profile"
    ON users FOR SELECT
    USING (auth.uid() = id);

CREATE POLICY "Users can update own profile"
    ON users FOR UPDATE
    USING (auth.uid() = id);

-- Addictions: Can only access their own addictions
CREATE POLICY "Users can view own addictions"
    ON addictions FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own addictions"
    ON addictions FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own addictions"
    ON addictions FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own addictions"
    ON addictions FOR DELETE
    USING (auth.uid() = user_id);

-- Surveys: Can only access surveys for their addictions
CREATE POLICY "Users can view own surveys"
    ON surveys FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM addictions
            WHERE addictions.id = surveys.addiction_id
            AND addictions.user_id = auth.uid()
        )
    );

CREATE POLICY "Users can insert own surveys"
    ON surveys FOR INSERT
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM addictions
            WHERE addictions.id = surveys.addiction_id
            AND addictions.user_id = auth.uid()
        )
    );

-- Milestones: Can only access milestones for their addictions
CREATE POLICY "Users can view own milestones"
    ON milestones FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM addictions
            WHERE addictions.id = milestones.addiction_id
            AND addictions.user_id = auth.uid()
        )
    );

CREATE POLICY "Users can insert own milestones"
    ON milestones FOR INSERT
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM addictions
            WHERE addictions.id = milestones.addiction_id
            AND addictions.user_id = auth.uid()
        )
    );

CREATE POLICY "Users can update own milestones"
    ON milestones FOR UPDATE
    USING (
        EXISTS (
            SELECT 1 FROM addictions
            WHERE addictions.id = milestones.addiction_id
            AND addictions.user_id = auth.uid()
        )
    );

-- =====================================================
-- HELPER FUNCTIONS
-- =====================================================

-- Function to automatically update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger for users table
CREATE TRIGGER update_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Trigger for addictions table
CREATE TRIGGER update_addictions_updated_at
    BEFORE UPDATE ON addictions
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- VIEWS FOR COMMON QUERIES
-- =====================================================

-- View for addiction statistics
CREATE OR REPLACE VIEW addiction_stats AS
SELECT 
    a.id,
    a.user_id,
    a.addiction_type,
    a.streak,
    a.slips,
    EXTRACT(EPOCH FROM (NOW() - a.counter_start_at)) / 86400 AS days_sober,
    COUNT(DISTINCT s.id) FILTER (WHERE NOT s.slipped) AS successful_checkins,
    COUNT(DISTINCT s.id) AS total_checkins,
    a.time_saved_per_day * EXTRACT(EPOCH FROM (NOW() - a.counter_start_at)) / 86400 AS total_time_saved_minutes,
    a.money_saved_per_day * EXTRACT(EPOCH FROM (NOW() - a.counter_start_at)) / 86400 AS total_money_saved
FROM addictions a
LEFT JOIN surveys s ON s.addiction_id = a.id
GROUP BY a.id;

-- Grant access to views
GRANT SELECT ON addiction_stats TO authenticated;

-- =====================================================
-- SEED DATA (Optional - for testing)
-- =====================================================

-- Uncomment to insert sample data
/*
INSERT INTO users (name, email, password_hash, dob, score) VALUES
('Test User', 'test@example.com', '$2b$12$example_hash', '1990-01-01', 100);
*/
