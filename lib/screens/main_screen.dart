import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pet_provider.dart';
import '../providers/exercise_provider.dart';
import '../providers/challenge_provider.dart';
import '../providers/shop_provider.dart';
import '../providers/inventory_provider.dart';
import '../providers/leaderboard_provider.dart';
import '../providers/notification_provider.dart';
import '../providers/user_settings_provider.dart';
import '../services/api_service.dart';
import '../services/challenge_service.dart';
import '../services/user_settings_service.dart';
import '../services/leaderboard_service.dart';
import '../services/notification_service.dart';
import '../models/user_data.dart';
import 'pet_home_screen.dart';
import 'start_exercise_screen.dart';
import 'challenge_screen.dart';
import 'shop_page.dart';
import 'inventory_screen.dart';
import 'social_page.dart';
import 'settings_screen.dart';
import '../services/user_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  late UserData _userData;

  @override
  void initState() {
    super.initState();
    _userData = UserData(
      userId: 'default_user',  // 임시 사용자 ID
      nickname: '러너',
      coin: 1000,
      inventory: {},
    );
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final userService = UserService();
      final userData = await userService.getUserProfile();
      setState(() {
        _userData = userData;
      });
    } catch (e) {
      // 에러 발생 시 기본값 유지
      print('프로필 로드 실패: $e');
    }
  }

  void _onUserDataChanged(UserData newUserData) {
    setState(() {
      _userData = newUserData;
    });
  }

  void _onReward(int amount) {
    setState(() {
      _userData = _userData.copyWith(
        coin: _userData.coin + amount,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final secureStorage = const FlutterSecureStorage();
    final apiService = ApiService(
      baseUrl: 'http://10.0.2.2:5000',
      secureStorage: secureStorage
    );
    final challengeService = ChallengeService(
      apiService,
      secureStorage,
      'http://10.0.2.2:5000'
    );
    final userSettingsService = UserSettingsService(
      apiService,
      secureStorage,
      'http://10.0.2.2:5000'
    );
    final leaderboardService = LeaderboardService(apiService);
    final notificationService = NotificationService(apiService);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PetProvider(apiService)),
        ChangeNotifierProvider(create: (_) => ExerciseProvider(apiService)),
        ChangeNotifierProvider(create: (_) => ChallengeProvider(challengeService)),
        ChangeNotifierProvider(create: (_) => ShopProvider()),
        ChangeNotifierProvider(create: (_) => InventoryProvider(apiService)),
        ChangeNotifierProvider(create: (_) => LeaderboardProvider(leaderboardService)),
        ChangeNotifierProvider(create: (_) => NotificationProvider(notificationService, userSettingsService)),
        ChangeNotifierProvider(create: (_) => UserSettingsProvider(userSettingsService)),
      ],
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            ChallengeScreen(onReward: _onReward),
            const StartExerciseScreen(),
            const PetHomeScreen(),
            ShopPage(
              userData: _userData,
              onUserDataChanged: _onUserDataChanged,
            ),
            const SocialPage(),
            const SettingsScreen(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.emoji_events),
              label: '도전과제',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.directions_run),
              label: '운동',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.pets),
              label: '홈',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: '상점',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: '소셜',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: '설정',
            ),
          ],
        ),
      ),
    );
  }
} 