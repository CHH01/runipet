import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationProvider with ChangeNotifier {
  bool _hungerNoti = true;
  bool _growthNoti = true;
  bool _motivationNoti = true;
  bool _friendNoti = true;
  bool _leaderboardNoti = true;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  bool get hungerNoti => _hungerNoti;
  bool get growthNoti => _growthNoti;
  bool get motivationNoti => _motivationNoti;
  bool get friendNoti => _friendNoti;
  bool get leaderboardNoti => _leaderboardNoti;

  NotificationProvider() {
    _initNotifications();
    _loadSettings();
  }

  Future<void> _initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _hungerNoti = prefs.getBool('hungerNoti') ?? true;
    _growthNoti = prefs.getBool('growthNoti') ?? true;
    _motivationNoti = prefs.getBool('motivationNoti') ?? true;
    _friendNoti = prefs.getBool('friendNoti') ?? true;
    _leaderboardNoti = prefs.getBool('leaderboardNoti') ?? true;
    notifyListeners();
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hungerNoti', _hungerNoti);
    await prefs.setBool('growthNoti', _growthNoti);
    await prefs.setBool('motivationNoti', _motivationNoti);
    await prefs.setBool('friendNoti', _friendNoti);
    await prefs.setBool('leaderboardNoti', _leaderboardNoti);
  }

  // 동물 배고픔 알림
  Future<void> scheduleHungerNotification() async {
    if (!_hungerNoti) return;
    
    await _flutterLocalNotificationsPlugin.show(
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
    await _flutterLocalNotificationsPlugin.cancel(0);
  }

  // 동물 성장 알림
  Future<void> showGrowthNotification() async {
    if (!_growthNoti) return;
    
    await _flutterLocalNotificationsPlugin.show(
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
    if (!_motivationNoti) return;
    
    await _flutterLocalNotificationsPlugin.show(
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
    await _flutterLocalNotificationsPlugin.cancel(2);
  }

  // 친구 추가요청 알림
  Future<void> showFriendRequestNotification(String friendName) async {
    if (!_friendNoti) return;
    
    await _flutterLocalNotificationsPlugin.show(
      3,
      '새로운 친구 요청',
      '$friendName님이 친구 요청을 보냈습니다.',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'friend_channel',
          '친구 요청',
          channelDescription: '친구 추가 요청 알림',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }

  // 리더보드 순위 알림
  Future<void> showLeaderboardNotification(String message, String type) async {
    if (!_leaderboardNoti) return;
    
    // 전체 랭킹과 친구 랭킹만 알림
    if (type != '전체' && type != '친구') return;
    
    String title;
    switch (type) {
      case '전체':
        title = '전체 랭킹 변동';
        break;
      case '친구':
        title = '친구 랭킹 변동';
        break;
      default:
        return;
    }
    
    await _flutterLocalNotificationsPlugin.show(
      4,
      title,
      message,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'leaderboard_channel',
          '랭킹 알림',
          channelDescription: '리더보드 순위 변동 알림',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }

  // 설정 토글 함수들
  void toggleHungerNoti(bool value) {
    _hungerNoti = value;
    _saveSettings();
    notifyListeners();
  }

  void toggleGrowthNoti(bool value) {
    _growthNoti = value;
    _saveSettings();
    notifyListeners();
  }

  void toggleMotivationNoti(bool value) {
    _motivationNoti = value;
    _saveSettings();
    notifyListeners();
  }

  void toggleFriendNoti(bool value) {
    _friendNoti = value;
    _saveSettings();
    notifyListeners();
  }

  void toggleLeaderboardNoti(bool value) {
    _leaderboardNoti = value;
    _saveSettings();
    notifyListeners();
  }

  // 실제 데이터 연동용 함수들
  void checkAndScheduleHungerNotification(int satiety) {
    if (_hungerNoti) {
      if (satiety < 50) {
        scheduleHungerNotification();
      } else {
        cancelHungerNotification();
      }
    } else {
      cancelHungerNotification();
    }
  }

  void onPetLevelUp() {
    if (_growthNoti) {
      showGrowthNotification();
    }
  }

  Future<void> updateLastActiveTime() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('lastActive', DateTime.now().millisecondsSinceEpoch);
  }

  Future<void> checkAndScheduleMotivationNotification() async {
    if (!_motivationNoti) {
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

  void onFriendRequestReceived(String friendName) {
    showFriendRequestNotification(friendName);
  }

  void onRankingChanged(String message, String type) {
    showLeaderboardNotification(message, type);
  }
} 