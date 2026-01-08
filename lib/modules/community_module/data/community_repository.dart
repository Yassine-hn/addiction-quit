import '../models/hero_model.dart';
import '../models/post_model.dart';
import '../../../data/databases/db_helper.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../data/databases/tables/posts_table.dart';

abstract class CommunityRepository {
  Future<List<HeroModel>> fetchHeroesOfWeek();
  Future<List<PostModel>> fetchCommunityPosts();
  Future<bool> createPost({required String content});
  Future<bool> likePost(int postId);
  Future<bool> commentOnPost({required int postId, required String comment});
  Future<bool> deletePost(int postId);
  Future<bool> reportPost(int postId, String reason);
}

class CommunityRepositoryImpl implements CommunityRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final UserRepositoryImpl _userRepo = UserRepositoryImpl();

  @override
  Future<List<HeroModel>> fetchHeroesOfWeek() async {
    try {
      final db = await _dbHelper.database;
      
      // Get top users by days sober (from addictions table)
      final results = await db.rawQuery('''
        SELECT u.name, u.id,
               CAST((julianday('now') - julianday(a.counter_start_at)) AS INTEGER) as days_sober
        FROM users u
        INNER JOIN addictions a ON u.id = a.user_id
        WHERE u.is_active = 1
        ORDER BY days_sober DESC
        LIMIT 4
      ''');

      return results.map((row) => HeroModel(
        name: row['name'] as String,
        days: row['days_sober'] as int,
        imageUrl: 'assets/images/default_avatar.png', // Default avatar
      )).toList();
    } catch (e) {
      print('Error fetching heroes: $e');
      return _getDefaultHeroes();
    }
  }

  @override
  Future<List<PostModel>> fetchCommunityPosts() async {
    try {
      final db = await _dbHelper.database;
      final currentUserId = await _userRepo.getCurrentUserId();
      
      // Get posts with user info and like status
      final results = await db.rawQuery('''
        SELECT 
          p.id,
          p.content,
          p.reaction_count as likes,
          p.comment_count as comments,
          p.created_at,
          u.name as author_name,
          CASE 
            WHEN pr.user_id IS NOT NULL THEN 1 
            ELSE 0 
          END as is_liked
        FROM posts p
        INNER JOIN users u ON p.user_id = u.id
        LEFT JOIN post_reactions pr ON p.id = pr.post_id AND pr.user_id = ?
        WHERE p.visibility = 'public'
        ORDER BY p.created_at DESC
        LIMIT 50
      ''', [currentUserId ?? 0]);

      return results.map((row) {
        final createdAt = DateTime.parse(row['created_at'] as String);
        final timeAgo = _formatTimeAgo(createdAt);
        
        return PostModel(
          id: row['id'] as int,
          authorName: row['author_name'] as String,
          authorImage: 'assets/images/default_avatar.png',
          timeAgo: timeAgo,
          content: row['content'] as String,
          likes: row['likes'] as int,
          comments: row['comments'] as int,
          badge: null,
          isLikedByUser: (row['is_liked'] as int) == 1,
        );
      }).toList();
    } catch (e) {
      print('Error fetching posts: $e');
      return _getDefaultPosts();
    }
  }

  @override
  Future<bool> createPost({required String content}) async {
    try {
      final db = await _dbHelper.database;
      final userId = await _userRepo.getCurrentUserId();
      
      if (userId == null) {
        print('No user logged in');
        return false;
      }

      await PostsTable.insert(db, {
        'user_id': userId,
        'title': '', // Not used in UI
        'content': content,
        'visibility': 'public',
        'comment_count': 0,
        'reaction_count': 0,
        'created_at': DateTime.now().toIso8601String(),
      });

      return true;
    } catch (e) {
      print('Error creating post: $e');
      return false;
    }
  }

  @override
  Future<bool> likePost(int postId) async {
    try {
      final db = await _dbHelper.database;
      final userId = await _userRepo.getCurrentUserId();
      
      if (userId == null) return false;

      // Check if already liked
      final existing = await db.query(
        'post_reactions',
        where: 'post_id = ? AND user_id = ?',
        whereArgs: [postId, userId],
      );

      if (existing.isNotEmpty) {
        // Unlike
        await db.delete(
          'post_reactions',
          where: 'post_id = ? AND user_id = ?',
          whereArgs: [postId, userId],
        );
        
        // Decrement count
        await db.rawUpdate('''
          UPDATE posts 
          SET reaction_count = reaction_count - 1 
          WHERE id = ?
        ''', [postId]);
      } else {
        // Like
        await db.insert('post_reactions', {
          'post_id': postId,
          'user_id': userId,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        });
        
        // Increment count
        await db.rawUpdate('''
          UPDATE posts 
          SET reaction_count = reaction_count + 1 
          WHERE id = ?
        ''', [postId]);
      }

      return true;
    } catch (e) {
      print('Error liking post: $e');
      return false;
    }
  }

  @override
  Future<bool> commentOnPost({
    required int postId,
    required String comment,
  }) async {
    try {
      final db = await _dbHelper.database;
      final userId = await _userRepo.getCurrentUserId();
      
      if (userId == null) return false;

      await db.insert('comments', {
        'post_id': postId,
        'user_id': userId,
        'content': comment,
        'created_at': DateTime.now().toIso8601String(),
      });

      // Increment comment count
      await db.rawUpdate('''
        UPDATE posts 
        SET comment_count = comment_count + 1 
        WHERE id = ?
      ''', [postId]);

      return true;
    } catch (e) {
      print('Error commenting on post: $e');
      return false;
    }
  }

  @override
  Future<bool> deletePost(int postId) async {
    try {
      final db = await _dbHelper.database;
      final userId = await _userRepo.getCurrentUserId();
      
      if (userId == null) return false;

      // Only allow deleting own posts
      await db.delete(
        'posts',
        where: 'id = ? AND user_id = ?',
        whereArgs: [postId, userId],
      );

      return true;
    } catch (e) {
      print('Error deleting post: $e');
      return false;
    }
  }

  @override
  Future<bool> reportPost(int postId, String reason) async {
    // For now, just log it
    print('Post $postId reported for: $reason');
    return true;
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }

  List<HeroModel> _getDefaultHeroes() {
    return [
      HeroModel(name: 'Maria', days: 42, imageUrl: 'assets/images/default_avatar.png'),
      HeroModel(name: 'David', days: 85, imageUrl: 'assets/images/default_avatar.png'),
      HeroModel(name: 'Sophie', days: 61, imageUrl: 'assets/images/default_avatar.png'),
      HeroModel(name: 'Chen', days: 76, imageUrl: 'assets/images/default_avatar.png'),
    ];
  }

  List<PostModel> _getDefaultPosts() {
    return [
      PostModel(
        authorName: 'Dr. Emily Carter',
        authorImage: 'assets/images/default_avatar.png',
        timeAgo: '2 hours ago',
        content:
            'Remember that recovery is a journey, not a destination. Each step, no matter how small, is a victory. Be kind to yourself today.',
        likes: 125,
        comments: 18,
        badge: 'Expert',
      ),
    ];
  }
}
