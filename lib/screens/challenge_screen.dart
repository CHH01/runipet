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
          return const Center(child: CircularProgressIndicator());
        }

        if (challengeProvider.error != null) {
          return Center(child: Text('에러: ${challengeProvider.error}'));
        }

        final challenges = challengeProvider.challenges;

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
                    '+${challenge.reward} 코인',
                    style: const TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    if (!challenge.completed && challenge.current >= challenge.goal) {
                      challengeProvider.completeChallenge(challenge.id);
                      widget.onReward(challenge.reward);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${challenge.reward} 코인을 획득했습니다!'),
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
