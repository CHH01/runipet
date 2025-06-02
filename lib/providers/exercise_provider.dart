import 'package:flutter/foundation.dart';
import '../models/exercise_data.dart';

class ExerciseProvider with ChangeNotifier {
  List<ExerciseData> _exerciseHistory = [];
  bool _isLoading = false;
  String? _error;

  List<ExerciseData> get exerciseHistory => _exerciseHistory;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadExerciseHistory() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: API 호출로 변경
      await Future.delayed(const Duration(seconds: 1)); // 임시 딜레이
      _exerciseHistory = [
        ExerciseData(
          id: '1',
          startTime: DateTime.now().subtract(const Duration(hours: 1)),
          endTime: DateTime.now(),
          distance: 5000,
          duration: 3600,
          calories: 300,
          steps: 6000,
          type: 'walking',
        ),
      ];
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> startExercise() async {
    try {
      // TODO: API 호출로 변경
      await Future.delayed(const Duration(milliseconds: 500)); // 임시 딜레이
      // 운동 시작 로직 구현
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> endExercise(ExerciseData exerciseData) async {
    try {
      // TODO: API 호출로 변경
      await Future.delayed(const Duration(milliseconds: 500)); // 임시 딜레이
      _exerciseHistory.insert(0, exerciseData);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }
} 