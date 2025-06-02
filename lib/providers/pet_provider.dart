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
      await Future.delayed(const Duration(seconds: 1));
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