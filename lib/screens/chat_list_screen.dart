import 'package:flutter/material.dart';
import '../models/chat_model.dart';
import '../services/api_client.dart';
import '../services/auth_service.dart';
import '../services/chat_service.dart';
import '../utils/colors.dart';
import '../utils/helpers.dart';
import 'chat_detail_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  List<ChatRoom> _rooms = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadRooms();
  }

  Future<void> _loadRooms() async {
    setState(() {
      _isLoading = _rooms.isEmpty;
      _error = null;
    });
    try {
      final rooms = await ChatService().getChatRooms();
      if (!mounted) return;
      setState(() {
        _rooms = rooms;
        _isLoading = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.message;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final myId = AuthService().currentUser?.id;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesan', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.biruNavy,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_error!, textAlign: TextAlign.center),
                      const SizedBox(height: 8),
                      TextButton(onPressed: _loadRooms, child: const Text('Coba lagi')),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadRooms,
                  child: _rooms.isEmpty
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            const SizedBox(height: 120),
                            Column(
                              children: const [
                                Icon(Icons.chat_bubble_outline, size: 80, color: AppColors.abuMuda),
                                SizedBox(height: 16),
                                Text('Belum ada pesan', style: TextStyle(color: AppColors.abuText, fontSize: 16)),
                              ],
                            ),
                          ],
                        )
                      : ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: _rooms.length,
                          separatorBuilder: (context, index) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final room = _rooms[index];
                            final iAmCustomer = room.customerId == myId;
                            final otherName = iAmCustomer ? room.penyediaName : room.customerName;
                            final otherId = iAmCustomer ? room.penyediaId : room.customerId;
                            return ListTile(
                              leading: const CircleAvatar(
                                backgroundColor: AppColors.kuningLogo,
                                child: Icon(Icons.person, color: Colors.white),
                              ),
                              title: Text(otherName, style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                room.lastMessage ?? 'Belum ada pesan',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: room.lastMessageTime == null
                                  ? null
                                  : Text(
                                      formatWaktuChat(room.lastMessageTime!),
                                      style: const TextStyle(fontSize: 12, color: AppColors.abuText),
                                    ),
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ChatDetailScreen(
                                      chatRoomId: room.id,
                                      otherUserName: otherName,
                                      receiverId: otherId,
                                    ),
                                  ),
                                );
                                if (mounted) _loadRooms();
                              },
                            );
                          },
                        ),
                ),
    );
  }
}
