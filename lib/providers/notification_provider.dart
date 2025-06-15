import 'package:flutter/foundation.dart';
import '../models/notification_data.dart';
import '../services/notification_service.dart';
import '../models/user_settings_data.dart';
import '../providers/user_settings_provider.dart';
import '../services/user_settings_service.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationService _notificationService;
  final UserSettingsService _settingsService;
  List<NotificationData> _notifications = [];
  bool _isLoading = false;
  String? _error;
  bool _hungerNotify = true;
  bool _growthNotify = true;
  bool _motivationNotify = true;
  bool _friendNotify = true;
  bool _leaderboardNotify = true;

  NotificationProvider(this._notificationService, this._settingsService) {
    loadNotifications();
    _loadNotificationSettings();
  }

  NotificationService get notificationService => _notificationService;
  List<NotificationData> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get unreadCount => _notifications.where((n) => !n.isRead).length;
  bool get hungerNotify => _hungerNotify;
  bool get growthNotify => _growthNotify;
  bool get motivationNotify => _motivationNotify;
  bool get friendNotify => _friendNotify;
  bool get leaderboardNotify => _leaderboardNotify;

  Future<void> _loadNotificationSettings() async {
    final settings = await _settingsService.getSettings();
    if (settings != null) {
      _hungerNotify = settings.hunger_notify;
      _growthNotify = settings.growth_notify;
      _motivationNotify = settings.motivation_notify;
      _friendNotify = settings.friend_notify;
      _leaderboardNotify = settings.leaderboard_notify;
      notifyListeners();
    }
  }

  Future<void> loadNotifications() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _notifications = await _notificationService.getNotifications();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> markAsRead(int notificationId) async {
    try {
      await _notificationService.markAsRead(notificationId);
      final index = _notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        _notifications[index] = _notifications[index].copyWith(isRead: true);
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await _notificationService.markAllAsRead();
      _notifications = _notifications.map((n) => n.copyWith(isRead: true)).toList();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteNotification(int notificationId) async {
    try {
      await _notificationService.deleteNotification(notificationId);
      _notifications.removeWhere((n) => n.id == notificationId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteAllNotifications() async {
    try {
      await _notificationService.deleteAllNotifications();
      _notifications.clear();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
} 