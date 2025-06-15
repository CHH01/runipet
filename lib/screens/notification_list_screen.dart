import 'package:flutter/material.dart';
import '../models/notification_data.dart';
import '../services/notification_service.dart';

class NotificationListScreen extends StatefulWidget {
  final NotificationService notificationService;

  const NotificationListScreen({
    Key? key,
    required this.notificationService,
  }) : super(key: key);

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  List<NotificationData> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    try {
      final notifications = await widget.notificationService.getNotifications();
      setState(() {
        _notifications = notifications;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('알림을 불러오는데 실패했습니다: $e')),
        );
      }
    }
  }

  Future<void> _markAllAsRead() async {
    try {
      await widget.notificationService.markAllAsRead();
      await _loadNotifications();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('모든 알림을 읽음 처리했습니다')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('알림 읽음 처리에 실패했습니다: $e')),
        );
      }
    }
  }

  Future<void> _deleteAllNotifications() async {
    try {
      await widget.notificationService.deleteAllNotifications();
      await _loadNotifications();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('모든 알림을 삭제했습니다')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('알림 삭제에 실패했습니다: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('알림'),
        actions: [
          if (_notifications.isNotEmpty) ...[
            IconButton(
              icon: const Icon(Icons.done_all),
              onPressed: _markAllAsRead,
              tooltip: '모두 읽음 처리',
            ),
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: _deleteAllNotifications,
              tooltip: '모두 삭제',
            ),
          ],
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
              ? const Center(
                  child: Text(
                    '알림이 없습니다',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  itemCount: _notifications.length,
                  itemBuilder: (context, index) {
                    final notification = _notifications[index];
                    return ListTile(
                      leading: const Icon(Icons.notifications),
                      title: Text(notification.title),
                      subtitle: Text(notification.message),
                      trailing: Text(
                        notification.createdAt.toString().substring(0, 10),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      onTap: () async {
                        try {
                          await widget.notificationService.markAsRead(notification.id);
                          await _loadNotifications();
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('알림 읽음 처리에 실패했습니다: $e')),
                            );
                          }
                        }
                      },
                    );
                  },
                ),
    );
  }
} 