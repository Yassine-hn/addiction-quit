#!/usr/bin/env python3
"""
Supabase Database Seeder

This script seeds the Supabase (cloud) database with sample data for testing.
It requires the Supabase URL and API key to be set in environment variables.

Usage:
    python seed_supabase.py
"""

import os
import sys
from datetime import datetime, timedelta
from dotenv import load_dotenv
from supabase import create_client, Client

# Load environment variables
load_dotenv()

SUPABASE_URL = os.getenv('SUPABASE_URL')
SUPABASE_KEY = os.getenv('SUPABASE_KEY')

if not SUPABASE_URL or not SUPABASE_KEY:
    print("Error: SUPABASE_URL and SUPABASE_KEY must be set in .env file")
    sys.exit(1)

# Initialize Supabase client
supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)


def clear_all_data():
    """Clear all existing data from tables (in reverse order of dependencies)"""
    print("🗑️  Clearing existing data...")
    
    tables = [
        'notifications',
        'heroes',
        'post_reactions',
        'comments',
        'posts',
        'activity_logs',
        'reminders',
        'milestones',
        'surveys',
        'addictions',
        'users'
    ]
    
    for table in tables:
        try:
            supabase.table(table).delete().neq('id', 0).execute()
            print(f"   ✓ Cleared {table}")
        except Exception as e:
            print(f"   ⚠️  Could not clear {table}: {e}")


def seed_users():
    """Create sample users"""
    print("\n👤 Creating users...")
    
    users_data = [
        {
            'name': 'Test User',
            'email': 'test@example.com',
            'password_hash': '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5eM7M3w0D3Zqe',  # password123
            'dob': '1990-01-15',
            'score': 150,
            'bio': 'Fighting my addictions one day at a time',
            'language': 'en',
            'is_active': True
        },
        {
            'name': 'Maria Garcia',
            'email': 'maria@example.com',
            'password_hash': '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5eM7M3w0D3Zqe',
            'dob': '1988-05-22',
            'score': 320,
            'bio': '42 days alcohol-free and counting',
            'language': 'en',
            'is_active': True
        },
        {
            'name': 'David Chen',
            'email': 'david@example.com',
            'password_hash': '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5eM7M3w0D3Zqe',
            'dob': '1985-11-08',
            'score': 580,
            'bio': 'Quit smoking 85 days ago',
            'language': 'en',
            'is_active': True
        }
    ]
    
    created_users = []
    for user_data in users_data:
        result = supabase.table('users').insert(user_data).execute()
        created_users.append(result.data[0])
        print(f"   ✓ Created user: {user_data['name']}")
    
    return created_users


def seed_addictions(users):
    """Create addictions for users"""
    print("\n🎯 Creating addictions...")
    
    addictions_data = []
    
    # Test User - 30 days sober from alcohol
    start1 = datetime.now() - timedelta(days=30)
    addictions_data.append({
        'user_id': users[0]['id'],
        'addiction_type': 'Alcohol',
        'start_date': start1.date().isoformat(),
        'counter_start_at': start1.isoformat(),
        'goal_type': 'total',
        'time_saved_per_day': 120,
        'money_saved_per_day': 25.00,
        'streak': 19,
        'slips': 1,
        'last_slip_at': (start1 + timedelta(days=10)).isoformat(),
        'status': 'active',
        'note': 'Want to quit for health reasons',
        'motivation': 'Be a better parent'
    })
    
    # Maria - 42 days alcohol free
    start2 = datetime.now() - timedelta(days=42)
    addictions_data.append({
        'user_id': users[1]['id'],
        'addiction_type': 'Alcohol',
        'start_date': start2.date().isoformat(),
        'counter_start_at': start2.isoformat(),
        'goal_type': 'total',
        'time_saved_per_day': 90,
        'money_saved_per_day': 30.00,
        'streak': 42,
        'slips': 0,
        'status': 'active',
        'motivation': 'Health and wellness'
    })
    
    # David - 85 days smoke free
    start3 = datetime.now() - timedelta(days=85)
    addictions_data.append({
        'user_id': users[2]['id'],
        'addiction_type': 'Smoking',
        'start_date': start3.date().isoformat(),
        'counter_start_at': start3.isoformat(),
        'goal_type': 'total',
        'time_saved_per_day': 60,
        'money_saved_per_day': 15.00,
        'streak': 85,
        'slips': 0,
        'status': 'active',
        'motivation': 'Better health'
    })
    
    created_addictions = []
    for addiction_data in addictions_data:
        result = supabase.table('addictions').insert(addiction_data).execute()
        created_addictions.append(result.data[0])
        print(f"   ✓ Created addiction: {addiction_data['addiction_type']} for user")
    
    return created_addictions


def seed_surveys(addictions):
    """Create daily check-in surveys"""
    print("\n📝 Creating surveys (daily check-ins)...")
    
    surveys_data = []
    moods = ['happy', 'calm', 'motivated', 'confident']
    
    # Create surveys for first addiction (30 days)
    start_date = datetime.now() - timedelta(days=30)
    for i in range(30):
        date = start_date + timedelta(days=i)
        if date > datetime.now():
            break
        
        # Day 11 was a slip
        is_slip = (i == 10)
        
        surveys_data.append({
            'addiction_id': addictions[0]['id'],
            'date': date.date().isoformat(),
            'slipped': is_slip,
            'slip_amount': 2 if is_slip else None,
            'mood': 'sad' if is_slip else moods[i % len(moods)],
            'urge_level': 8 if is_slip else (i % 5) + 1,
            'note': 'Had a tough day' if is_slip else 'Feeling good today!',
            'stress_level': 7 if is_slip else (i % 4) + 1
        })
    
    # Batch insert surveys
    if surveys_data:
        result = supabase.table('surveys').insert(surveys_data).execute()
        print(f"   ✓ Created {len(result.data)} surveys")
    
    return surveys_data


def seed_milestones(addictions):
    """Create milestones"""
    print("\n🏆 Creating milestones...")
    
    milestones_data = []
    
    # Milestones for first addiction
    start_date = datetime.now() - timedelta(days=30)
    
    milestones_data.extend([
        {
            'addiction_id': addictions[0]['id'],
            'title': '1 Week Clean',
            'description': 'First week without alcohol',
            'target_value': 7,
            'reward_points': 50,
            'is_achieved': True,
            'type': 'milestone',
            'achieved_at': (start_date + timedelta(days=7)).isoformat()
        },
        {
            'addiction_id': addictions[0]['id'],
            'title': '30 Days Clean',
            'description': 'One month milestone',
            'target_value': 30,
            'reward_points': 200,
            'is_achieved': True,
            'type': 'milestone',
            'achieved_at': datetime.now().isoformat()
        },
        {
            'addiction_id': addictions[0]['id'],
            'title': '90 Days Clean',
            'description': 'Three months milestone',
            'target_value': 90,
            'reward_points': 500,
            'is_achieved': False,
            'type': 'milestone'
        }
    ])
    
    result = supabase.table('milestones').insert(milestones_data).execute()
    print(f"   ✓ Created {len(result.data)} milestones")
    
    return result.data


def seed_posts(users):
    """Create community posts"""
    print("\n💬 Creating community posts...")
    
    posts_data = [
        {
            'user_id': users[0]['id'],
            'title': 'My Journey',
            'content': 'Just hit my 30-day milestone! It\'s been tough, but this community has been a huge help. Thank you all for the support.',
            'visibility': 'public',
            'comment_count': 5,
            'reaction_count': 42,
            'is_anonymous': False,
            'created_at': (datetime.now() - timedelta(hours=2)).isoformat()
        },
        {
            'user_id': users[1]['id'],
            'title': 'Tips for Success',
            'content': 'Remember that recovery is a journey, not a destination. Each step, no matter how small, is a victory. Be kind to yourself today.',
            'visibility': 'public',
            'comment_count': 8,
            'reaction_count': 67,
            'is_anonymous': False,
            'created_at': (datetime.now() - timedelta(days=1)).isoformat()
        },
        {
            'user_id': users[2]['id'],
            'title': 'Question',
            'content': 'Does anyone have tips for dealing with cravings in social situations? I find weekends particularly challenging.',
            'visibility': 'public',
            'comment_count': 12,
            'reaction_count': 28,
            'is_anonymous': False,
            'created_at': (datetime.now() - timedelta(hours=8)).isoformat()
        }
    ]
    
    result = supabase.table('posts').insert(posts_data).execute()
    print(f"   ✓ Created {len(result.data)} posts")
    
    return result.data


def seed_heroes(users, addictions):
    """Create heroes of the last month"""
    print("\n⭐ Creating heroes...")
    
    # Calculate last month's date range
    today = datetime.now().date()
    # First day of current month
    first_day_current = today.replace(day=1)
    # Last day of previous month
    last_day_previous = first_day_current - timedelta(days=1)
    # First day of previous month
    first_day_previous = last_day_previous.replace(day=1)
    
    heroes_data = [
        {
            'user_id': users[2]['id'],  # David with 85 days
            'period_type': 'monthly',
            'period_start': first_day_previous.isoformat(),
            'period_end': last_day_previous.isoformat(),
            'score': 85,
            'rank': 1,
            'metric_source': 'streak'
        },
        {
            'user_id': users[1]['id'],  # Maria with 42 days
            'period_type': 'monthly',
            'period_start': first_day_previous.isoformat(),
            'period_end': last_day_previous.isoformat(),
            'score': 42,
            'rank': 2,
            'metric_source': 'streak'
        },
        {
            'user_id': users[0]['id'],  # Sophie with 61 days
            'period_type': 'monthly',
            'period_start': first_day_previous.isoformat(),
            'period_end': last_day_previous.isoformat(),
            'score': 61,
            'rank': 3,
            'metric_source': 'streak'
        }
    ]
    
    result = supabase.table('heroes').insert(heroes_data).execute()
    print(f"   ✓ Created {len(result.data)} heroes")
    
    return result.data


def main():
    """Main seeding function"""
    print("=" * 60)
    print("🌱 SEEDING SUPABASE DATABASE")
    print("=" * 60)
    
    try:
        # Clear existing data
        clear_all_data()
        
        # Seed data in order
        users = seed_users()
        addictions = seed_addictions(users)
        surveys = seed_surveys(addictions)
        milestones = seed_milestones(addictions)
        posts = seed_posts(users)
        heroes = seed_heroes(users, addictions)
        
        print("\n" + "=" * 60)
        print("✅ SEEDING COMPLETED SUCCESSFULLY!")
        print("=" * 60)
        print(f"\nCreated:")
        print(f"  - {len(users)} users")
        print(f"  - {len(addictions)} addictions")
        print(f"  - {len(surveys)} surveys")
        print(f"  - {len(milestones)} milestones")
        print(f"  - {len(posts)} posts")
        print(f"  - {len(heroes)} heroes")
        print()
        
    except Exception as e:
        print(f"\n❌ Error during seeding: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)


if __name__ == '__main__':
    main()
