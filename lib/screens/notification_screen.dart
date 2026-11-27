import 'package:flutter/material.dart';
import '../models/notification_model.dart';
import '../services/api_client.dart';
import '../services/notification_service.dart';
import '../utils/colors.dart';
import '../utils/helpers.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationModel> _notifications = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = _notifications.isEmpty;
      _error = null;
    });
    try {
      final page = await NotificationService().getNotifications();
      if (!mounted) return;
      setState(() {
        _notifications = page.items;
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

  Future<void> _markAsRead(NotificationModel notif) async {
    if (notif.isRead) return;
    try {
      await NotificationService().markAsRead(notif.id);
      if (!mounted) return;
      setState(() {
        _notifications = _notifications
            .map((n) => n.id == notif.id
                ? NotificationModel(
                    id: n.id,
                    userId: n.userId,
                    title: n.title,
                    message: n.message,
                    type: n.type,
                    referenceId: n.referenceId,
                    isRead: true,
                    createdAt: n.createdAt,
                  )
                : n)
            .toList();
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  IconData _iconFor(String type) {
    switch (type) {
      case 'booking':
        return Icons.check_circle;
      case 'chat':
        return Icons.chat;
      case 'review':
        return Icons.star;
      default:
        return Icons.notifications;
    }
  }

  Color _colorFor(String type) {
    switch (type) {
      case 'booking':
        return AppColors.hijauSukses;
      case 'review':
        return Colors.amber;
      default:
        return AppColors.biruMuda;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.biruNavy,
        iconTheme: const IconThemeData(color: Colors.white),
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
                      TextButton(onPressed: _load, child: const Text('Coba lagi')),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _load,
                  child: _notifications.isEmpty
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            const SizedBox(height: 120),
                            Column(
                              children: const [
                                Icon(Icons.notifications_none, size: 80, color: AppColors.abuMuda),
                                SizedBox(height: 16),
                                Text('Belum ada notifikasi', style: TextStyle(color: AppColors.abuText, fontSize: 16)),
                              ],
                            ),
                          ],
                        )
                      : ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: _notifications.length,
                          itemBuilder: (context, index) {
                            final notif = _notifications[index];
                            final unread = !notif.isRead;
                            return Container(
                              color: unread ? AppColors.kuningMuda.withValues(alpha: 0.3) : Colors.transparent,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: _colorFor(notif.type),
                                  child: Icon(_iconFor(notif.type), color: Colors.white),
                                ),
                                title: Text(
                                  notif.title,
                                  style: TextStyle(fontWeight: unread ? FontWeight.bold : FontWeight.normal),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(notif.message),
                                    const SizedBox(height: 4),
                                    Text(
                                      formatWaktuRelatif(notif.createdAt),
                                      style: const TextStyle(fontSize: 12, color: AppColors.abuText),
                                    ),
                                  ],
                                ),
                                onTap: () => _markAsRead(notif),
                              ),
                            );
                          },
                        ),
                ),
    );
  }
}
