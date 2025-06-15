import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/pet_data.dart';
import '../services/api_service.dart';

class PetProvider with ChangeNotifier {
  final ApiService _apiService;
  PetData? _petData;
  bool _isLoading = false;
  String? _error;

  PetProvider(this._apiService);

  PetData? get petData => _petData;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> createPet(String nickname, String type) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.post('/pet', {
        'nickname': nickname,
        'type': type,
        'level': 1,
        'exp': 0,
        'fullness': 100,
        'happiness': 100,
        'health_status': 'NORMAL',
        'stage_id': 1,
        'status_message_id': 1,
      });

      _petData = PetData.fromJson(response);
      _error = null;

      // 펫 데이터를 SharedPreferences에 저장
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('petData', jsonEncode(_petData!.toJson()));
    } catch (e) {
      _error = e.toString();
      _petData = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadPet() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.getPet();
      _petData = PetData.fromJson(response);
      _error = null;

      // 펫 데이터를 SharedPreferences에 저장
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('petData', jsonEncode(_petData!.toJson()));
    } catch (e) {
      _error = e.toString();
      _petData = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updatePet(Map<String, dynamic> petData) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _apiService.updatePet(petData);
      await loadPet();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadPetData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final petDataString = prefs.getString('petData');
      
      if (petDataString != null) {
        _petData = PetData.fromJson(jsonDecode(petDataString));
      } else {
        await loadPet();
      }
    } catch (e) {
      _error = e.toString();
      _petData = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updatePetStatus({
    int? fullness,
    int? happiness,
    String? healthStatus,
  }) async {
    if (_petData == null) return;

    final Map<String, dynamic> updateData = {};
    if (fullness != null) updateData['fullness'] = fullness;
    if (happiness != null) updateData['happiness'] = happiness;
    if (healthStatus != null) updateData['health_status'] = healthStatus;

    await updatePet(updateData);
  }
} 