import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/challenge_provider.dart';
import '../models/challenge_data.dart';

class ChallengeScreen extends StatefulWidget {
  final Function(int) onReward;

  const ChallengeScreen({
    super.key,
    required this.onReward,
  });

  @override
  State<ChallengeScreen> createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  @override
  void initState() {
    super.initState();
    // 화면이 처음 로드될 때 도전과제 데이터 로드
    Future.microtask(() => 
      Provider.of<ChallengeProvider>(context, listen: false).loadChallenges()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChallengeProvider>(
      builder: (context, challengeProvider, child) {
        if (challengeProvider.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (challengeProvider.error != null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('도전과제'),
              backgroundColor: Colors.orange,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('도전과제를 불러오는데 실패했습니다: ${challengeProvider.error}'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => challengeProvider.loadChallenges(),
                    child: Text('다시 시도'),
                  ),
                ],
              ),
            ),
          );
        }

        final challenges = challengeProvider.challenges;
        if (challenges.isEmpty) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('도전과제'),
              backgroundColor: Colors.orange,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('도전과제가 없습니다.'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => challengeProvider.initChallenges(),
                    child: Text('도전과제 초기화'),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('도전과제'),
            backgroundColor: Colors.orange,
          ),
          body: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: challenges.length,
            itemBuilder: (context, index) {
              final challenge = challenges[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  leading: Image.asset(
                    challenge.iconPath,
                    width: 40,
                    height: 40,
                  ),
                  title: Text(
                    challenge.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: challenge.completed ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(challenge.description),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: challenge.current / challenge.goal,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          challenge.completed ? Colors.green : Colors.orange,
                        ),
                      ),
                      Text(
                        '${challenge.current}/${challenge.goal}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  trailing: Text(
                    '+${challenge.reward_value} 코인',
                    style: const TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    if (!challenge.completed && challenge.current >= challenge.goal) {
                      challengeProvider.claimReward(challenge.id);
                      widget.onReward(challenge.reward_value);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${challenge.reward_value} 코인을 획득했습니다!'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
