import 'package:flutter/material.dart';
import '../models/notification_data.dart';
import 'api_service.dart';

class NotificationService {
  final ApiService _apiService;

  NotificationService(this._apiService);

  // 알림 목록 가져오기
  Future<List<NotificationData>> getNotifications() async {
    try {
      final response = await _apiService.get('/notifications');
      final List<dynamic> notificationsJson = response['notifications'];
      return notificationsJson
          .map((json) => NotificationData.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('알림을 불러오는데 실패했습니다: $e');
    }
  }

  // 알림 읽음 처리
  Future<void> markAsRead(int notificationId) async {
    try {
      await _apiService.put('/notifications/$notificationId/read', {});
    } catch (e) {
      throw Exception('알림 읽음 처리에 실패했습니다: $e');
    }
  }

  // 모든 알림 읽음 처리
  Future<void> markAllAsRead() async {
    try {
      await _apiService.put('/notifications/read-all', {});
    } catch (e) {
      throw Exception('모든 알림 읽음 처리에 실패했습니다: $e');
    }
  }

  // 알림 삭제
  Future<void> deleteNotification(int notificationId) async {
    try {
      await _apiService.delete('/notifications/$notificationId');
    } catch (e) {
      throw Exception('알림 삭제에 실패했습니다: $e');
    }
  }

  // 모든 알림 삭제
  Future<void> deleteAllNotifications() async {
    try {
      await _apiService.delete('/notifications');
    } catch (e) {
      throw Exception('모든 알림 삭제에 실패했습니다: $e');
    }
  }
} 