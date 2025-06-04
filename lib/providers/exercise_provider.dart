import 'package:flutter/foundation.dart';
import '../models/exercise_data.dart';

class ExerciseProvider with ChangeNotifier {
  List<ExerciseData> _exerciseHistory = [];
  bool _isLoading = false;
  String? _error;
  bool _isExercising = false;
  double _distance = 0;
  int _duration = 0;
  int _calories = 0;
  int _steps = 0;

  List<ExerciseData> get exerciseHistory => _exerciseHistory;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isExercising => _isExercising;
  double get distance => _distance;
  int get duration => _duration;
  int get calories => _calories;
  int get steps => _steps;

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

  void startExercise() {
    _isExercising = true;
    _distance = 0;
    _duration = 0;
    _calories = 0;
    _steps = 0;
    notifyListeners();
  }

  void updateExerciseProgress({
    required double distance,
    required int duration,
    required int calories,
    required int steps,
  }) {
    _distance = distance;
    _duration = duration;
    _calories = calories;
    _steps = steps;
    notifyListeners();
  }

  void endExercise() {
    _isExercising = false;
    notifyListeners();
  }
} 