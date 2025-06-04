import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pet_provider.dart';
import '../providers/exercise_provider.dart';
import '../providers/challenge_provider.dart';
import '../providers/shop_provider.dart';
import '../providers/inventory_provider.dart';
import '../providers/ranking_provider.dart';
import '../providers/notification_provider.dart';
import '../models/user_data.dart';
import 'pet_home_screen.dart';
import 'start_exercise_screen.dart';
import 'challenge_screen.dart';
import 'shop_page.dart';
import 'inventory_screen.dart';
import 'settings_screen.dart';
import 'social_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 2;
  late UserData _userData;

  @override
  void initState() {
    super.initState();
    // 임시 데이터로 초기화
    _userData = UserData(
      coin: 1000,
      inventory: {},
    );
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PetProvider()),
        ChangeNotifierProvider(create: (_) => ExerciseProvider()),
        ChangeNotifierProvider(create: (_) => ChallengeProvider()),
        ChangeNotifierProvider(create: (_) => ShopProvider()),
        ChangeNotifierProvider(create: (_) => InventoryProvider()),
        ChangeNotifierProvider(create: (_) => RankingProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
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
            SocialPage(
              friends: [],
              onFriendAccepted: (friend) {
                // 친구 수락 처리
              },
              onFriendDeleted: (friendId) {
                // 친구 삭제 처리
              },
            ),
            const SettingScreen(),
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