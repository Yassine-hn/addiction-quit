import '../../data/databases/db_helper.dart';
import '../../data/databases/tables/post_reactions_table.dart';
import '../../data/databases/tables/posts_table.dart';

class PostReactionsRepository {
  /// Add/toggle a reaction to a post
  Future<bool> toggleReaction(int postId, Object userId) async {
    final db = await DatabaseHelper.instance.database;
    
    // Check if user already reacted
    final existingReaction = await PostReactionsTable.getUserReaction(db, postId, userId);
    
    if (existingReaction != null) {
      // Remove reaction
      await PostReactionsTable.delete(db, existingReaction['id']);
    } else {
      // Add reaction
      final now = DateTime.now().toIso8601String();
      await PostReactionsTable.insert(db, {
        'post_id': postId,
        'user_id': userId.toString(),
        'created_at': now,
        'updated_at': now,
      });
    }

    // Update post's reaction count
    final count = await PostReactionsTable.countByPostId(db, postId);
    await PostsTable.updateReactionCount(db, postId, count);

    return existingReaction == null; // Return true if added, false if removed
  }

  /// Get reactions for a post
  Future<List<Map<String, dynamic>>> getPostReactions(int postId) async {
    final db = await DatabaseHelper.instance.database;
    return await PostReactionsTable.getByPostId(db, postId);
  }

  /// Check if user has reacted to a post
  Future<bool> hasUserReacted(int postId, Object userId) async {
    final db = await DatabaseHelper.instance.database;
    final reaction = await PostReactionsTable.getUserReaction(db, postId, userId);
    return reaction != null;
  }

  /// Get user's reactions
  Future<List<Map<String, dynamic>>> getUserReactions(Object userId, {int? limit}) async {
    final db = await DatabaseHelper.instance.database;
    return await PostReactionsTable.getByUserId(db, userId, limit: limit);
  }

  /// Get reaction count for a post
  Future<int> getReactionCount(int postId) async {
    final db = await DatabaseHelper.instance.database;
    return await PostReactionsTable.countByPostId(db, postId);
  }

  /// Get reactions created after a timestamp (for sync)
  Future<List<Map<String, dynamic>>> getReactionsForSync(String lastSyncTime) async {
    final db = await DatabaseHelper.instance.database;
    return await PostReactionsTable.getCreatedAfter(db, lastSyncTime);
  }
}
