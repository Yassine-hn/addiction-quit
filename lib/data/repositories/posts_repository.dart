import '../../data/databases/db_helper.dart';
import '../../data/databases/tables/posts_table.dart';

class PostsRepository {
  /// Create a new post
  Future<int> createPost({
    required int userId,
    required String title,
    required String content,
    String? imageUrl,
    String visibility = 'public',
  }) async {
    final db = await DatabaseHelper.instance.database;
    return await PostsTable.insert(db, {
      'user_id': userId,
      'title': title,
      'content': content,
      'image_url': imageUrl,
      'visibility': visibility,
      'comment_count': 0,
      'reaction_count': 0,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  /// Get post by ID
  Future<Map<String, dynamic>?> getPost(int postId) async {
    final db = await DatabaseHelper.instance.database;
    return await PostsTable.getById(db, postId);
  }

  /// Get user's posts
  Future<List<Map<String, dynamic>>> getUserPosts(int userId, {int? limit}) async {
    final db = await DatabaseHelper.instance.database;
    return await PostsTable.getByUserId(db, userId, limit: limit);
  }

  /// Get public feed
  Future<List<Map<String, dynamic>>> getPublicFeed({int? limit, int? offset}) async {
    final db = await DatabaseHelper.instance.database;
    return await PostsTable.getPublicFeed(
      db: db,
      limit: limit,
      offset: offset,
    );
  }

  /// Update post
  Future<void> updatePost(int postId, {String? title, String? content, String? imageUrl}) async {
    final db = await DatabaseHelper.instance.database;
    final updates = <String, dynamic>{};
    if (title != null) updates['title'] = title;
    if (content != null) updates['content'] = content;
    if (imageUrl != null) updates['image_url'] = imageUrl;
    
    if (updates.isNotEmpty) {
      await PostsTable.update(db, postId, updates);
    }
  }

  /// Delete post
  Future<void> deletePost(int postId) async {
    final db = await DatabaseHelper.instance.database;
    await PostsTable.delete(db, postId);
  }

  /// Get posts created after a timestamp (for sync)
  Future<List<Map<String, dynamic>>> getPostsForSync(String lastSyncTime) async {
    final db = await DatabaseHelper.instance.database;
    return await PostsTable.getCreatedAfter(db, lastSyncTime);
  }
}
