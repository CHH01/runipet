import 'package:flutter/material.dart';
import 'start_exercise_screen.dart';
import 'pet_home_screen.dart';
import 'challenge_screen.dart';
import 'settings_screen.dart';

class MainScreen extends StatefulWidget {
  final String petName;
  final String petType;

  const MainScreen({
    super.key,
    required this.petName,
    required this.petType,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 2; // 펫 화면을 기본으로 선택
  int coins = 0; // 코인 상태

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      ChallengeScreen(
        onReward: (amount) {
          setState(() {
            coins += amount;
          });
        },
      ),
      const StartExerciseScreen(),
      PetHomeScreen(petName: widget.petName, petType: widget.petType),
      const Center(child: Text('소셜')), // 임시 화면
      const SettingScreen(), // 임시 화면
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
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
            icon: Icon(Icons.home),
            label: '펫',
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
    );
  }
} 