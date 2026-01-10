from flask import Blueprint, request, jsonify
from services.database_service import db_service
from services.auth_service import token_required
from models.schemas import MilestoneCreate
from pydantic import ValidationError
from datetime import datetime

milestone_bp = Blueprint('milestone', __name__, url_prefix='/api/milestones')

@milestone_bp.route('', methods=['GET'])
@token_required
def get_milestones(current_user_id):
    """Get milestones by addiction_id"""
    try:
        addiction_id = request.args.get('addiction_id', type=int)
        
        if not addiction_id:
            return jsonify({
                'success': False,
                'message': 'addiction_id is required'
            }), 400
        
        # Verify addiction belongs to user
        addiction = db_service.get_addiction(addiction_id)
        if not addiction or addiction['user_id'] != current_user_id:
            return jsonify({
                'success': False,
                'message': 'Unauthorized or addiction not found'
            }), 403
        
        milestones = db_service.get_milestones(addiction_id)
        
        return jsonify({
            'success': True,
            'message': 'Milestones retrieved successfully',
            'data': {'milestones': milestones}
        }), 200
        
    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'Server error: {str(e)}'
        }), 500

@milestone_bp.route('', methods=['POST'])
@token_required
def create_milestone(current_user_id):
    """Create a new milestone"""
    try:
        # Validate request data
        data = MilestoneCreate(**request.json)
        
        # Verify addiction belongs to user
        addiction = db_service.get_addiction(data.addiction_id)
        if not addiction or addiction['user_id'] != current_user_id:
            return jsonify({
                'success': False,
                'message': 'Unauthorized or addiction not found'
            }), 403
        
        # Prepare milestone data
        milestone_data = {
            'addiction_id': data.addiction_id,
            'title': data.title,
            'target_value': data.target_value,
            'reward_points': data.reward_points,
            'is_achieved': False,
            'created_at': datetime.utcnow().isoformat()
        }
        
        milestone = db_service.create_milestone(milestone_data)
        
        if not milestone:
            return jsonify({
                'success': False,
                'message': 'Failed to create milestone'
            }), 500
        
        return jsonify({
            'success': True,
            'message': 'Milestone created successfully',
            'data': {'milestone': milestone}
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

@milestone_bp.route('/<int:milestone_id>/claim', methods=['PUT'])
@token_required
def claim_milestone(current_user_id, milestone_id):
    """Claim a milestone reward"""
    try:
        # Get milestone
        milestone = db_service.get_milestone(milestone_id)
        
        if not milestone:
            return jsonify({
                'success': False,
                'message': 'Milestone not found'
            }), 404
        
        # Verify milestone belongs to user's addiction
        addiction = db_service.get_addiction(milestone['addiction_id'])
        if not addiction or addiction['user_id'] != current_user_id:
            return jsonify({
                'success': False,
                'message': 'Unauthorized'
            }), 403
        
        # Check if already claimed
        if milestone.get('is_achieved'):
            return jsonify({
                'success': False,
                'message': 'Milestone already claimed'
            }), 400
        
        # Update milestone status
        milestone_update = {
            'is_achieved': True,
            'achieved_at': datetime.utcnow().isoformat()
        }
        updated_milestone = db_service.update_milestone(milestone_id, milestone_update)
        
        # Update user score
        user = db_service.get_user_by_id(current_user_id)
        new_score = user.get('score', 0) + milestone.get('reward_points', 0)
        db_service.update_user(current_user_id, {'score': new_score})
        
        return jsonify({
            'success': True,
            'message': 'Milestone claimed successfully',
            'data': {
                'milestone': updated_milestone,
                'new_score': new_score
            }
        }), 200
        
    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'Server error: {str(e)}'
        }), 500

@milestone_bp.route('/<int:milestone_id>/reset', methods=['POST'])
@token_required
def reset_milestone(current_user_id, milestone_id):
    """Reset milestone progress on slip"""
    try:
        # Get milestone
        milestone = db_service.get_milestone(milestone_id)
        
        if not milestone:
            return jsonify({
                'success': False,
                'message': 'Milestone not found'
            }), 404
        
        # Verify milestone belongs to user's addiction
        addiction = db_service.get_addiction(milestone['addiction_id'])
        if not addiction or addiction['user_id'] != current_user_id:
            return jsonify({
                'success': False,
                'message': 'Unauthorized'
            }), 403
        
        # Reset milestone if not yet achieved
        if not milestone.get('is_achieved'):
            milestone_update = {
                'created_at': datetime.utcnow().isoformat()
            }
            updated_milestone = db_service.update_milestone(milestone_id, milestone_update)
            
            return jsonify({
                'success': True,
                'message': 'Milestone reset successfully',
                'data': {'milestone': updated_milestone}
            }), 200
        else:
            return jsonify({
                'success': False,
                'message': 'Cannot reset achieved milestone'
            }), 400
        
    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'Server error: {str(e)}'
        }), 500
