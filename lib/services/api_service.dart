import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pet_data.dart';
import '../models/exercise_record.dart';
import '../models/challenge_data.dart';
import '../models/shop_item.dart';
import '../models/friend_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/notification_data.dart';

class ApiService {
  final String _baseUrl;
  final FlutterSecureStorage _secureStorage;
  final http.Client _client;
  static const String _tokenKey = 'auth_token';

  ApiService({
    required String baseUrl,
    required FlutterSecureStorage secureStorage,
  })  : _baseUrl = baseUrl,
        _secureStorage = secureStorage,
        _client = http.Client();

  Future<String?> _getToken() async {
    return await _secureStorage.read(key: 'token');
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<dynamic> get(String endpoint) async {
    try {
      final token = await getToken();
      if (token == null) {
        print('API 요청 실패: 토큰이 없습니다.');
        return null;
      }

      final response = await http.get(
        Uri.parse('$_baseUrl$endpoint'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('API 응답 [$endpoint]: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data == null) {
          print('API 응답이 null입니다: $endpoint');
          return null;
        }
        return data;
      } else if (response.statusCode == 404) {
        print('API 엔드포인트를 찾을 수 없습니다: $endpoint');
        return null;
      } else if (response.statusCode == 422) {
        print('API 유효성 검사 실패: $endpoint');
        return null;
      } else {
        print('API 요청 실패: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('API 요청 중 에러 발생: $e');
      return null;
    }
  }

  Future<dynamic> post(String endpoint, dynamic data) async {
    final headers = await _getHeaders();
    final response = await _client.post(
      Uri.parse('$_baseUrl$endpoint'),
      headers: headers,
      body: json.encode(data),
    );
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else if (response.statusCode == 409) {
      final errorData = json.decode(response.body);
      return errorData;
    } else {
      throw Exception('Failed to post data: ${response.statusCode}');
    }
  }

  Future<dynamic> put(String endpoint, dynamic data) async {
    final headers = await _getHeaders();
    final response = await _client.put(
      Uri.parse('$_baseUrl$endpoint'),
      headers: headers,
      body: json.encode(data),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update data: ${response.statusCode}');
    }
  }

  Future<void> delete(String endpoint) async {
    final headers = await _getHeaders();
    final response = await _client.delete(
      Uri.parse('$_baseUrl$endpoint'),
      headers: headers,
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete data: ${response.statusCode}');
    }
  }

  Future<void> setToken(String token) async {
    await _secureStorage.write(key: 'token', value: token);
  }

  Future<void> clearToken() async {
    await _secureStorage.delete(key: 'token');
  }

  Future<String?> getToken() async {
    return await _getToken();
  }

  Future<void> logout() async {
    await clearToken();
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      await setToken(data['access_token']);
      return data;
    } else {
      final errorData = json.decode(response.body);
      throw Exception(errorData['error'] ?? '로그인에 실패했습니다.');
    }
  }

  Future<Map<String, dynamic>> register(String username, String email, String password, String nickname) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'email': email,
        'password': password,
        'nickname': nickname,
      }),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      final errorData = json.decode(response.body);
      throw Exception(errorData['error'] ?? '회원가입에 실패했습니다.');
    }
  }

  Future<Map<String, dynamic>> getProfile() async {
    final token = await getToken();
    if (token == null) throw Exception('토큰이 없습니다.');

    final response = await http.get(
      Uri.parse('$_baseUrl/users/profile'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('프로필 정보를 불러오는데 실패했습니다.');
    }
  }

  Future<Map<String, dynamic>> updateUserProfile(Map<String, dynamic> profile) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('인증되지 않았습니다.');
    }

    final response = await http.put(
      Uri.parse('$_baseUrl/profile'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(profile),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('프로필을 업데이트하는데 실패했습니다.');
    }
  }

  /// 펫 정보를 가져옵니다.
  Future<Map<String, dynamic>> getPet() async {
    try {
      final response = await get('/pet');
      if (response == null) {
        print('펫 정보를 가져오는데 실패했습니다.');
        return {
          'nickname': '새로운 펫',
          'type': 'dog',
          'level': 1,
          'exp': 0,
          'fullness': 100,
          'happiness': 100,
          'health_status': 'NORMAL',
          'stage_id': 1,
          'status_message_id': 1,
        };
      }
      return response;
    } catch (e) {
      print('펫 정보를 가져오는 중 에러 발생: $e');
      return {
        'nickname': '새로운 펫',
        'type': 'dog',
        'level': 1,
        'exp': 0,
        'fullness': 100,
        'happiness': 100,
        'health_status': 'NORMAL',
        'stage_id': 1,
        'status_message_id': 1,
      };
    }
  }

  /// 펫 정보를 업데이트합니다.
  Future<void> updatePet(Map<String, dynamic> data) async {
    try {
      await put('/pet', data);
    } catch (e) {
      print('펫 정보 업데이트 실패: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getExerciseHistory() async {
    try {
      final response = await get('/exercises');
      if (response == null) {
        print('운동 기록을 가져오는데 실패했습니다.');
        return [];
      }
      
      if (response is Map<String, dynamic> && response.containsKey('records')) {
        final List<dynamic> records = response['records'];
        return records.map((record) => Map<String, dynamic>.from(record)).toList();
      } else if (response is List) {
        return response.map((record) => Map<String, dynamic>.from(record)).toList();
      }
      
      print('운동 기록 형식이 올바르지 않습니다: $response');
      return [];
    } catch (e) {
      print('운동 기록을 가져오는 중 에러 발생: $e');
      return [];
    }
  }

  Future<void> saveExercise(Map<String, dynamic> exerciseData) async {
    try {
      await post('/exercise', exerciseData);
    } catch (e) {
      print('운동 저장 에러: $e');
      rethrow;
    }
  }

  Future<ExerciseRecord> recordExercise(ExerciseRecord exerciseRecord) async {
    try {
      final response = await post('/exercise', exerciseRecord.toJson());
      return ExerciseRecord.fromJson(response);
    } catch (e) {
      print('운동 기록 저장 에러: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getChallenges() async {
    try {
      final response = await get('/challenges');
      if (response == null) {
        print('도전과제를 가져오는데 실패했습니다.');
        return [];
      }
      
      if (response is Map<String, dynamic> && response.containsKey('challenges')) {
        final List<dynamic> challenges = response['challenges'];
        return challenges.map((challenge) => Map<String, dynamic>.from(challenge)).toList();
      } else if (response is List) {
        return response.map((challenge) => Map<String, dynamic>.from(challenge)).toList();
      }
      
      print('도전과제 형식이 올바르지 않습니다: $response');
      return [];
    } catch (e) {
      print('도전과제를 가져오는 중 에러 발생: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> updateChallengeProgress(String challengeId, int progress) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('인증되지 않았습니다.');
    }

    final response = await http.put(
      Uri.parse('$_baseUrl/challenges/$challengeId/progress'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'progress': progress}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('챌린지 진행 상황을 업데이트하는데 실패했습니다.');
    }
  }

  Future<List<Map<String, dynamic>>> getLeaderboard() async {
    final token = await getToken();
    if (token == null) {
      throw Exception('인증되지 않았습니다.');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/leaderboard'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> leaderboard = json.decode(response.body);
      return leaderboard.cast<Map<String, dynamic>>();
    } else {
      throw Exception('리더보드를 불러오는데 실패했습니다.');
    }
  }

  Future<Map<String, dynamic>> getMyRank() async {
    final token = await getToken();
    if (token == null) {
      throw Exception('인증되지 않았습니다.');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/leaderboard/rank'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('내 순위를 불러오는데 실패했습니다.');
    }
  }

  Future<List<Map<String, dynamic>>> getShopItems() async {
    final token = await getToken();
    if (token == null) {
      throw Exception('인증되지 않았습니다.');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/shop/items'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> items = json.decode(response.body);
      return items.cast<Map<String, dynamic>>();
    } else {
      throw Exception('상점 아이템을 불러오는데 실패했습니다.');
    }
  }

  Future<Map<String, dynamic>> purchaseItem(String itemId) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('인증되지 않았습니다.');
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/shop/purchase'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'itemId': itemId}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('아이템 구매에 실패했습니다.');
    }
  }

  /// 친구 목록을 가져옵니다.
  Future<List<Map<String, dynamic>>> getFriends() async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('토큰이 없습니다.');
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/friends'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['friends']);
      } else if (response.statusCode == 422) {
        // 친구 목록이 비어있는 경우
        return [];
      } else {
        throw Exception('친구 목록을 가져오는데 실패했습니다.');
      }
    } catch (e) {
      print('친구 목록 가져오기 실패: $e');
      rethrow;
    }
  }

  /// 대기 중인 친구 요청 목록을 가져옵니다.
  Future<List<Map<String, dynamic>>> getPendingRequests() async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('토큰이 없습니다.');
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/friends/requests'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['requests']);
      } else if (response.statusCode == 404) {
        // 친구 요청이 없는 경우
        return [];
      } else {
        throw Exception('친구 요청 목록을 가져오는데 실패했습니다.');
      }
    } catch (e) {
      print('친구 요청 목록 가져오기 실패: $e');
      rethrow;
    }
  }

  Future<void> sendFriendRequest(String friendId) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('인증되지 않았습니다.');
    }

    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/friends/requests'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({'friend_id': friendId}),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('친구 요청을 보내는데 실패했습니다.');
      }
    } catch (e) {
      print('친구 요청 전송 에러: $e');
      rethrow;
    }
  }

  Future<void> acceptFriendRequest(String friendId) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('인증되지 않았습니다.');
    }

    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/friends/requests/$friendId/accept'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({}),
      );

      if (response.statusCode != 200) {
        throw Exception('친구 요청을 수락하는데 실패했습니다.');
      }
    } catch (e) {
      print('친구 요청 수락 에러: $e');
      rethrow;
    }
  }

  Future<void> rejectFriendRequest(String friendId) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('인증되지 않았습니다.');
    }

    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/friends/requests/$friendId/reject'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({}),
      );

      if (response.statusCode != 200) {
        throw Exception('친구 요청을 거절하는데 실패했습니다.');
      }
    } catch (e) {
      print('친구 요청 거절 에러: $e');
      rethrow;
    }
  }

  Future<void> deleteFriend(String friendId) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('인증되지 않았습니다.');
    }

    try {
      final response = await _client.delete(
        Uri.parse('$_baseUrl/friends/$friendId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('친구를 삭제하는데 실패했습니다.');
      }
    } catch (e) {
      print('친구 삭제 에러: $e');
      rethrow;
    }
  }

  Future<void> deleteAccount() async {
    final token = await getToken();
    if (token == null) {
      throw Exception('인증되지 않았습니다.');
    }

    final response = await http.delete(
      Uri.parse('$_baseUrl/user/account'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('계정을 삭제하는데 실패했습니다.');
    }
  }

  Future<List<Map<String, dynamic>>> getInventoryItems() async {
    final token = await getToken();
    if (token == null) {
      throw Exception('인증되지 않았습니다.');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/inventory'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> items = json.decode(response.body);
      return items.cast<Map<String, dynamic>>();
    } else {
      throw Exception('인벤토리 아이템을 불러오는데 실패했습니다.');
    }
  }

  Future<Map<String, dynamic>> useItem(String itemId) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('인증되지 않았습니다.');
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/inventory/$itemId/use'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('아이템 사용에 실패했습니다.');
    }
  }

  Future<void> initialize() async {
    // 알림 초기화 로직
  }

  Future<List<Map<String, dynamic>>> getNotifications() async {
    try {
      final response = await get('/notice');
      final List<dynamic> data = response['notices'];
      return data.cast<Map<String, dynamic>>();
    } catch (e) {
      print('알림 로드 에러: $e');
      rethrow;
    }
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    final token = await getToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await http.put(
      Uri.parse('$_baseUrl/notifications/$notificationId/read'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to mark notification as read');
    }
  }

  Future<void> markAllNotificationsAsRead() async {
    final token = await getToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await http.put(
      Uri.parse('$_baseUrl/notifications/read-all'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to mark all notifications as read');
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    final token = await getToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await http.delete(
      Uri.parse('$_baseUrl/notifications/$notificationId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete notification');
    }
  }

  Future<void> deleteAllNotifications() async {
    final token = await getToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await http.delete(
      Uri.parse('$_baseUrl/notifications'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete all notifications');
    }
  }

  Future<void> showLocalNotification(NotificationData notification) async {
    // 로컬 알림 표시 로직
  }

  Future<Map<String, dynamic>> getUserSettings() async {
    final token = await getToken();
    if (token == null) throw Exception('토큰이 없습니다.');

    final response = await http.get(
      Uri.parse('$_baseUrl/users/settings'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('설정을 불러오는데 실패했습니다.');
    }
  }

  Future<void> updateUserSettings(Map<String, dynamic> settings) async {
    final token = await getToken();
    if (token == null) throw Exception('토큰이 없습니다.');

    final response = await http.put(
      Uri.parse('$_baseUrl/users/settings'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(settings),
    );

    if (response.statusCode != 200) {
      throw Exception('설정 업데이트에 실패했습니다.');
    }
  }

  Future<Map<String, dynamic>> updateGoalSteps(int goalSteps) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('인증되지 않았습니다.');
    }

    final response = await http.put(
      Uri.parse('$_baseUrl/user-settings'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'goal_steps': goalSteps}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('목표 걸음 수를 업데이트하는데 실패했습니다.');
    }
  }

  Future<Map<String, dynamic>> toggleHungerNotify(bool value) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('인증되지 않았습니다.');
    }

    final response = await http.put(
      Uri.parse('$_baseUrl/user-settings'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'hunger_notify': value}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('배고픔 알림 설정을 업데이트하는데 실패했습니다.');
    }
  }

  Future<Map<String, dynamic>> toggleGrowthNotify(bool value) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('인증되지 않았습니다.');
    }

    final response = await http.put(
      Uri.parse('$_baseUrl/user-settings'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'growth_notify': value}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('성장 알림 설정을 업데이트하는데 실패했습니다.');
    }
  }

  Future<Map<String, dynamic>> toggleMotivationNotify(bool value) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('인증되지 않았습니다.');
    }

    final response = await http.put(
      Uri.parse('$_baseUrl/user-settings'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'motivation_notify': value}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('동기부여 알림 설정을 업데이트하는데 실패했습니다.');
    }
  }

  Future<Map<String, dynamic>> toggleFriendNotify(bool value) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('인증되지 않았습니다.');
    }

    final response = await http.put(
      Uri.parse('$_baseUrl/user-settings'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'friend_notify': value}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('친구 알림 설정을 업데이트하는데 실패했습니다.');
    }
  }

  Future<Map<String, dynamic>> toggleLeaderboardNotify(bool value) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('인증되지 않았습니다.');
    }

    final response = await http.put(
      Uri.parse('$_baseUrl/user-settings'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'leaderboard_notify': value}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('리더보드 알림 설정을 업데이트하는데 실패했습니다.');
    }
  }

  Future<Map<String, dynamic>> getPetStatusMessage(int petId) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('인증되지 않았습니다.');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/pet-status-message/$petId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('펫 상태 메시지를 불러오는데 실패했습니다.');
    }
  }

  Future<List<Map<String, dynamic>>> searchUsers(String query) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('인증되지 않았습니다.');
    }

    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/users/search?query=$query'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> users = data['users'];
        return users.cast<Map<String, dynamic>>();
      } else {
        throw Exception('사용자 검색에 실패했습니다.');
      }
    } catch (e) {
      print('사용자 검색 에러: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getSettings() async {
    try {
      final response = await get('/user/settings');
      if (response == null) {
        print('설정을 가져오는데 실패했습니다.');
        return {
          'step_goal': 10000,
          'hunger_notify': true,
          'growth_notify': true,
          'motivation_notify': true,
          'friend_notify': true,
          'leaderboard_notify': true,
        };
      }
      return response;
    } catch (e) {
      print('설정을 가져오는 중 에러 발생: $e');
      return {
        'step_goal': 10000,
        'hunger_notify': true,
        'growth_notify': true,
        'motivation_notify': true,
        'friend_notify': true,
        'leaderboard_notify': true,
      };
    }
  }
} 