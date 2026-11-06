import 'package:flutter/material.dart';
import '../utils/colors.dart';
import 'chat_detail_screen.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dummy data
    final chats = [
      {'id': '1', 'name': 'Budi Santoso', 'lastMsg': 'Baik, saya segera kesana.', 'time': '10:30', 'unread': 2},
      {'id': '2', 'name': 'Siti Aminah', 'lastMsg': 'Terima kasih banyak ya!', 'time': 'Kemarin', 'unread': 0},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesan', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.biruNavy,
      ),
      body: chats.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.chat_bubble_outline, size: 80, color: AppColors.abuMuda),
                  const SizedBox(height: 16),
                  const Text('Belum ada pesan', style: TextStyle(color: AppColors.abuText, fontSize: 16)),
                ],
              ),
            )
          : ListView.separated(
              itemCount: chats.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final chat = chats[index];
                final unread = chat['unread'] as int;
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: AppColors.kuningLogo,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text(chat['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(chat['lastMsg'] as String, maxLines: 1, overflow: TextOverflow.ellipsis),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(chat['time'] as String, style: const TextStyle(fontSize: 12, color: AppColors.abuText)),
                      if (unread > 0)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(color: AppColors.merahError, shape: BoxShape.circle),
                          child: Text(unread.toString(), style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => ChatDetailScreen(chatRoomId: chat['id'] as String, otherUserName: chat['name'] as String)));
                  },
                );
              },
            ),
    );
  }
}
