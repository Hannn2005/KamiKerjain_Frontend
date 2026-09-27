class ChatMessage {
  final String id;
  final String senderId;
  final String receiverId;
  final String message;
  final DateTime timestamp;
  final bool isRead;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    this.isRead = false,
  });
}

class ChatRoom {
  final String id;
  final String customerId;
  final String customerName;
  final String penyediaId;
  final String penyediaName;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final int unreadCount;

  ChatRoom({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.penyediaId,
    required this.penyediaName,
    this.lastMessage,
    this.lastMessageTime,
    this.unreadCount = 0,
  });
}
