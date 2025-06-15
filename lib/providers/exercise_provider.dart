import 'package:flutter/foundation.dart';
import '../models/exercise_record.dart';
import '../services/api_service.dart';

class ExerciseProvider extends ChangeNotifier {
  final ApiService _apiService;
  List<ExerciseRecord> _exerciseHistory = [];
  bool _isLoading = false;
  String? _error;
  bool _isExercising = false;
  double _distance = 0;
  int _duration = 0;
  int _calories = 0;
  int _steps = 0;
  List<ExerciseRecord> _exerciseRecords = [];

  ExerciseProvider(this._apiService);

  List<ExerciseRecord> get exerciseHistory => _exerciseHistory;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isExercising => _isExercising;
  double get distance => _distance;
  int get duration => _duration;
  int get calories => _calories;
  int get steps => _steps;
  List<ExerciseRecord> get exerciseRecords => _exerciseRecords;

  Future<void> loadExerciseHistory() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.get('/exercise/records');
      final List<dynamic> data = response['records'];
      _exerciseHistory = data.map((json) => ExerciseRecord.fromJson(json)).toList();
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

  Future<void> endExercise() async {
    _isExercising = false;
    try {
      final exercise = ExerciseRecord(
        id: 0, // 서버에서 자동 생성
        startTime: DateTime.now().subtract(Duration(seconds: _duration)),
        endTime: DateTime.now(),
        distance: _distance,
        calories: _calories.toDouble(),
        steps: _steps,
        isAnomaly: false,
        duration: _duration,
      );
      await _apiService.post('/exercise/records', exercise.toJson());
      await loadExerciseHistory();
    } catch (e) {
      print('운동 종료 에러: $e');
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> loadExerciseRecords() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final response = await _apiService.get('/exercise/records');
      final List<dynamic> data = response['records'];
      _exerciseRecords = data.map((json) => ExerciseRecord.fromJson(json)).toList();
    } catch (e) {
      _error = '운동 기록을 불러오는데 실패했습니다: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveExerciseRecord(ExerciseRecord record) async {
    try {
      final response = await _apiService.post('/exercise/records', record.toJson());
      final newRecord = ExerciseRecord.fromJson(response['record']);
      _exerciseRecords.insert(0, newRecord);
      notifyListeners();
    } catch (e) {
      _error = '운동 기록 저장에 실패했습니다: $e';
      notifyListeners();
      throw Exception(_error);
    }
  }

  List<ExerciseRecord> getTodayExerciseRecords() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return _exerciseRecords.where((record) {
      final recordDate = DateTime(
        record.startTime.year,
        record.startTime.month,
        record.startTime.day,
      );
      return recordDate.isAtSameMomentAs(today);
    }).toList();
  }

  List<ExerciseRecord> getThisWeekExerciseRecords() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 7));
    
    return _exerciseRecords.where((record) {
      return record.startTime.isAfter(weekStart) && 
             record.startTime.isBefore(weekEnd);
    }).toList();
  }

  List<ExerciseRecord> getThisMonthExerciseRecords() {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd = DateTime(now.year, now.month + 1, 0);
    
    return _exerciseRecords.where((record) {
      return record.startTime.isAfter(monthStart) && 
             record.startTime.isBefore(monthEnd);
    }).toList();
  }
} 