from flask import Blueprint, request, jsonify
from services.database_service import db_service
from services.auth_service import token_required
from models.schemas import SurveyCreate
from pydantic import ValidationError
from datetime import datetime

survey_bp = Blueprint('survey', __name__, url_prefix='/api/surveys')

@survey_bp.route('', methods=['GET'])
@token_required
def get_surveys(current_user_id):
    """Get surveys by addiction_id and optional date"""
    try:
        addiction_id = request.args.get('addiction_id', type=int)
        date = request.args.get('date')
        
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
        
        surveys = db_service.get_surveys_by_addiction(addiction_id, date)
        
        return jsonify({
            'success': True,
            'message': 'Surveys retrieved successfully',
            'data': {'surveys': surveys}
        }), 200
        
    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'Server error: {str(e)}'
        }), 500

@survey_bp.route('', methods=['POST'])
@token_required
def create_survey(current_user_id):
    """Create a new survey (check-in)"""
    try:
        # Validate request data
        data = SurveyCreate(**request.json)
        
        # Verify addiction belongs to user
        addiction = db_service.get_addiction(data.addiction_id)
        if not addiction or addiction['user_id'] != current_user_id:
            return jsonify({
                'success': False,
                'message': 'Unauthorized or addiction not found'
            }), 403
        
        # Prepare survey data
        survey_data = {
            'addiction_id': data.addiction_id,
            'date': data.date,
            'slipped': data.slipped,
            'slip_amount': data.slip_amount if data.slipped else None,
            'mood': data.mood,
            'urge_level': data.urge_level,
            'coping_strategy': data.coping_strategy,
            'stress_level': data.stress_level,
            'created_at': datetime.utcnow().isoformat()
        }
        
        survey = db_service.create_survey(survey_data)
        
        if not survey:
            return jsonify({
                'success': False,
                'message': 'Failed to create survey'
            }), 500
        
        # If slipped, update addiction counter and streak
        if data.slipped:
            reset_data = {
                'counter_start_at': datetime.utcnow().isoformat(),
                'streak': 0,
                'slips': addiction.get('slips', 0) + 1,
                'updated_at': datetime.utcnow().isoformat()
            }
            db_service.update_addiction(data.addiction_id, reset_data)
        else:
            # Increment streak
            streak_data = {
                'streak': addiction.get('streak', 0) + 1,
                'updated_at': datetime.utcnow().isoformat()
            }
            db_service.update_addiction(data.addiction_id, streak_data)
        
        return jsonify({
            'success': True,
            'message': 'Survey submitted successfully',
            'data': {'survey': survey}
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
