class NotificationModel {
  final String id;
  final String userId;
  final String title;
  final String message;
  final String type; // 'booking', 'chat', 'review', 'system'
  final String? referenceId;
  final bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    this.referenceId,
    this.isRead = false,
    required this.createdAt,
  });
}
