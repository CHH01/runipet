import 'package:flutter/foundation.dart';
import '../models/user_settings_data.dart';
import '../services/user_settings_service.dart';

class UserSettingsProvider with ChangeNotifier {
  final UserSettingsService _settingsService;
  UserSettingsData? _settings;
  bool _isLoading = false;
  String? _error;

  UserSettingsProvider(this._settingsService);

  UserSettingsData? get settings => _settings;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadSettings() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _settings = await _settingsService.getSettings();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateSettings(UserSettingsData newSettings) async {
    try {
      final updatedSettings = await _settingsService.updateSettings(newSettings);
      if (updatedSettings != null) {
        _settings = updatedSettings;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateStepGoal(int goal) async {
    try {
      final updatedSettings = await _settingsService.updateStepGoal(goal);
      if (updatedSettings != null) {
        _settings = updatedSettings;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateHungerNotify(bool value) async {
    try {
      final updatedSettings = await _settingsService.updateHungerNotify(value);
      if (updatedSettings != null) {
        _settings = updatedSettings;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateGrowthNotify(bool value) async {
    try {
      final updatedSettings = await _settingsService.updateGrowthNotify(value);
      if (updatedSettings != null) {
        _settings = updatedSettings;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateMotivationNotify(bool value) async {
    try {
      final updatedSettings = await _settingsService.updateMotivationNotify(value);
      if (updatedSettings != null) {
        _settings = updatedSettings;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateFriendNotify(bool value) async {
    try {
      final updatedSettings = await _settingsService.updateFriendNotify(value);
      if (updatedSettings != null) {
        _settings = updatedSettings;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateLeaderboardNotify(bool value) async {
    try {
      final updatedSettings = await _settingsService.updateLeaderboardNotify(value);
      if (updatedSettings != null) {
        _settings = updatedSettings;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }
} 