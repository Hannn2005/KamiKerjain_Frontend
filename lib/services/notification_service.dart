import '../models/notification_model.dart';
import 'api_client.dart';

class NotificationPage {
  final List<NotificationModel> items;
  final int unreadCount;
  const NotificationPage(this.items, this.unreadCount);
}

/// Notifikasi lewat REST API (`/api/notifications`).
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final ApiClient _api = ApiClient();

  Future<NotificationPage> getNotifications() async {
    final res = await _api.get('/notifications');
    final list = (res['data'] as List?) ?? const [];
    final items = list
        .map((e) => NotificationModel.fromMap(e as Map<String, dynamic>))
        .toList();
    final unread = (res['unreadCount'] as num?)?.toInt() ??
        items.where((n) => !n.isRead).length;
    return NotificationPage(items, unread);
  }

  Future<int> getUnreadCount() async => (await getNotifications()).unreadCount;

  Future<void> markAsRead(String notificationId) async {
    await _api.patch('/notifications/$notificationId/read');
  }
}
