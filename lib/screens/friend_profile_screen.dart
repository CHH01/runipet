import 'package:flutter/material.dart';

class FriendProfileScreen extends StatelessWidget {
  final String name;
  final int level;
  final int totalSteps;
  final double recentDistance;
  final int recentTime;
  final int recentKcal;

  const FriendProfileScreen({
    super.key,
    required this.name,
    required this.level,
    this.totalSteps = 0,
    this.recentDistance = 0.0,
    this.recentTime = 0,
    this.recentKcal = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9F7B3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD9F7B3),
        elevation: 0,
        title: Text(name, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: const AssetImage('assets/images/user_profile.png'),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.only(top: 6),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Image.asset('assets/images/pet_happy.png', width: 60),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('루니 펫: 누룽이 Lv. $level', style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('누적 걸음 수: $totalSteps'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Text('최근 기록', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 6),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text('거리', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('${recentDistance}KM', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Column(
                      children: [
                        const Text('시간', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('$recentTime분', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Column(
                      children: [
                        const Text('칼로리', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('${recentKcal}Kcal', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 