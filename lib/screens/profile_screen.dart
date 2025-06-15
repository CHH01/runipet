import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'exercise_history_screen.dart';
import 'package:provider/provider.dart';
import '../providers/notification_provider.dart';
import '../models/notification_data.dart';
import '../services/user_service.dart';
import '../models/user_data.dart';
import 'notification_list_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserData _userData;
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _nicknameController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _userData = UserData(
      userId: '',
      nickname: '러너',
      coin: 1000,
      inventory: {},
    );
    _nicknameController.text = _userData.nickname;
    _loadUserProfile();
    Future.microtask(() {
      context.read<NotificationProvider>().loadNotifications();
    });
  }

  Future<void> _loadUserProfile() async {
    setState(() => _isLoading = true);
    try {
      final userService = UserService();
      final userData = await userService.getUserProfile();
      setState(() {
        _userData = userData;
        _nicknameController.text = userData.nickname;
        if (userData.profileImage != null) {
          _profileImage = File(userData.profileImage!);
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('프로필 정보를 불러오는데 실패했습니다.')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _profileImage = File(image.path);
        });
        await _updateProfileImage(image.path);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이미지를 선택하는데 실패했습니다.')),
      );
    }
  }

  Future<void> _updateProfileImage(String imagePath) async {
    try {
      final userService = UserService();
      await userService.updateProfileImage(imagePath);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('프로필 이미지가 변경되었습니다.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('프로필 이미지 변경에 실패했습니다.')),
      );
    }
  }

  Future<void> _saveNickname() async {
    final newNickname = _nicknameController.text.trim();
    if (newNickname.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('닉네임을 입력해주세요.')),
      );
      return;
    }

    try {
      final userService = UserService();
      await userService.updateNickname(newNickname);
      setState(() {
        _userData = _userData.copyWith(nickname: newNickname);
      });
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('닉네임이 변경되었습니다.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('닉네임 변경에 실패했습니다.')),
      );
    }
  }

  void _showNicknameDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('닉네임 변경'),
        content: TextField(
          controller: _nicknameController,
          decoration: InputDecoration(
            hintText: '새 닉네임 입력',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('취소'),
          ),
          TextButton(
            onPressed: _saveNickname,
            child: Text('저장'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xFFD9F7B3),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Consumer<NotificationProvider>(
                      builder: (context, notificationProvider, child) {
                        return Stack(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.notifications),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NotificationListScreen(
                                      notificationService: notificationProvider.notificationService,
                                    ),
                                  ),
                                );
                              },
                            ),
                            if (notificationProvider.unreadCount > 0)
                              Positioned(
                                right: 8,
                                top: 8,
                                child: Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '${notificationProvider.unreadCount}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.mail_outline, size: 30),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : AssetImage('assets/images/user_profile.png') as ImageProvider,
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                        onPressed: _pickImage,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: _pickImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: StadiumBorder(),
                ),
                child: Text('프로필 이미지 변경'),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text('닉네임', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              GestureDetector(
                onTap: _showNicknameDialog,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12),
                  margin: EdgeInsets.only(top: 6),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(_userData.nickname, style: TextStyle(fontSize: 18)),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text('펫 정보', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 6),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Image.asset('assets/images/pet_happy.png', width: 60),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('루니 펫: 누룽이 Lv. ${_userData.petLevel}', style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('누적 걸음 수: ${_userData.totalSteps}'),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text('최근 기록', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Spacer(),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ExerciseHistoryScreen()),
                      );
                    },
                    icon: Icon(Icons.history, color: Colors.orange),
                    label: Text(
                      '전체 기록 보기',
                      style: TextStyle(color: Colors.orange),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 6),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text('거리', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('${_userData.recentDistance}KM', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Column(
                      children: [
                        Text('시간', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('${_userData.recentTime}분', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Column(
                      children: [
                        Text('칼로리', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('${_userData.recentKcal}Kcal', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showNotifications(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Consumer<NotificationProvider>(
        builder: (context, notificationProvider, child) {
          if (notificationProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (notificationProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(notificationProvider.error!),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => notificationProvider.loadNotifications(),
                    child: Text('다시 시도'),
                  ),
                ],
              ),
            );
          }

          if (notificationProvider.notifications.isEmpty) {
            return Center(
              child: Text('알림이 없습니다.'),
            );
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '알림',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () => notificationProvider.markAllAsRead(),
                          child: Text('모두 읽음'),
                        ),
                        TextButton(
                          onPressed: () => notificationProvider.deleteAllNotifications(),
                          child: Text('모두 삭제'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: notificationProvider.notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notificationProvider.notifications[index];
                    return _buildNotificationItem(notification);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNotificationItem(NotificationData notification) {
    Color iconColor;
    IconData iconData;

    switch (notification.type) {
      case NotificationType.hunger:
        iconColor = Colors.orange;
        iconData = Icons.restaurant;
        break;
      case NotificationType.growth:
        iconColor = Colors.blue;
        iconData = Icons.trending_up;
        break;
      case NotificationType.motivation:
        iconColor = Colors.green;
        iconData = Icons.directions_run;
        break;
      case NotificationType.friend:
        iconColor = Colors.purple;
        iconData = Icons.person_add;
        break;
      case NotificationType.leaderboard:
        iconColor = Colors.red;
        iconData = Icons.leaderboard;
        break;
    }

    return Dismissible(
      key: Key(notification.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        context.read<NotificationProvider>().deleteNotification(notification.id);
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: iconColor.withOpacity(0.2),
          child: Icon(iconData, color: iconColor),
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Text(notification.message),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _getTimeAgo(notification.createdAt),
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
            if (!notification.isRead)
              Container(
                margin: EdgeInsets.only(top: 4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
        onTap: () {
          if (!notification.isRead) {
            context.read<NotificationProvider>().markAsRead(notification.id);
          }
          // 알림 상세 내용 처리
        },
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}일 전';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}시간 전';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}분 전';
    } else {
      return '방금 전';
    }
  }
}