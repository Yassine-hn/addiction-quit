from flask import Blueprint, request, jsonify
from datetime import datetime, timedelta
from functools import wraps
import os
from supabase import create_client, Client
import jwt

community_bp = Blueprint('community', __name__, url_prefix='/api/community')

# Initialize Supabase client
supabase_url = os.getenv('SUPABASE_URL')
supabase_key = os.getenv('SUPABASE_ANON_KEY')
supabase: Client = create_client(supabase_url, supabase_key)

# ============ Authentication Helper ============

def token_required(f):
    """Decorator to check JWT token and extract user_id"""
    @wraps(f)
    def decorated(*args, **kwargs):
        token = None
        
        # Get token from Authorization header
        if 'Authorization' in request.headers:
            auth_header = request.headers['Authorization']
            try:
                token = auth_header.split(" ")[1]
            except IndexError:
                return jsonify({'success': False, 'message': 'Invalid token format'}), 401
        
        if not token:
            return jsonify({'success': False, 'message': 'Token is missing'}), 401
        
        try:
            # Verify and decode token using Supabase's JWT
            secret = os.getenv('SUPABASE_JWT_SECRET', '')
            if not secret:
                # Alternative: verify with Supabase directly
                decoded = supabase.auth.get_user(token).user
                user_id = decoded.id if decoded else None
            else:
                decoded = jwt.decode(token, secret, algorithms=['HS256'])
                user_id = decoded.get('sub')
            
            if not user_id:
                return jsonify({'success': False, 'message': 'Invalid token'}), 401
                
            request.user_id = user_id
            return f(*args, **kwargs)
        except Exception as e:
            print(f'Token verification error: {e}')
            return jsonify({'success': False, 'message': 'Invalid token'}), 401
    
    return decorated

# ============ Heroes Endpoints ============

@community_bp.route('/heroes/last-month', methods=['GET'])
def get_heroes_last_month():
    """
    Get heroes from the last calendar month.
    Fetches heroes whose period_start or period_end falls within the previous month.
    Returns top 10 ranked by score.
    """
    try:
        # Calculate last month's date range
        today = datetime.now()
        # First day of current month
        first_day_current = today.replace(day=1)
        # Last day of previous month
        last_day_previous = first_day_current - timedelta(days=1)
        # First day of previous month
        first_day_previous = last_day_previous.replace(day=1)
        
        # Query heroes where period overlaps with last month
        response = supabase.table('heroes').select(
            'id, user_id, score, rank, period_type, period_start, period_end, users(name, avatar_url)',
            count='exact'
        ).gte('period_end', first_day_previous.isoformat()).lte('period_start', last_day_previous.isoformat()).order(
            'score', desc=True
        ).limit(10).execute()
        
        heroes = []
        for hero in response.data:
            user = hero.get('users') or {}
            heroes.append({
                'id': hero['id'],
                'name': user.get('name', 'Unknown'),
                'days': hero['score'],  # Using score as days equivalent
                'imageUrl': user.get('avatar_url', 'assets/images/default_avatar.png'),
                'score': hero['score'],
                'rank': hero['rank']
            })
        
        return jsonify({
            'success': True,
            'data': heroes,
            'count': len(heroes)
        }), 200
    
    except Exception as e:
        print(f'Error fetching heroes: {e}')
        return jsonify({
            'success': False,
            'message': f'Error fetching heroes: {str(e)}'
        }), 500

# ============ Posts Endpoints ============

@community_bp.route('/posts', methods=['GET'])
def get_posts():
    """
    Get public posts with pagination.
    Query parameters:
        - limit: number of posts per page (default: 20)
        - offset: number of posts to skip (default: 0)
    """
    try:
        limit = request.args.get('limit', 20, type=int)
        offset = request.args.get('offset', 0, type=int)
        
        # Get current user_id if authenticated (for checking likes)
        current_user_id = None
        if 'Authorization' in request.headers:
            auth_header = request.headers.get('Authorization', '')
            try:
                token = auth_header.split(" ")[1]
                secret = os.getenv('SUPABASE_JWT_SECRET', '')
                if secret:
                    decoded = jwt.decode(token, secret, algorithms=['HS256'])
                    current_user_id = decoded.get('sub')
            except:
                pass
        
        # Get posts with user info
        response = supabase.table('posts').select(
            'id, user_id, content, reaction_count, comment_count, created_at, '
            'users(name, avatar_url), '
            'post_reactions(user_id)',
            count='exact'
        ).eq('visibility', 'public').eq('is_anonymous', False).order(
            'created_at', desc=True
        ).range(offset, offset + limit - 1).execute()
        
        posts = []
        for post in response.data:
            user = post.get('users') or {}
            # Check if current user has liked this post
            is_liked = False
            if current_user_id:
                reactions = post.get('post_reactions', [])
                is_liked = any(r['user_id'] == current_user_id for r in reactions)
            
            created_at = datetime.fromisoformat(post['created_at'].replace('Z', '+00:00'))
            time_ago = _format_time_ago(created_at)
            
            posts.append({
                'id': post['id'],
                'authorName': user.get('name', 'Anonymous'),
                'authorImage': user.get('avatar_url', 'assets/images/default_avatar.png'),
                'timeAgo': time_ago,
                'content': post['content'],
                'likes': post.get('reaction_count', 0),
                'comments': post.get('comment_count', 0),
                'badge': None,
                'isLikedByUser': is_liked
            })
        
        return jsonify({
            'success': True,
            'data': posts,
            'count': len(posts),
            'total': response.count
        }), 200
    
    except Exception as e:
        print(f'Error fetching posts: {e}')
        return jsonify({
            'success': False,
            'message': f'Error fetching posts: {str(e)}'
        }), 500

@community_bp.route('/posts', methods=['POST'])
@token_required
def create_post():
    """
    Create a new community post.
    Requires authentication.
    Body:
        - content: string (required)
    """
    try:
        data = request.get_json()
        content = data.get('content', '').strip()
        
        if not content:
            return jsonify({
                'success': False,
                'message': 'Content cannot be empty'
            }), 400
        
        # Insert post
        response = supabase.table('posts').insert({
            'user_id': request.user_id,
            'content': content,
            'visibility': 'public',
            'is_anonymous': False,
            'comment_count': 0,
            'reaction_count': 0,
            'created_at': datetime.now().isoformat()
        }).execute()
        
        if response.data:
            post = response.data[0]
            return jsonify({
                'success': True,
                'message': 'Post created successfully',
                'data': {
                    'id': post['id'],
                    'content': post['content'],
                    'created_at': post['created_at']
                }
            }), 201
        else:
            return jsonify({
                'success': False,
                'message': 'Failed to create post'
            }), 500
    
    except Exception as e:
        print(f'Error creating post: {e}')
        return jsonify({
            'success': False,
            'message': f'Error creating post: {str(e)}'
        }), 500

@community_bp.route('/posts/<int:post_id>', methods=['DELETE'])
@token_required
def delete_post(post_id):
    """
    Delete a post.
    Requires authentication and ownership of the post.
    """
    try:
        # Check if post exists and belongs to user
        post_response = supabase.table('posts').select('id, user_id').eq('id', post_id).single().execute()
        
        if not post_response.data:
            return jsonify({
                'success': False,
                'message': 'Post not found'
            }), 404
        
        post = post_response.data
        if post['user_id'] != request.user_id:
            return jsonify({
                'success': False,
                'message': 'Unauthorized: You can only delete your own posts'
            }), 403
        
        # Delete post (cascade will delete comments and reactions)
        supabase.table('posts').delete().eq('id', post_id).execute()
        
        return jsonify({
            'success': True,
            'message': 'Post deleted successfully'
        }), 200
    
    except Exception as e:
        print(f'Error deleting post: {e}')
        return jsonify({
            'success': False,
            'message': f'Error deleting post: {str(e)}'
        }), 500

# ============ Comments Endpoints ============

@community_bp.route('/posts/<int:post_id>/comments', methods=['GET'])
def get_comments(post_id):
    """
    Get comments for a specific post.
    Query parameters:
        - limit: number of comments per page (default: 20)
        - offset: number of comments to skip (default: 0)
    """
    try:
        limit = request.args.get('limit', 20, type=int)
        offset = request.args.get('offset', 0, type=int)
        
        # Get comments with user info
        response = supabase.table('comments').select(
            'id, user_id, content, created_at, users(name, avatar_url)',
            count='exact'
        ).eq('post_id', post_id).order(
            'created_at', desc=True
        ).range(offset, offset + limit - 1).execute()
        
        comments = []
        for comment in response.data:
            user = comment.get('users') or {}
            created_at = datetime.fromisoformat(comment['created_at'].replace('Z', '+00:00'))
            
            comments.append({
                'id': comment['id'],
                'authorName': user.get('name', 'Anonymous'),
                'authorImage': user.get('avatar_url', 'assets/images/default_avatar.png'),
                'content': comment['content'],
                'createdAt': comment['created_at']
            })
        
        return jsonify({
            'success': True,
            'data': comments,
            'count': len(comments),
            'total': response.count
        }), 200
    
    except Exception as e:
        print(f'Error fetching comments: {e}')
        return jsonify({
            'success': False,
            'message': f'Error fetching comments: {str(e)}'
        }), 500

@community_bp.route('/posts/<int:post_id>/comments', methods=['POST'])
@token_required
def create_comment(post_id):
    """
    Create a comment on a post.
    Requires authentication.
    Body:
        - content: string (required)
    """
    try:
        data = request.get_json()
        content = data.get('content', '').strip()
        
        if not content:
            return jsonify({
                'success': False,
                'message': 'Comment content cannot be empty'
            }), 400
        
        # Check if post exists
        post_check = supabase.table('posts').select('id').eq('id', post_id).single().execute()
        if not post_check.data:
            return jsonify({
                'success': False,
                'message': 'Post not found'
            }), 404
        
        # Insert comment
        response = supabase.table('comments').insert({
            'post_id': post_id,
            'user_id': request.user_id,
            'content': content,
            'is_anonymous': False,
            'created_at': datetime.now().isoformat()
        }).execute()
        
        if response.data:
            comment = response.data[0]
            
            # Update comment count on post
            supabase.table('posts').update(
                {'comment_count': supabase.table('posts').select('*').execute().data[0]['comment_count'] + 1}
            ).eq('id', post_id).execute()
            
            return jsonify({
                'success': True,
                'message': 'Comment created successfully',
                'data': {
                    'id': comment['id'],
                    'content': comment['content'],
                    'created_at': comment['created_at']
                }
            }), 201
        else:
            return jsonify({
                'success': False,
                'message': 'Failed to create comment'
            }), 500
    
    except Exception as e:
        print(f'Error creating comment: {e}')
        return jsonify({
            'success': False,
            'message': f'Error creating comment: {str(e)}'
        }), 500

@community_bp.route('/comments/<int:comment_id>', methods=['DELETE'])
@token_required
def delete_comment(comment_id):
    """
    Delete a comment.
    Requires authentication and ownership of the comment.
    """
    try:
        # Check if comment exists and belongs to user
        comment_response = supabase.table('comments').select('id, user_id, post_id').eq('id', comment_id).single().execute()
        
        if not comment_response.data:
            return jsonify({
                'success': False,
                'message': 'Comment not found'
            }), 404
        
        comment = comment_response.data
        if comment['user_id'] != request.user_id:
            return jsonify({
                'success': False,
                'message': 'Unauthorized: You can only delete your own comments'
            }), 403
        
        post_id = comment['post_id']
        
        # Delete comment
        supabase.table('comments').delete().eq('id', comment_id).execute()
        
        # Decrement comment count on post
        current_post = supabase.table('posts').select('comment_count').eq('id', post_id).single().execute()
        if current_post.data:
            new_count = max(0, current_post.data[0]['comment_count'] - 1)
            supabase.table('posts').update({'comment_count': new_count}).eq('id', post_id).execute()
        
        return jsonify({
            'success': True,
            'message': 'Comment deleted successfully'
        }), 200
    
    except Exception as e:
        print(f'Error deleting comment: {e}')
        return jsonify({
            'success': False,
            'message': f'Error deleting comment: {str(e)}'
        }), 500

# ============ Reactions (Likes) Endpoints ============

@community_bp.route('/posts/<int:post_id>/react', methods=['POST'])
@token_required
def toggle_post_reaction(post_id):
    """
    Toggle a like reaction on a post.
    Requires authentication.
    """
    try:
        # Check if post exists
        post_check = supabase.table('posts').select('reaction_count').eq('id', post_id).single().execute()
        if not post_check.data:
            return jsonify({
                'success': False,
                'message': 'Post not found'
            }), 404
        
        # Check if user already liked this post
        existing = supabase.table('post_reactions').select('id').eq('post_id', post_id).eq('user_id', request.user_id).execute()
        
        if existing.data:
            # Unlike: delete the reaction
            supabase.table('post_reactions').delete().eq('post_id', post_id).eq('user_id', request.user_id).execute()
            
            # Decrement reaction count
            current_count = post_check.data[0]['reaction_count']
            new_count = max(0, current_count - 1)
            supabase.table('posts').update({'reaction_count': new_count}).eq('id', post_id).execute()
            
            return jsonify({
                'success': True,
                'message': 'Post unliked successfully',
                'isLiked': False,
                'likeCount': new_count
            }), 200
        else:
            # Like: insert the reaction
            supabase.table('post_reactions').insert({
                'post_id': post_id,
                'user_id': request.user_id,
                'reaction_type': 'like',
                'created_at': datetime.now().isoformat()
            }).execute()
            
            # Increment reaction count
            current_count = post_check.data[0]['reaction_count']
            new_count = current_count + 1
            supabase.table('posts').update({'reaction_count': new_count}).eq('id', post_id).execute()
            
            return jsonify({
                'success': True,
                'message': 'Post liked successfully',
                'isLiked': True,
                'likeCount': new_count
            }), 200
    
    except Exception as e:
        print(f'Error toggling reaction: {e}')
        return jsonify({
            'success': False,
            'message': f'Error toggling reaction: {str(e)}'
        }), 500

# ============ Helper Functions ============

def _format_time_ago(created_at: datetime) -> str:
    """
    Format datetime to human-readable 'time ago' format.
    """
    now = datetime.now(created_at.tzinfo) if created_at.tzinfo else datetime.now()
    diff = now - created_at
    
    seconds = diff.total_seconds()
    
    if seconds < 60:
        return 'just now'
    elif seconds < 3600:
        minutes = int(seconds / 60)
        return f'{minutes}m ago'
    elif seconds < 86400:
        hours = int(seconds / 3600)
        return f'{hours}h ago'
    elif seconds < 604800:
        days = int(seconds / 86400)
        return f'{days}d ago'
    elif seconds < 2592000:
        weeks = int(seconds / 604800)
        return f'{weeks}w ago'
    else:
        months = int(seconds / 2592000)
        return f'{months}mo ago'
