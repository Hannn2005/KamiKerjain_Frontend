import 'package:flutter/material.dart';
import '../utils/colors.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dummy data
    final notifications = [
      {'title': 'Booking Dikonfirmasi', 'msg': 'Booking Anda untuk Jasa Kebersihan telah dikonfirmasi.', 'time': '1 jam yang lalu', 'unread': true, 'type': 'success'},
      {'title': 'Pesan Baru', 'msg': 'Anda memiliki pesan baru dari Budi Santoso.', 'time': '3 jam yang lalu', 'unread': false, 'type': 'chat'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.biruNavy,
      ),
      body: notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.notifications_none, size: 80, color: AppColors.abuMuda),
                  const SizedBox(height: 16),
                  const Text('Belum ada notifikasi', style: TextStyle(color: AppColors.abuText, fontSize: 16)),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {
                await Future.delayed(const Duration(seconds: 1));
              },
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notif = notifications[index];
                  final unread = notif['unread'] as bool;
                  return Container(
                    color: unread ? AppColors.kuningMuda?.withOpacity(0.3) : Colors.transparent,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: notif['type'] == 'success' ? AppColors.hijauSukses : AppColors.biruMuda,
                        child: Icon(notif['type'] == 'success' ? Icons.check_circle : Icons.chat, color: Colors.white),
                      ),
                      title: Text(notif['title'] as String, style: TextStyle(fontWeight: unread ? FontWeight.bold : FontWeight.normal)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(notif['msg'] as String),
                          const SizedBox(height: 4),
                          Text(notif['time'] as String, style: const TextStyle(fontSize: 12, color: AppColors.abuText)),
                        ],
                      ),
                      onTap: () {},
                    ),
                  );
                },
              ),
            ),
    );
  }
}
