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

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      message: map['message'] ?? '',
      type: map['type'] ?? 'system',
      referenceId: map['referenceId'],
      isRead: map['isRead'] ?? false,
      createdAt: DateTime.parse(map['createdAt']).toLocal(),
    );
  }
}
