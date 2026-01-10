from flask import Blueprint, request, jsonify
from services.database_service import db_service
from services.auth_service import hash_password, verify_password, generate_token
from models.schemas import UserRegister, UserLogin
from pydantic import ValidationError
from datetime import datetime


def _sanitize_user(user: dict | None):
    """Remove sensitive fields before returning user data to clients."""
    if not user:
        return None
    sanitized = dict(user)
    sanitized.pop('password_hash', None)
    return sanitized

auth_bp = Blueprint('auth', __name__, url_prefix='/api/auth')

@auth_bp.route('/register', methods=['POST'])
def register():
    """Register a new user"""
    try:
        # Validate request data
        data = UserRegister(**request.json)
        
        # Check if user already exists
        existing_user = db_service.get_user_by_email(data.email)
        if existing_user:
            return jsonify({
                'success': False,
                'message': 'Email already registered'
            }), 400
        
        # Hash password
        hashed_password = hash_password(data.password)
        
        # Create user - use client-provided values when available (from local state)
        # created_at from local is preserved; updated_at will be set by Supabase DEFAULT
        user_data = {
            'name': data.name,
            'email': data.email,
            'password_hash': hashed_password,
            'dob': data.dob,
            'bio': data.bio,
            'avatar_url': data.avatar_url,
            'language': data.language or 'en',
            'score': data.score or 0,
            'is_active': data.is_active if data.is_active is not None else True,
            'last_login_at': data.last_login_at,
            'created_at': data.created_at or datetime.utcnow().isoformat()
        }
        
        user = db_service.create_user(user_data)
        
        if not user:
            return jsonify({
                'success': False,
                'message': 'Failed to create user'
            }), 500
        
        # Generate tokens
        access_token = generate_token(user['id'], 'access')
        refresh_token = generate_token(user['id'], 'refresh')
        
        return jsonify({
            'success': True,
            'message': 'User registered successfully',
            'data': {
                'user': _sanitize_user(user),
                'access_token': access_token,
                'refresh_token': refresh_token
            }
        }), 201
        
    except ValidationError as e:
        return jsonify({
            'success': False,
            'message': 'Validation error',
            'errors': e.errors()
        }), 400
    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'Server error: {str(e)}'
        }), 500

@auth_bp.route('/login', methods=['POST'])
def login():
    """Login user"""
    try:
        # Validate request data
        data = UserLogin(**request.json)
        
        # Get user by email
        user = db_service.get_user_by_email(data.email)
        
        if not user:
            return jsonify({
                'success': False,
                'message': 'Invalid email or password'
            }), 401
        
        # Verify password
        if not verify_password(data.password, user['password_hash']):
            return jsonify({
                'success': False,
                'message': 'Invalid email or password'
            }), 401
        
        # Update last login
        db_service.update_user(user['id'], {
            'last_login_at': datetime.utcnow().isoformat()
        })
        
        # Generate tokens
        access_token = generate_token(user['id'], 'access')
        refresh_token = generate_token(user['id'], 'refresh')
        
        return jsonify({
            'success': True,
            'message': 'Login successful',
            'data': {
                'user': _sanitize_user(user),
                'access_token': access_token,
                'refresh_token': refresh_token
            }
        }), 200
        
    except ValidationError as e:
        return jsonify({
            'success': False,
            'message': 'Validation error',
            'errors': e.errors()
        }), 400
    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'Server error: {str(e)}'
        }), 500

@auth_bp.route('/logout', methods=['POST'])
def logout():
    """Logout user (client should delete tokens)"""
    return jsonify({
        'success': True,
        'message': 'Logout successful'
    }), 200
