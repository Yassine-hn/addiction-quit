import jwt
import bcrypt
from datetime import datetime, timedelta
from functools import wraps
from flask import request, jsonify
from config import get_config

config = get_config()

def hash_password(password: str) -> str:
    """Hash a password using bcrypt"""
    return bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt()).decode('utf-8')

def verify_password(password: str, hashed: str) -> bool:
    """Verify a password against a hash"""
    return bcrypt.checkpw(password.encode('utf-8'), hashed.encode('utf-8'))

def generate_token(user_id: int, token_type: str = 'access') -> str:
    """Generate JWT token"""
    expires = timedelta(
        seconds=config.JWT_ACCESS_TOKEN_EXPIRES if token_type == 'access' 
        else config.JWT_REFRESH_TOKEN_EXPIRES
    )
    
    payload = {
        'user_id': user_id,
        'type': token_type,
        'exp': datetime.utcnow() + expires,
        'iat': datetime.utcnow()
    }
    
    return jwt.encode(payload, config.JWT_SECRET_KEY, algorithm=config.JWT_ALGORITHM)

def decode_token(token: str) -> dict:
    """Decode JWT token"""
    try:
        return jwt.decode(token, config.JWT_SECRET_KEY, algorithms=[config.JWT_ALGORITHM])
    except jwt.ExpiredSignatureError:
        raise ValueError('Token has expired')
    except jwt.InvalidTokenError:
        raise ValueError('Invalid token')

def token_required(f):
    """Decorator to protect routes with JWT authentication"""
    @wraps(f)
    def decorated(*args, **kwargs):
        token = None
        
        # Get token from Authorization header
        if 'Authorization' in request.headers:
            auth_header = request.headers['Authorization']
            try:
                token = auth_header.split(' ')[1]  # Bearer <token>
            except IndexError:
                return jsonify({
                    'success': False,
                    'message': 'Invalid authorization header format'
                }), 401
        
        if not token:
            return jsonify({
                'success': False,
                'message': 'Token is missing'
            }), 401
        
        try:
            payload = decode_token(token)
            request.user_id = payload['user_id']
        except ValueError as e:
            return jsonify({
                'success': False,
                'message': str(e)
            }), 401
        
        return f(*args, **kwargs)
    
    return decorated
