import 'package:flutter/foundation.dart';
import '../models/friend_data.dart';
import '../services/api_service.dart';

class SocialProvider with ChangeNotifier {
  final ApiService _apiService;
  List<FriendData> _friends = [];
  List<FriendData> _pendingRequests = [];
  bool _isLoading = false;
  String? _error;

  SocialProvider(this._apiService);

  List<FriendData> get friends => _friends;
  List<FriendData> get pendingRequests => _pendingRequests;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadFriends() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.getFriends();
      _friends = response.map((json) => FriendData.fromJson(json)).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadPendingRequests() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.getPendingRequests();
      _pendingRequests = response.map((json) => FriendData.fromJson(json)).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 친구 요청을 보냅니다.
  /// [friendId]는 대상 사용자의 ID입니다.
  Future<void> sendFriendRequest(String friendId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _apiService.sendFriendRequest(friendId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 친구 요청을 수락합니다.
  /// [friendId]는 요청을 보낸 사용자의 ID입니다.
  Future<void> acceptFriendRequest(String friendId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _apiService.acceptFriendRequest(friendId);
      _pendingRequests.removeWhere((friend) => friend.userId == friendId);
      await loadFriends(); // 친구 목록 새로고침
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 친구 요청을 거절합니다.
  /// [friendId]는 요청을 보낸 사용자의 ID입니다.
  Future<void> rejectFriendRequest(String friendId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _apiService.rejectFriendRequest(friendId);
      _pendingRequests.remove(friendId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 친구를 삭제합니다.
  /// [friendId]는 삭제할 친구의 ID입니다.
  Future<void> deleteFriend(String friendId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _apiService.deleteFriend(friendId);
      _friends.removeWhere((friend) => friend.userId == friendId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<FriendData> getOnlineFriends() {
    return _friends.where((friend) => friend.isOnline).toList();
  }

  List<FriendData> getFriendsByLevel(int minLevel) {
    return _friends.where((friend) => friend.level >= minLevel).toList();
  }
} 