import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pet_data.dart';
import '../models/exercise_data.dart';
import '../models/challenge_data.dart';
import '../models/shop_item.dart';
import '../models/friend_data.dart';

class ApiService {
  static const String baseUrl = 'YOUR_API_BASE_URL';
  static const String apiKey = 'YOUR_API_KEY';

  // 펫 관련 API
  Future<PetData> getPetData() async {
    final response = await http.get(
      Uri.parse('$baseUrl/pet'),
      headers: {'Authorization': 'Bearer $apiKey'},
    );

    if (response.statusCode == 200) {
      return PetData.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load pet data');
    }
  }

  Future<void> updatePetData(PetData petData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/pet'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: json.encode(petData.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update pet data');
    }
  }

  // 운동 관련 API
  Future<List<ExerciseData>> getExerciseHistory() async {
    final response = await http.get(
      Uri.parse('$baseUrl/exercises'),
      headers: {'Authorization': 'Bearer $apiKey'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => ExerciseData.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load exercise history');
    }
  }

  Future<void> saveExercise(ExerciseData exercise) async {
    final response = await http.post(
      Uri.parse('$baseUrl/exercises'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: json.encode(exercise.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to save exercise');
    }
  }

  // 도전과제 관련 API
  Future<List<ChallengeData>> getChallenges() async {
    final response = await http.get(
      Uri.parse('$baseUrl/challenges'),
      headers: {'Authorization': 'Bearer $apiKey'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => ChallengeData.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load challenges');
    }
  }

  Future<void> updateChallengeProgress(String challengeId, int progress) async {
    final response = await http.put(
      Uri.parse('$baseUrl/challenges/$challengeId/progress'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: json.encode({'progress': progress}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update challenge progress');
    }
  }

  // 상점 관련 API
  Future<List<ShopItem>> getShopItems() async {
    final response = await http.get(
      Uri.parse('$baseUrl/shop/items'),
      headers: {'Authorization': 'Bearer $apiKey'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => ShopItem.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load shop items');
    }
  }

  Future<void> purchaseItem(String itemId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/shop/purchase'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: json.encode({'itemId': itemId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to purchase item');
    }
  }

  // 소셜 관련 API
  Future<List<FriendData>> getFriends() async {
    final response = await http.get(
      Uri.parse('$baseUrl/friends'),
      headers: {'Authorization': 'Bearer $apiKey'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => FriendData.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load friends');
    }
  }

  Future<void> sendFriendRequest(String userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/friends/request'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: json.encode({'userId': userId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send friend request');
    }
  }

  Future<void> acceptFriendRequest(String requestId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/friends/accept'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: json.encode({'requestId': requestId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to accept friend request');
    }
  }

  Future<void> deleteFriend(String friendId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/friends/$friendId'),
      headers: {'Authorization': 'Bearer $apiKey'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete friend');
    }
  }
} 