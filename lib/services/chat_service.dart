import '../models/chat_model.dart';
import 'api_client.dart';

class ChatService {
  static final ChatService _instance = ChatService._internal();
  factory ChatService() => _instance;
  ChatService._internal();

  final ApiClient _api = ApiClient();

  Future<List<ChatRoom>> getChatRooms() async {
    final res = await _api.get('/chat/rooms');
    final list = (res['data'] as List?) ?? const [];
    return list
        .map((e) => ChatRoom.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  /// Ambil room yang sudah ada, atau buat baru. Dipanggil oleh CUSTOMER:
  /// backend memakai user yang login sebagai customer, [penyediaId] sebagai lawan bicara.
  Future<ChatRoom> getOrCreateChatRoom(String penyediaId) async {
    final res = await _api.post('/chat/rooms', body: {'penyediaId': penyediaId});
    return ChatRoom.fromMap(res['data'] as Map<String, dynamic>);
  }

  /// Cari room existing antara penyedia ini dan seorang customer (null jika belum ada).
  Future<ChatRoom?> findRoomWithCustomer(String customerId) async {
    final rooms = await getChatRooms();
    for (final room in rooms) {
      if (room.customerId == customerId) return room;
    }
    return null;
  }

  Future<List<ChatMessage>> getMessages(String chatRoomId) async {
    final res = await _api.get('/chat/rooms/$chatRoomId/messages');
    final list = (res['data'] as List?) ?? const [];
    return list
        .map((e) => ChatMessage.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<ChatMessage> sendMessage(
    String chatRoomId, {
    required String receiverId,
    required String message,
  }) async {
    final res = await _api.post('/chat/rooms/$chatRoomId/messages', body: {
      'receiverId': receiverId,
      'message': message,
    });
    return ChatMessage.fromMap(res['data'] as Map<String, dynamic>);
  }
}
