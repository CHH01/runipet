import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => SettingScreenState();
}

class SettingScreenState extends State<SettingScreen> {
  bool hungerNoti = true;
  bool growthNoti = true;
  bool motivationNoti = true;
  bool friendNoti = true;
  bool leaderboardNoti = true;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initNotifications();
  }

  Future<void> _initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // 동물 배고픔 알림
  Future<void> scheduleHungerNotification() async {
    await flutterLocalNotificationsPlugin.show(
      0,
      '배고픈 동물!',
      '포만감이 50% 미만입니다. 밥을 주세요!',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'hunger_channel',
          '동물 배고픔',
          channelDescription: '동물의 포만감 상태 알림',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }

  Future<void> cancelHungerNotification() async {
    await flutterLocalNotificationsPlugin.cancel(0);
  }

  // 동물 성장 알림
  Future<void> showGrowthNotification() async {
    await flutterLocalNotificationsPlugin.show(
      1,
      '동물 성장!',
      '동물이 레벨업 했어요!',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'growth_channel',
          '동물 성장',
          channelDescription: '동물의 성장 알림',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }

  // 운동 동기부여 알림
  Future<void> scheduleMotivationNotification() async {
    await flutterLocalNotificationsPlugin.show(
      2,
      '운동 동기부여!',
      '오랜만에 운동해볼까요?',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'motivation_channel',
          '운동 동기부여',
          channelDescription: '운동 동기부여 알림',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }

  Future<void> cancelMotivationNotification() async {
    await flutterLocalNotificationsPlugin.cancel(2);
  }

  // 실제 데이터 연동용 함수들 ----------------------------

  // 포만감 변화 시 호출 (satiety: 0~100)
  void checkAndScheduleHungerNotification(int satiety) {
    if (hungerNoti) {
      if (satiety < 50) {
        scheduleHungerNotification();
      } else {
        cancelHungerNotification();
      }
    } else {
      cancelHungerNotification();
    }
  }

  // 레벨업 시 호출
  void onPetLevelUp() {
    if (growthNoti) {
      showGrowthNotification();
    }
  }

  // 앱 진입/종료 시 호출
  Future<void> updateLastActiveTime() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('lastActive', DateTime.now().millisecondsSinceEpoch);
  }

  // 앱 진입 시 호출
  Future<void> checkAndScheduleMotivationNotification() async {
    if (!motivationNoti) {
      cancelMotivationNotification();
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    int? lastActive = prefs.getInt('lastActive');
    if (lastActive == null) {
      updateLastActiveTime();
      return;
    }
    final last = DateTime.fromMillisecondsSinceEpoch(lastActive);
    final diff = DateTime.now().difference(last);
    if (diff.inHours >= 12) {
      scheduleMotivationNotification();
    } else {
      cancelMotivationNotification();
    }
  }

  // ---------------------------------------------------

  void _onToggleHunger(bool value) {
    setState(() => hungerNoti = value);
    // 실제 포만감 값과 연동 필요
  }

  void _onToggleGrowth(bool value) {
    setState(() => growthNoti = value);
    // 실제 레벨업 시 onPetLevelUp() 호출 필요
  }

  void _onToggleMotivation(bool value) {
    setState(() => motivationNoti = value);
    // 실제 앱 진입/종료 시 checkAndScheduleMotivationNotification(), updateLastActiveTime() 호출 필요
  }

  void _onToggleFriend(bool value) {
    setState(() => friendNoti = value);
  }

  void _onToggleLeaderboard(bool value) {
    setState(() => leaderboardNoti = value);
  }

  void _showConfirmDialog(String title, String content, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child: const Text('확인', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _logout() {
    _showConfirmDialog(
      '로그아웃',
      '정말 로그아웃 하시겠습니까?',
      () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('로그아웃하였습니다.')),
        );
        // 실제 로그아웃 기능은 여기에 구현
      },
    );
  }

  void _deleteAccount() {
    _showConfirmDialog(
      '계정 삭제',
      '정말 계정을 삭제하시겠습니까?',
      () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('계정을 삭제하였습니다.')),
        );
        // 실제 계정 삭제 기능은 여기에 구현
      },
    );
  }

  Widget _settingTile(String title, {Widget? trailing}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF1DD),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBE2B6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('설정', style: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold, fontSize: 38)),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        child: Column(
          children: [
            _settingTile(
              '동물 배고픔',
              trailing: Switch(
                value: hungerNoti,
                onChanged: _onToggleHunger,
                activeColor: Colors.green,
              ),
            ),
            _settingTile(
              '동물 성장',
              trailing: Switch(
                value: growthNoti,
                onChanged: _onToggleGrowth,
                activeColor: Colors.green,
              ),
            ),
            _settingTile(
              '운동 동기부여',
              trailing: Switch(
                value: motivationNoti,
                onChanged: _onToggleMotivation,
                activeColor: Colors.green,
              ),
            ),
            _settingTile(
              '친구 추가요청',
              trailing: Switch(
                value: friendNoti,
                onChanged: _onToggleFriend,
                activeColor: Colors.green,
              ),
            ),
            _settingTile(
              '리더보드 순위',
              trailing: Switch(
                value: leaderboardNoti,
                onChanged: _onToggleLeaderboard,
                activeColor: Colors.green,
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _logout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                ),
                child: const Text('로그아웃', style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _deleteAccount,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                ),
                child: const Text('계정 삭제', style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
