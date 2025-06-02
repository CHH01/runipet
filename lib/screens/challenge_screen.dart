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
    // 도전과제 로드
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
          ),
          body: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: challenges.length,
            itemBuilder: (context, index) {
              final challenge = challenges[index];
              return _buildChallengeCard(challenge);
            },
          ),
        );
      },
    );
  }

  Widget _buildChallengeCard(ChallengeData challenge) {
    final progress = (challenge.current / challenge.goal * 100).clamp(0, 100);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  challenge.iconPath,
                  width: 40,
                  height: 40,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        challenge.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        challenge.description,
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                if (challenge.completed)
                  const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Stack(
              children: [
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Container(
                  height: 8,
                  width: MediaQuery.of(context).size.width * 0.8 * (progress / 100),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${challenge.current}/${challenge.goal}',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  '보상: ${challenge.reward} 코인',
                  style: const TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
