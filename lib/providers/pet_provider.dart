import 'package:flutter/foundation.dart';
import '../models/pet_data.dart';

class PetProvider with ChangeNotifier {
  PetData? _petData;
  bool _isLoading = false;
  String? _error;

  PetData? get petData => _petData;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadPetData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: API 호출로 변경
      await Future.delayed(const Duration(seconds: 1)); // 임시 딜레이
      _petData = PetData(
        id: '1',
        name: '멍멍이',
        type: 'dog',
        imagePath: 'assets/images/pets/dog.png',
        satiety: 80,
        happiness: 90,
        health: 100,
        level: 1,
        exp: 0,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> feedPet() async {
    if (_petData == null) return;

    try {
      // TODO: API 호출로 변경
      await Future.delayed(const Duration(milliseconds: 500)); // 임시 딜레이
      
      _petData = _petData!.copyWith(
        satiety: (_petData!.satiety + 20).clamp(0, 100),
        happiness: (_petData!.happiness + 10).clamp(0, 100),
      );
      
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> playWithPet() async {
    if (_petData == null) return;

    try {
      // TODO: API 호출로 변경
      await Future.delayed(const Duration(milliseconds: 500)); // 임시 딜레이
      
      _petData = _petData!.copyWith(
        happiness: (_petData!.happiness + 30).clamp(0, 100),
        satiety: (_petData!.satiety - 10).clamp(0, 100),
      );
      
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> healPet() async {
    if (_petData == null) return;

    try {
      // TODO: API 호출로 변경
      await Future.delayed(const Duration(milliseconds: 500)); // 임시 딜레이
      
      _petData = _petData!.copyWith(
        health: 100,
      );
      
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }
} 