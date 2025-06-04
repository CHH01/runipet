import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/pet_data.dart';

class PetProvider with ChangeNotifier {
  PetData? _petData;
  bool _isLoading = false;
  String? _error;

  PetData? get petData => _petData;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> createPet(String name, String type) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: API 호출로 변경
      await Future.delayed(const Duration(seconds: 1));
      _petData = PetData(
        id: '1',  // 임시 ID
        name: name,
        type: type,
        imagePath: 'assets/images/pet/$type/stage_1_egg/normal.png',
        level: 1,
        exp: 0,
        maxExp: 5000,
        happiness: 100,
        satiety: 100,
        health: 100,
      );
      _error = null;

      // 펫 데이터를 SharedPreferences에 저장
      final prefs = await SharedPreferences.getInstance();
      final petDataJson = jsonEncode({
        'id': _petData!.id,
        'name': _petData!.name,
        'type': _petData!.type,
        'imagePath': _petData!.imagePath,
        'level': _petData!.level,
        'exp': _petData!.exp,
        'maxExp': _petData!.maxExp,
        'happiness': _petData!.happiness,
        'satiety': _petData!.satiety,
        'health': _petData!.health,
      });
      await prefs.setString('petData', petDataJson);
    } catch (e) {
      _error = e.toString();
      _petData = null;
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
      final petDataJson = prefs.getString('petData');
      
      if (petDataJson != null) {
        final Map<String, dynamic> petDataMap = jsonDecode(petDataJson);
        _petData = PetData(
          id: petDataMap['id'],
          name: petDataMap['name'],
          type: petDataMap['type'],
          imagePath: petDataMap['imagePath'],
          level: petDataMap['level'],
          exp: petDataMap['exp'],
          maxExp: petDataMap['maxExp'],
          happiness: petDataMap['happiness'],
          satiety: petDataMap['satiety'],
          health: petDataMap['health'],
        );
        _error = null;
      } else {
        _error = '펫 데이터가 없습니다.';
      }
    } catch (e) {
      _error = e.toString();
      _petData = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 아이템 사용 시 상태 업데이트
  Future<void> updatePetStatus({
    int? satiety,
    int? happiness,
    int? health,
    int? exp,
  }) async {
    if (_petData == null) return;

    try {
      // TODO: API 호출로 변경
      await Future.delayed(const Duration(milliseconds: 500));
      
      _petData = _petData!.copyWith(
        satiety: satiety != null ? (_petData!.satiety + satiety).clamp(0, 100) : _petData!.satiety,
        happiness: happiness != null ? (_petData!.happiness + happiness).clamp(0, 100) : _petData!.happiness,
        health: health != null ? (_petData!.health + health).clamp(0, 100) : _petData!.health,
        exp: exp != null ? _petData!.exp + exp : _petData!.exp,
      );
      
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }
} 