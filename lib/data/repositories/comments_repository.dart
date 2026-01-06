import '../../data/databases/db_helper.dart';
import '../../data/databases/tables/comments_table.dart';
import '../../data/databases/tables/posts_table.dart';

class CommentsRepository {
  /// Create a new comment
  Future<int> createComment({
    required int postId,
    required int userId,
    required String content,
  }) async {
    final db = await DatabaseHelper.instance.database;
    
    // Insert the comment
    final commentId = await CommentsTable.insert(db, {
      'post_id': postId,
      'user_id': userId,
      'content': content,
      'created_at': DateTime.now().toIso8601String(),
    });

    // Update the post's comment count
    final count = await CommentsTable.countByPostId(db, postId);
    await PostsTable.updateCommentCount(db, postId, count);

    return commentId;
  }

  /// Get comments for a post
  Future<List<Map<String, dynamic>>> getPostComments(int postId, {int? limit}) async {
    final db = await DatabaseHelper.instance.database;
    return await CommentsTable.getByPostId(db, postId, limit: limit);
  }

  /// Get user's comments
  Future<List<Map<String, dynamic>>> getUserComments(int userId, {int? limit}) async {
    final db = await DatabaseHelper.instance.database;
    return await CommentsTable.getByUserId(db, userId, limit: limit);
  }

  /// Get comment by ID
  Future<Map<String, dynamic>?> getComment(int commentId) async {
    final db = await DatabaseHelper.instance.database;
    return await CommentsTable.getById(db, commentId);
  }

  /// Update comment
  Future<void> updateComment(int commentId, String content) async {
    final db = await DatabaseHelper.instance.database;
    await CommentsTable.update(db, commentId, {'content': content});
  }

  /// Delete comment
  Future<void> deleteComment(int commentId) async {
    final db = await DatabaseHelper.instance.database;
    
    // Get the comment to find its post
    final comment = await CommentsTable.getById(db, commentId);
    if (comment != null) {
      final postId = comment['post_id'] as int;
      
      // Delete the comment
      await CommentsTable.delete(db, commentId);
      
      // Update post's comment count
      final count = await CommentsTable.countByPostId(db, postId);
      await PostsTable.updateCommentCount(db, postId, count);
    }
  }

  /// Get comments created after a timestamp (for sync)
  Future<List<Map<String, dynamic>>> getCommentsForSync(String lastSyncTime) async {
    final db = await DatabaseHelper.instance.database;
    return await CommentsTable.getCreatedAfter(db, lastSyncTime);
  }
}
