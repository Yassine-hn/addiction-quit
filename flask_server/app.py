from flask import Flask, jsonify
from flask_cors import CORS
from config import get_config
import os

# Import routes
from routes.auth_routes import auth_bp
from routes.addiction_routes import addiction_bp
from routes.survey_routes import survey_bp
from routes.milestone_routes import milestone_bp
from routes.community_routes import community_bp

def create_app(config_name=None):
    """Application factory pattern"""
    app = Flask(__name__)
    
    # Load configuration
    if config_name is None:
        config_name = os.getenv('FLASK_ENV', 'development')
    
    config = get_config(config_name)
    app.config.from_object(config)
    
    # Initialize CORS
    CORS(app, resources={
        r"/api/*": {
            "origins": app.config['CORS_ORIGINS'],
            "methods": ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
            "allow_headers": ["Content-Type", "Authorization"]
        }
    })
    
    # Register blueprints
    app.register_blueprint(auth_bp)
    app.register_blueprint(addiction_bp)
    app.register_blueprint(survey_bp)
    app.register_blueprint(milestone_bp)
    app.register_blueprint(community_bp)
    
    # Health check endpoint
    @app.route('/health', methods=['GET'])
    def health_check():
        return jsonify({
            'success': True,
            'message': 'Server is running',
            'environment': config_name
        }), 200
    
    # Root endpoint
    @app.route('/', methods=['GET'])
    def root():
        return jsonify({
            'success': True,
            'message': 'Addiction Quit API',
            'version': '1.0.0',
            'endpoints': {
                'auth': '/api/auth',
                'addictions': '/api/addictions',
                'surveys': '/api/surveys',
                'milestones': '/api/milestones'
            }
        }), 200
    
    # Error handlers
    @app.errorhandler(404)
    def not_found(error):
        return jsonify({
            'success': False,
            'message': 'Resource not found'
        }), 404
    
    @app.errorhandler(500)
    def internal_error(error):
        return jsonify({
            'success': False,
            'message': 'Internal server error'
        }), 500
    
    @app.errorhandler(403)
    def forbidden(error):
        return jsonify({
            'success': False,
            'message': 'Forbidden'
        }), 403
    
    @app.errorhandler(401)
    def unauthorized(error):
        return jsonify({
            'success': False,
            'message': 'Unauthorized'
        }), 401
    
    @app.errorhandler(400)
    def bad_request(error):
        return jsonify({
            'success': False,
            'message': 'Bad request'
        }), 400
    
    return app

if __name__ == '__main__':
    app = create_app()
    port = int(os.getenv('PORT', 5000))
    debug = os.getenv('FLASK_ENV', 'development') == 'development'
    
    print(f"Starting server on port {port} in {os.getenv('FLASK_ENV', 'development')} mode...")
    app.run(host='0.0.0.0', port=port, debug=debug)
