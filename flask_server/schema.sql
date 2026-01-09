-- =====================================================
-- COMPLETE ADDICTION QUIT DATABASE SCHEMA FOR SUPABASE
-- =====================================================
-- This script creates all tables, indexes, policies, and functions
-- Run this in your Supabase SQL Editor to create the complete database
-- =====================================================

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- =====================================================
-- TABLE: USERS
-- =====================================================
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    dob DATE,
    score INTEGER DEFAULT 0,
    avatar_url TEXT,
    bio TEXT,
    language TEXT DEFAULT 'en',
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    last_login_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ
);

-- Indexes for users table
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_is_active ON users(is_active);

-- =====================================================
-- TABLE: ADDICTIONS
-- =====================================================
CREATE TABLE IF NOT EXISTS addictions (
    id SERIAL PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    addiction_type TEXT NOT NULL,
    start_date DATE NOT NULL DEFAULT CURRENT_DATE,
    counter_start_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    target_date DATE,
    goal_type TEXT NOT NULL CHECK (goal_type IN ('daily', 'weekly', 'total')),
    daily_target INTEGER CHECK (daily_target IS NULL OR daily_target >= 0),
    weekly_target INTEGER CHECK (weekly_target IS NULL OR weekly_target >= 0),
    time_saved_per_day INTEGER NOT NULL DEFAULT 0, -- in minutes
    money_saved_per_day NUMERIC(10, 2) NOT NULL DEFAULT 0.00,
    streak INTEGER DEFAULT 0 CHECK (streak >= 0),
    slips INTEGER DEFAULT 0 CHECK (slips >= 0),
    last_slip_at TIMESTAMPTZ,
    status TEXT DEFAULT 'active' CHECK (status IN ('active', 'paused', 'completed', 'archived')),
    note TEXT,
    motivation TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ
);

-- Indexes for addictions table
CREATE INDEX IF NOT EXISTS idx_addictions_user_id ON addictions(user_id);
CREATE INDEX IF NOT EXISTS idx_addictions_status ON addictions(status);
CREATE INDEX IF NOT EXISTS idx_addictions_created_at ON addictions(created_at);
CREATE INDEX IF NOT EXISTS idx_addictions_user_status ON addictions(user_id, status);

-- =====================================================
-- TABLE: DAILY_SURVEYS (Daily Check-ins)
-- =====================================================
CREATE TABLE IF NOT EXISTS daily_surveys (
    id SERIAL PRIMARY KEY,
    addiction_id INTEGER NOT NULL REFERENCES addictions(id) ON DELETE CASCADE,
    date DATE NOT NULL,
    slipped BOOLEAN NOT NULL DEFAULT false,
    slip_amount INTEGER CHECK (
        (slipped = false AND slip_amount IS NULL) OR
        (slipped = true AND slip_amount IS NOT NULL AND slip_amount > 0)
    ),
    mood TEXT NOT NULL CHECK (mood IN ('happy', 'sad', 'anxious', 'calm', 'stressed', 'motivated', 'frustrated', 'confident')),
    urge_level INTEGER NOT NULL CHECK (urge_level >= 0 AND urge_level <= 10),
    difficulty TEXT CHECK (difficulty IS NULL OR difficulty IN ('easy', 'medium', 'hard', 'very_hard')),
    triggers TEXT, -- JSON array of trigger strings
    note TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    CONSTRAINT unique_addiction_date UNIQUE(addiction_id, date)
);

-- Indexes for daily_surveys table
CREATE INDEX IF NOT EXISTS idx_daily_surveys_addiction_id ON daily_surveys(addiction_id);
CREATE INDEX IF NOT EXISTS idx_daily_surveys_date ON daily_surveys(date);
CREATE INDEX IF NOT EXISTS idx_daily_surveys_addiction_date ON daily_surveys(addiction_id, date);
CREATE INDEX IF NOT EXISTS idx_daily_surveys_slipped ON daily_surveys(slipped);

-- =====================================================
-- TABLE: MILESTONES
-- =====================================================
CREATE TABLE IF NOT EXISTS milestones (
    id SERIAL PRIMARY KEY,
    addiction_id INTEGER NOT NULL REFERENCES addictions(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    description TEXT,
    target_value INTEGER NOT NULL CHECK (target_value > 0),
    reward_points INTEGER NOT NULL DEFAULT 0 CHECK (reward_points >= 0),
    is_achieved BOOLEAN DEFAULT false,
    type TEXT DEFAULT 'milestone' CHECK (type IN ('milestone', 'goal', 'achievement')),
    icon_url TEXT,
    deadline DATE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    achieved_at TIMESTAMPTZ
);

-- Indexes for milestones table
CREATE INDEX IF NOT EXISTS idx_milestones_addiction_id ON milestones(addiction_id);
CREATE INDEX IF NOT EXISTS idx_milestones_is_achieved ON milestones(is_achieved);
CREATE INDEX IF NOT EXISTS idx_milestones_deadline ON milestones(deadline);

-- =====================================================
-- TABLE: REMINDERS
-- =====================================================
CREATE TABLE IF NOT EXISTS reminders (
    id SERIAL PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    addiction_id INTEGER NOT NULL REFERENCES addictions(id) ON DELETE CASCADE,
    reminder_time TIME NOT NULL,
    repeat_daily BOOLEAN DEFAULT true,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes for reminders table
CREATE INDEX IF NOT EXISTS idx_reminders_user_id ON reminders(user_id);
CREATE INDEX IF NOT EXISTS idx_reminders_addiction_id ON reminders(addiction_id);
CREATE INDEX IF NOT EXISTS idx_reminders_is_active ON reminders(is_active);

-- =====================================================
-- TABLE: ACTIVITY_LOGS
-- =====================================================
CREATE TABLE IF NOT EXISTS activity_logs (
    id SERIAL PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    action_type TEXT NOT NULL CHECK (action_type IN ('addiction_created', 'milestone_achieved', 'survey_completed', 'slip_recorded', 'goal_updated', 'login', 'logout')),
    meta JSONB, -- Store additional metadata as JSON
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes for activity_logs table
CREATE INDEX IF NOT EXISTS idx_activity_logs_user_id ON activity_logs(user_id);
CREATE INDEX IF NOT EXISTS idx_activity_logs_action_type ON activity_logs(action_type);
CREATE INDEX IF NOT EXISTS idx_activity_logs_created_at ON activity_logs(created_at);

-- =====================================================
-- TABLE: POSTS (Community Feature)
-- =====================================================
CREATE TABLE IF NOT EXISTS posts (
    id SERIAL PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title TEXT,
    content TEXT NOT NULL,
    image_url TEXT,
    is_anonymous BOOLEAN DEFAULT false,
    visibility TEXT DEFAULT 'public' CHECK (visibility IN ('public', 'private', 'friends')),
    comment_count INTEGER DEFAULT 0 CHECK (comment_count >= 0),
    reaction_count INTEGER DEFAULT 0 CHECK (reaction_count >= 0),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ
);

-- Indexes for posts table
CREATE INDEX IF NOT EXISTS idx_posts_user_id ON posts(user_id);
CREATE INDEX IF NOT EXISTS idx_posts_visibility ON posts(visibility);
CREATE INDEX IF NOT EXISTS idx_posts_created_at ON posts(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_posts_is_anonymous ON posts(is_anonymous);

-- =====================================================
-- TABLE: COMMENTS
-- =====================================================
CREATE TABLE IF NOT EXISTS comments (
    id SERIAL PRIMARY KEY,
    post_id INTEGER NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    is_anonymous BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ
);

-- Indexes for comments table
CREATE INDEX IF NOT EXISTS idx_comments_post_id ON comments(post_id);
CREATE INDEX IF NOT EXISTS idx_comments_user_id ON comments(user_id);
CREATE INDEX IF NOT EXISTS idx_comments_created_at ON comments(created_at);

-- =====================================================
-- TABLE: POST_REACTIONS (Likes)
-- =====================================================
CREATE TABLE IF NOT EXISTS post_reactions (
    id SERIAL PRIMARY KEY,
    post_id INTEGER NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    reaction_type TEXT DEFAULT 'like' CHECK (reaction_type IN ('like', 'love', 'support', 'celebrate')),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ,
    CONSTRAINT unique_post_user_reaction UNIQUE(post_id, user_id)
);

-- Indexes for post_reactions table
CREATE INDEX IF NOT EXISTS idx_post_reactions_post_id ON post_reactions(post_id);
CREATE INDEX IF NOT EXISTS idx_post_reactions_user_id ON post_reactions(user_id);

-- =====================================================
-- TABLE: HEROES (Heroes of the Week/Month)
-- =====================================================
CREATE TABLE IF NOT EXISTS heroes (
    id SERIAL PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    period_type TEXT NOT NULL CHECK (period_type IN ('daily', 'weekly', 'monthly', 'yearly')),
    period_start DATE NOT NULL,
    period_end DATE NOT NULL,
    score INTEGER DEFAULT 0 CHECK (score >= 0),
    rank INTEGER CHECK (rank > 0),
    metric_source TEXT, -- e.g., 'streak', 'surveys_completed', 'milestones_achieved'
    hero_badge_url TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes for heroes table
CREATE INDEX IF NOT EXISTS idx_heroes_user_id ON heroes(user_id);
CREATE INDEX IF NOT EXISTS idx_heroes_period_type ON heroes(period_type);
CREATE INDEX IF NOT EXISTS idx_heroes_period ON heroes(period_start, period_end);
CREATE INDEX IF NOT EXISTS idx_heroes_rank ON heroes(rank);

-- =====================================================
-- TABLE: NOTIFICATIONS
-- =====================================================
CREATE TABLE IF NOT EXISTS notifications (
    id SERIAL PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    type TEXT NOT NULL CHECK (type IN ('milestone', 'reminder', 'community', 'achievement', 'hero', 'system')),
    title TEXT NOT NULL,
    message TEXT NOT NULL,
    data JSONB, -- Additional notification data
    is_read BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes for notifications table
CREATE INDEX IF NOT EXISTS idx_notifications_user_id ON notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_is_read ON notifications(is_read);
CREATE INDEX IF NOT EXISTS idx_notifications_type ON notifications(type);
CREATE INDEX IF NOT EXISTS idx_notifications_created_at ON notifications(created_at DESC);

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

-- Apply updated_at trigger to relevant tables
CREATE TRIGGER update_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_addictions_updated_at
    BEFORE UPDATE ON addictions
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_posts_updated_at
    BEFORE UPDATE ON posts
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_comments_updated_at
    BEFORE UPDATE ON comments
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_post_reactions_updated_at
    BEFORE UPDATE ON post_reactions
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- Function to increment post comment count
-- =====================================================
CREATE OR REPLACE FUNCTION increment_post_comment_count()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE posts
    SET comment_count = comment_count + 1
    WHERE id = NEW.post_id;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER increment_comment_count_on_insert
    AFTER INSERT ON comments
    FOR EACH ROW
    EXECUTE FUNCTION increment_post_comment_count();

-- Function to decrement post comment count
CREATE OR REPLACE FUNCTION decrement_post_comment_count()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE posts
    SET comment_count = GREATEST(0, comment_count - 1)
    WHERE id = OLD.post_id;
    RETURN OLD;
END;
$$ language 'plpgsql';

CREATE TRIGGER decrement_comment_count_on_delete
    AFTER DELETE ON comments
    FOR EACH ROW
    EXECUTE FUNCTION decrement_post_comment_count();

-- =====================================================
-- Function to increment post reaction count
-- =====================================================
CREATE OR REPLACE FUNCTION increment_post_reaction_count()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE posts
    SET reaction_count = reaction_count + 1
    WHERE id = NEW.post_id;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER increment_reaction_count_on_insert
    AFTER INSERT ON post_reactions
    FOR EACH ROW
    EXECUTE FUNCTION increment_post_reaction_count();

-- Function to decrement post reaction count
CREATE OR REPLACE FUNCTION decrement_post_reaction_count()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE posts
    SET reaction_count = GREATEST(0, reaction_count - 1)
    WHERE id = OLD.post_id;
    RETURN OLD;
END;
$$ language 'plpgsql';

CREATE TRIGGER decrement_reaction_count_on_delete
    AFTER DELETE ON post_reactions
    FOR EACH ROW
    EXECUTE FUNCTION decrement_post_reaction_count();

-- =====================================================
-- VIEWS FOR COMMON QUERIES
-- =====================================================

CREATE OR REPLACE VIEW addiction_stats AS
SELECT 
    a.id,
    a.user_id,
    a.addiction_type,
    a.streak,
    a.slips,
    EXTRACT(EPOCH FROM (NOW() - a.counter_start_at)) / 86400 AS days_sober,
    ROUND((EXTRACT(EPOCH FROM (NOW() - a.counter_start_at)) / 3600)::NUMERIC, 2) AS hours_sober,
    COUNT(DISTINCT s.id) FILTER (WHERE NOT s.slipped) AS successful_checkins,
    COUNT(DISTINCT s.id) AS total_checkins,
    ROUND((a.time_saved_per_day * EXTRACT(EPOCH FROM (NOW() - a.counter_start_at)) / 86400)::NUMERIC, 2) AS total_time_saved_minutes,
    ROUND((a.money_saved_per_day * EXTRACT(EPOCH FROM (NOW() - a.counter_start_at)) / 86400)::NUMERIC, 2) AS total_money_saved,
    a.status,
    a.created_at
FROM addictions a
LEFT JOIN daily_surveys s ON s.addiction_id = a.id
GROUP BY a.id;

CREATE OR REPLACE VIEW user_stats AS
SELECT 
    u.id,
    u.name,
    u.email,
    u.score,
    COUNT(DISTINCT a.id) AS total_addictions,
    COUNT(DISTINCT a.id) FILTER (WHERE a.status = 'active') AS active_addictions,
    COUNT(DISTINCT s.id) AS total_surveys,
    COUNT(DISTINCT m.id) FILTER (WHERE m.is_achieved = true) AS achieved_milestones,
    COUNT(DISTINCT p.id) AS total_posts,
    COUNT(DISTINCT c.id) AS total_comments,
    u.created_at
FROM users u
LEFT JOIN addictions a ON a.user_id = u.id
LEFT JOIN daily_surveys s ON s.addiction_id = a.id
LEFT JOIN milestones m ON m.addiction_id = a.id
LEFT JOIN posts p ON p.user_id = u.id
LEFT JOIN comments c ON c.user_id = u.id
GROUP BY u.id;

-- View for community feed (public posts with user info)
CREATE OR REPLACE VIEW community_feed AS
SELECT 
    p.id,
    p.user_id,
    CASE 
        WHEN p.is_anonymous THEN 'Anonymous'
        ELSE u.name
    END AS author_name,
    CASE 
        WHEN p.is_anonymous THEN NULL
        ELSE u.avatar_url
    END AS author_avatar,
    p.title,
    p.content,
    p.image_url,
    p.comment_count,
    p.reaction_count,
    p.visibility,
    p.created_at,
    p.updated_at
FROM posts p
JOIN users u ON u.id = p.user_id
WHERE p.visibility = 'public'
ORDER BY p.created_at DESC;

-- =====================================================
-- COMPLETION MESSAGE
-- =====================================================
-- Database schema created successfully!
-- All tables, indexes, triggers, and views are now in place.
-- =====================================================
