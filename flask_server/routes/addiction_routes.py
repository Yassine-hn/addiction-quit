from flask import Blueprint, request, jsonify
from services.database_service import db_service
from services.auth_service import token_required
from models.schemas import AddictionCreate, AddictionUpdate
from pydantic import ValidationError
from datetime import datetime

addiction_bp = Blueprint('addiction', __name__, url_prefix='/api/addictions')

@addiction_bp.route('', methods=['GET'])
@token_required
def get_addictions(current_user_id):
    """Get all addictions for the current user"""
    try:
        addictions = db_service.get_user_addictions(current_user_id)
        
        return jsonify({
            'success': True,
            'message': 'Addictions retrieved successfully',
            'data': {'addictions': addictions}
        }), 200
        
    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'Server error: {str(e)}'
        }), 500

@addiction_bp.route('/<int:addiction_id>', methods=['GET'])
@token_required
def get_addiction(current_user_id, addiction_id):
    """Get a specific addiction"""
    try:
        addiction = db_service.get_addiction(addiction_id)
        
        if not addiction:
            return jsonify({
                'success': False,
                'message': 'Addiction not found'
            }), 404
        
        # Verify ownership
        if addiction['user_id'] != current_user_id:
            return jsonify({
                'success': False,
                'message': 'Unauthorized'
            }), 403
        
        return jsonify({
            'success': True,
            'message': 'Addiction retrieved successfully',
            'data': {'addiction': addiction}
        }), 200
        
    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'Server error: {str(e)}'
        }), 500

@addiction_bp.route('', methods=['POST'])
@token_required
def create_addiction(current_user_id):
    """Create a new addiction"""
    try:
        # Validate request data
        data = AddictionCreate(**request.json)
        
        # Prepare addiction data
        addiction_data = {
            'user_id': current_user_id,
            'addiction_type': data.addiction_type,
            'counter_start_at': data.counter_start_at,
            'target_date': data.target_date,
            'goal_type': data.goal_type,
            'daily_target': data.daily_target,
            'weekly_target': data.weekly_target,
            'time_saved_per_day': data.time_saved_per_day,
            'money_saved_per_day': data.money_saved_per_day,
            'streak': 0,
            'slips': 0,
            'created_at': datetime.utcnow().isoformat()
        }
        
        addiction = db_service.create_addiction(addiction_data)
        
        if not addiction:
            return jsonify({
                'success': False,
                'message': 'Failed to create addiction'
            }), 500
        
        return jsonify({
            'success': True,
            'message': 'Addiction created successfully',
            'data': {'addiction': addiction}
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

@addiction_bp.route('/<int:addiction_id>', methods=['PUT'])
@token_required
def update_addiction(current_user_id, addiction_id):
    """Update an addiction"""
    try:
        # Check if addiction exists and belongs to user
        addiction = db_service.get_addiction(addiction_id)
        
        if not addiction:
            return jsonify({
                'success': False,
                'message': 'Addiction not found'
            }), 404
        
        if addiction['user_id'] != current_user_id:
            return jsonify({
                'success': False,
                'message': 'Unauthorized'
            }), 403
        
        # Validate request data
        data = AddictionUpdate(**request.json)
        
        # Prepare update data (only include provided fields)
        update_data = {k: v for k, v in data.dict(exclude_unset=True).items()}
        update_data['updated_at'] = datetime.utcnow().isoformat()
        
        updated_addiction = db_service.update_addiction(addiction_id, update_data)
        
        if not updated_addiction:
            return jsonify({
                'success': False,
                'message': 'Failed to update addiction'
            }), 500
        
        return jsonify({
            'success': True,
            'message': 'Addiction updated successfully',
            'data': {'addiction': updated_addiction}
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

@addiction_bp.route('/<int:addiction_id>', methods=['DELETE'])
@token_required
def delete_addiction(current_user_id, addiction_id):
    """Delete an addiction"""
    try:
        # Check if addiction exists and belongs to user
        addiction = db_service.get_addiction(addiction_id)
        
        if not addiction:
            return jsonify({
                'success': False,
                'message': 'Addiction not found'
            }), 404
        
        if addiction['user_id'] != current_user_id:
            return jsonify({
                'success': False,
                'message': 'Unauthorized'
            }), 403
        
        success = db_service.delete_addiction(addiction_id)
        
        if not success:
            return jsonify({
                'success': False,
                'message': 'Failed to delete addiction'
            }), 500
        
        return jsonify({
            'success': True,
            'message': 'Addiction deleted successfully'
        }), 200
        
    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'Server error: {str(e)}'
        }), 500

@addiction_bp.route('/<int:addiction_id>/reset', methods=['POST'])
@token_required
def reset_counter(current_user_id, addiction_id):
    """Reset addiction counter"""
    try:
        # Check if addiction exists and belongs to user
        addiction = db_service.get_addiction(addiction_id)
        
        if not addiction:
            return jsonify({
                'success': False,
                'message': 'Addiction not found'
            }), 404
        
        if addiction['user_id'] != current_user_id:
            return jsonify({
                'success': False,
                'message': 'Unauthorized'
            }), 403
        
        # Reset counter
        reset_data = {
            'counter_start_at': datetime.utcnow().isoformat(),
            'streak': 0,
            'slips': addiction.get('slips', 0) + 1,
            'updated_at': datetime.utcnow().isoformat()
        }
        
        updated_addiction = db_service.update_addiction(addiction_id, reset_data)
        
        if not updated_addiction:
            return jsonify({
                'success': False,
                'message': 'Failed to reset counter'
            }), 500
        
        return jsonify({
            'success': True,
            'message': 'Counter reset successfully',
            'data': {'addiction': updated_addiction}
        }), 200
        
    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'Server error: {str(e)}'
        }), 500
