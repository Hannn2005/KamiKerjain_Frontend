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

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'] ?? '',
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      message: map['message'] ?? '',
      timestamp: DateTime.parse(map['timestamp']).toLocal(),
      isRead: map['isRead'] ?? false,
    );
  }
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

  factory ChatRoom.fromMap(Map<String, dynamic> map) {
    return ChatRoom(
      id: map['id'] ?? '',
      customerId: map['customerId'] ?? '',
      customerName: map['customerName'] ?? '',
      penyediaId: map['penyediaId'] ?? '',
      penyediaName: map['penyediaName'] ?? '',
      lastMessage: map['lastMessage'],
      lastMessageTime: map['lastMessageTime'] != null
          ? DateTime.parse(map['lastMessageTime']).toLocal()
          : null,
      unreadCount: (map['unreadCount'] ?? 0).toInt(),
    );
  }
}
