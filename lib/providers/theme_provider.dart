import 'package:flutter/foundation.dart';
import '../models/theme_data.dart';
import '../services/theme_service.dart';

class ThemeProvider with ChangeNotifier {
  final ThemeService _themeService;
  List<ThemeData> _themes = [];
  ThemeData? _currentTheme;
  bool _isLoading = false;
  String? _error;

  ThemeProvider(this._themeService) {
    // 초기 테마 설정
    _themes = ThemeData.defaultThemes;
    _setCurrentSeasonTheme();
  }

  List<ThemeData> get themes => _themes;
  ThemeData? get currentTheme => _currentTheme;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void _setCurrentSeasonTheme() {
    final now = DateTime.now();
    final month = now.month;
    
    Season currentSeason;
    if (month >= 3 && month <= 5) {
      currentSeason = Season.spring;
    } else if (month >= 6 && month <= 8) {
      currentSeason = Season.summer;
    } else if (month >= 9 && month <= 11) {
      currentSeason = Season.fall;
    } else {
      currentSeason = Season.winter;
    }

    _currentTheme = _themes.firstWhere(
      (theme) => theme.season == currentSeason,
      orElse: () => _themes.first,
    );
    notifyListeners();
  }

  Future<void> loadThemes() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _themes = await _themeService.getThemes();
      _setCurrentSeasonTheme();
    } catch (e) {
      _error = e.toString();
      // API 호출 실패 시 기본 테마 사용
      _themes = ThemeData.defaultThemes;
      _setCurrentSeasonTheme();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setTheme(ThemeData theme) {
    _currentTheme = theme;
    notifyListeners();
  }

  void setThemeBySeason(Season season) {
    _currentTheme = _themes.firstWhere(
      (theme) => theme.season == season,
      orElse: () => _themes.first,
    );
    notifyListeners();
  }
} 