import 'package:flutter/foundation.dart';
import '../models/friend_data.dart';
import '../services/api_service.dart';

class SocialProvider with ChangeNotifier {
  final ApiService _apiService;
  List<FriendData> _friends = [];
  List<String> _pendingRequests = [];
  bool _isLoading = false;
  String? _error;

  SocialProvider(this._apiService);

  List<FriendData> get friends => _friends;
  List<String> get pendingRequests => _pendingRequests;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadFriends() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _friends = await _apiService.getFriends();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> sendFriendRequest(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _apiService.sendFriendRequest(userId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> acceptFriendRequest(String requestId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _apiService.acceptFriendRequest(requestId);
      _pendingRequests.remove(requestId);
      await loadFriends(); // 친구 목록 새로고침
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteFriend(String friendId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _apiService.deleteFriend(friendId);
      _friends.removeWhere((friend) => friend.id == friendId);
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