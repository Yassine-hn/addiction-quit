import '../../data/databases/db_helper.dart';
import '../../data/databases/tables/notifications_table.dart';

class NotificationsRepository {
  /// Create a new notification
  Future<int> createNotification({
    required int userId,
    required String type,
    required String data,
  }) async {
    final db = await DatabaseHelper.instance.database;
    return await NotificationsTable.insert(db, {
      'user_id': userId,
      'type': type,
      'data': data,
      'is_read': 0,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  /// Get all notifications for a user
  Future<List<Map<String, dynamic>>> getUserNotifications(int userId, {int? limit}) async {
    final db = await DatabaseHelper.instance.database;
    return await NotificationsTable.getByUserId(db, userId, limit: limit);
  }

  /// Get unread notifications for a user
  Future<List<Map<String, dynamic>>> getUnreadNotifications(int userId, {int? limit}) async {
    final db = await DatabaseHelper.instance.database;
    return await NotificationsTable.getUnreadByUserId(db, userId, limit: limit);
  }

  /// Get notifications of a specific type
  Future<List<Map<String, dynamic>>> getNotificationsByType(
    int userId,
    String type, {
    int? limit,
  }) async {
    final db = await DatabaseHelper.instance.database;
    return await NotificationsTable.getByType(db, userId, type, limit: limit);
  }

  /// Get notification by ID
  Future<Map<String, dynamic>?> getNotification(int notificationId) async {
    final db = await DatabaseHelper.instance.database;
    return await NotificationsTable.getById(db, notificationId);
  }

  /// Mark notification as read
  Future<void> markAsRead(int notificationId) async {
    final db = await DatabaseHelper.instance.database;
    await NotificationsTable.markAsRead(db, notificationId);
  }

  /// Mark all notifications as read
  Future<void> markAllAsRead(int userId) async {
    final db = await DatabaseHelper.instance.database;
    await NotificationsTable.markAllAsRead(db, userId);
  }

  /// Delete notification
  Future<void> deleteNotification(int notificationId) async {
    final db = await DatabaseHelper.instance.database;
    await NotificationsTable.delete(db, notificationId);
  }

  /// Delete all notifications for a user
  Future<void> deleteAllNotifications(int userId) async {
    final db = await DatabaseHelper.instance.database;
    await NotificationsTable.deleteByUserId(db, userId);
  }

  /// Count unread notifications
  Future<int> getUnreadCount(int userId) async {
    final db = await DatabaseHelper.instance.database;
    return await NotificationsTable.countUnread(db, userId);
  }

  /// Get notifications created after a timestamp (for sync)
  Future<List<Map<String, dynamic>>> getNotificationsForSync(String lastSyncTime) async {
    final db = await DatabaseHelper.instance.database;
    return await NotificationsTable.getCreatedAfter(db, lastSyncTime);
  }
}
