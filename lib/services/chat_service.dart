import '../models/chat_model.dart';

class ChatService {
  static final ChatService _instance = ChatService._internal();
  factory ChatService() => _instance;
  ChatService._internal();

  final String _uuid = DateTime.now().millisecondsSinceEpoch.toString();

  final List<ChatRoom> _chatRooms = [
    ChatRoom(
      id: 'room_1',
      customerId: 'usr_1',
      customerName: 'Ahmad',
      penyediaId: 'usr_2',
      penyediaName: 'Budi Freelancer',
      lastMessage: 'Halo kak, jasanya masih tersedia?',
      lastMessageTime: DateTime.now().subtract(const Duration(minutes: 5)),
      unreadCount: 1,
    ),
  ];

  final Map<String, List<ChatMessage>> _messages = {
    'room_1': [
      ChatMessage(
        id: 'msg_1',
        senderId: 'usr_1',
        receiverId: 'usr_2',
        message: 'Halo kak, jasanya masih tersedia?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        isRead: false,
      ),
    ]
  };

  List<ChatRoom> getChatRooms(String userId) {
    return _chatRooms.where((room) => 
      room.customerId == userId || room.penyediaId == userId
    ).toList()
      ..sort((a, b) => (b.lastMessageTime ?? DateTime.now()).compareTo(a.lastMessageTime ?? DateTime.now()));
  }

  ChatRoom? getOrCreateChatRoom(String customerId, String customerName, String penyediaId, String penyediaName) {
    try {
      return _chatRooms.firstWhere((room) => 
        room.customerId == customerId && room.penyediaId == penyediaId
      );
    } catch (e) {
      final newRoom = ChatRoom(
      id: _uuid,
        customerId: customerId,
        customerName: customerName,
        penyediaId: penyediaId,
        penyediaName: penyediaName,
      );
      _chatRooms.add(newRoom);
      _messages[newRoom.id] = [];
      return newRoom;
    }
  }

  List<ChatMessage> getMessages(String chatRoomId) {
    return _messages[chatRoomId] ?? [];
  }

  void sendMessage(String chatRoomId, ChatMessage message) {
    if (!_messages.containsKey(chatRoomId)) {
      _messages[chatRoomId] = [];
    }
    
    final newMessage = ChatMessage(
      id: _uuid,
      senderId: message.senderId,
      receiverId: message.receiverId,
      message: message.message,
      timestamp: DateTime.now(),
      isRead: false,
    );
    
    _messages[chatRoomId]!.add(newMessage);
    
    // Update chat room last message
    final roomIndex = _chatRooms.indexWhere((room) => room.id == chatRoomId);
    if (roomIndex != -1) {
      final oldRoom = _chatRooms[roomIndex];
      _chatRooms[roomIndex] = ChatRoom(
        id: oldRoom.id,
        customerId: oldRoom.customerId,
        customerName: oldRoom.customerName,
        penyediaId: oldRoom.penyediaId,
        penyediaName: oldRoom.penyediaName,
        lastMessage: message.message,
        lastMessageTime: newMessage.timestamp,
        unreadCount: oldRoom.unreadCount + 1, // Assuming not read instantly
      );
    }
  }
}
