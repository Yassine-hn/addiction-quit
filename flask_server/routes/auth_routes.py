from flask import Blueprint, request, jsonify
from services.database_service import db_service
from services.auth_service import hash_password, verify_password, generate_token
from models.schemas import UserRegister, UserLogin
from pydantic import ValidationError
from datetime import datetime

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
        
        # Create user
        user_data = {
            'name': data.name,
            'email': data.email,
            'password_hash': hashed_password,
            'dob': data.dob,
            'bio': data.bio,
            'avatar_url': data.avatar_url,
            'language': data.language or 'en',
            'score': data.score or 0,
            'is_active': True,
            'created_at': datetime.utcnow().isoformat()
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
                'user': user,
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
                'user': {
                    'id': user['id'],
                    'name': user['name'],
                    'email': user['email'],
                    'score': user.get('score', 0)
                },
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
