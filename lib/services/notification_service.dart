import '../models/notification_model.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final String _uuid = DateTime.now().millisecondsSinceEpoch.toString();

  final List<NotificationModel> _notifications = [];

  List<NotificationModel> getNotifications(String userId) {
    return _notifications.where((n) => n.userId == userId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  void addNotification(NotificationModel notification) {
    final newNotif = NotificationModel(
      id: _uuid,
      userId: notification.userId,
      title: notification.title,
      message: notification.message,
      type: notification.type,
      referenceId: notification.referenceId,
      isRead: false,
      createdAt: DateTime.now(),
    );
    _notifications.add(newNotif);
  }

  void markAsRead(String notificationId) {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      final old = _notifications[index];
      _notifications[index] = NotificationModel(
        id: old.id,
        userId: old.userId,
        title: old.title,
        message: old.message,
        type: old.type,
        referenceId: old.referenceId,
        isRead: true,
        createdAt: old.createdAt,
      );
    }
  }

  int getUnreadCount(String userId) {
    return _notifications.where((n) => n.userId == userId && !n.isRead).length;
  }
}
