import 'package:flutter/material.dart';

class Challenge {
  final String name;
  final String description;
  final int reward;
  final String condition;
  final int current;
  final int goal;
  final bool completed;
  final String iconPath;

  Challenge({
    required this.name,
    required this.description,
    required this.reward,
    required this.condition,
    required this.current,
    required this.goal,
    required this.completed,
    required this.iconPath,
  });

  Challenge copyWith({
    int? current,
    bool? completed,
  }) {
    return Challenge(
      name: name,
      description: description,
      reward: reward,
      condition: condition,
      current: current ?? this.current,
      goal: goal,
      completed: completed ?? this.completed,
      iconPath: iconPath,
    );
  }
}

class ChallengeScreen extends StatefulWidget {
  final void Function(int reward) onReward;

  const ChallengeScreen({super.key, required this.onReward});

  @override
  State<ChallengeScreen> createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  List<Challenge> challenges = [
    Challenge(
      name: '첫 운동',
      description: '운동 시작하기',
      reward: 100,
      condition: '첫 운동 시작',
      current: 0,
      goal: 1,
      completed: true,
      iconPath: 'assets/images/icons/first_exercise.png',
    ),
    Challenge(
      name: '50km 달리기',
      description: '누적 거리 50km 달성',
      reward: 3000,
      condition: '누적 거리 50km 달성',
      current: 0,
      goal: 50,
      completed: false,
      iconPath: 'assets/images/icons/50km.png',
    ),
    Challenge(
      name: '1시간 유지',
      description: '운동 시작 1시간 달성',
      reward: 500,
      condition: '운동 시작 1시간 달성',
      current: 0,
      goal: 1,
      completed: true,
      iconPath: 'assets/images/icons/1hour.png',
    ),
    Challenge(
      name: '화이팅!',
      description: '10회 운동 달성',
      reward: 1000,
      condition: '10회 운동 달성',
      current: 0,
      goal: 10,
      completed: false,
      iconPath: 'assets/images/icons/10times.png',
    ),
  ];

  void _showDetail(Challenge challenge, int idx) {
    final canReceive = !challenge.completed && challenge.current >= challenge.goal;
    showDialog(
      context: context,
      builder: (context) => Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipOval(
                child: Image.asset(
                  challenge.iconPath,
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                challenge.name,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                challenge.description,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 32),
                  const SizedBox(width: 8),
                  Text('보상: ${challenge.reward}코인', style: const TextStyle(fontSize: 18)),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: canReceive ? Colors.orange : Colors.grey,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                onPressed: canReceive
                    ? () {
                        setState(() {
                          challenges[idx] = challenge.copyWith(
                            completed: true,
                            current: challenge.goal,
                          );
                        });
                        widget.onReward(challenge.reward);
                        Navigator.pop(context);
                      }
                    : () {
                        Navigator.pop(context);
                      },
                child: Text(
                  canReceive ? '받기' : '확인',
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBE2B6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('도전과제', style: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold, fontSize: 32)),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: challenges.length,
        separatorBuilder: (_, __) => const SizedBox(height: 18),
        itemBuilder: (context, idx) {
          final c = challenges[idx];
          return GestureDetector(
            onTap: () => _showDetail(c, idx),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(204),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        c.iconPath,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(c.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(c.description, style: const TextStyle(fontSize: 16)),
                        if (c.goal > 1)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text('${c.current} / ${c.goal}', style: const TextStyle(fontSize: 15)),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (c.completed)
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.green.withAlpha(26),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_circle_rounded,
                        color: Colors.green,
                        size: 36,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
