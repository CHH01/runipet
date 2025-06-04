import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ranking_provider.dart';
import 'friend_request_page.dart';
import 'friend_add_page.dart';
import 'friend_profile_screen.dart';

class SocialPage extends StatelessWidget {
  final List<Map<String, dynamic>> friends;
  final void Function(Map<String, dynamic>) onFriendAccepted;
  final void Function(String name) onFriendDeleted;

  const SocialPage({
    super.key,
    required this.friends,
    required this.onFriendAccepted,
    required this.onFriendDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFD5F3C4),
        appBar: AppBar(
          backgroundColor: const Color(0xFFD5F3C4),
          elevation: 0,
          title: Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('assets/images/user_profile.png'),
                radius: 18,
              ),
              const SizedBox(width: 8),
              const Text(
                '소셜',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          bottom: const TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.orange,
            tabs: [
              Tab(text: '친구'),
              Tab(text: '랭킹'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // 친구 탭
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("친구", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...friends.map((user) => _userTile(context, user['name'] as String, user['level'] as int)),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _actionButton("친구 추가", Colors.orange, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const FriendAddPage()),
                        );
                      }),
                      _actionButton("친구 수락", Colors.green, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FriendRequestPage(onFriendAccepted: onFriendAccepted),
                          ),
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ),
            // 랭킹 탭
            Consumer<RankingProvider>(
              builder: (context, rankingProvider, child) {
                if (rankingProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (rankingProvider.error != null) {
                  return Center(child: Text('에러: ${rankingProvider.error}'));
                }

                final rankings = rankingProvider.getCurrentRankings();
                final topRankers = rankingProvider.getTopRankers();
                final myRanking = rankingProvider.getMyRanking();

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // 랭킹 필터
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _rankingFilterChip('전체', rankingProvider.currentFilter == '전체', () {
                              rankingProvider.setFilter('전체');
                            }),
                            _rankingFilterChip('친구', rankingProvider.currentFilter == '친구', () {
                              rankingProvider.setFilter('친구');
                            }),
                            _rankingFilterChip('주간', rankingProvider.currentFilter == '주간', () {
                              rankingProvider.setFilter('주간');
                            }),
                            _rankingFilterChip('월간', rankingProvider.currentFilter == '월간', () {
                              rankingProvider.setFilter('월간');
                            }),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // 상위 랭커 3명
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (topRankers.length > 1)
                            _topRanker(2, topRankers[1].name, topRankers[1].totalSteps, topRankers[1].profileImage ?? 'assets/profile_male.png'),
                          if (topRankers.isNotEmpty)
                            _topRanker(1, topRankers[0].name, topRankers[0].totalSteps, topRankers[0].profileImage ?? 'assets/profile_female.png'),
                          if (topRankers.length > 2)
                            _topRanker(3, topRankers[2].name, topRankers[2].totalSteps, topRankers[2].profileImage ?? 'assets/profile_male.png'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // 랭킹 리스트
                      Expanded(
                        child: ListView.builder(
                          itemCount: rankings.length,
                          itemBuilder: (context, index) {
                            final ranking = rankings[index];
                            return _rankingTile(
                              index + 1,
                              ranking.name,
                              ranking.totalSteps,
                              ranking.isMe,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _rankingFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onTap(),
        backgroundColor: Colors.white,
        selectedColor: Colors.orange.withOpacity(0.3),
        checkmarkColor: Colors.orange,
      ),
    );
  }

  Widget _topRanker(int rank, String name, int steps, String imagePath) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: rank == 1 ? Colors.amber : Colors.grey,
                  width: 2,
                ),
              ),
              child: CircleAvatar(
                backgroundImage: AssetImage(imagePath),
              ),
            ),
            Positioned(
              top: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: rank == 1 ? Colors.amber : Colors.grey,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$rank',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text('$steps 걸음'),
      ],
    );
  }

  Widget _rankingTile(int rank, String name, int steps, bool isHighlighted) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isHighlighted ? Colors.orange.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$rank',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 12),
          const CircleAvatar(backgroundColor: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('$steps 걸음'),
              ],
            ),
          ),
          if (isHighlighted)
            const Icon(Icons.arrow_upward, color: Colors.orange),
        ],
      ),
    );
  }

  Widget _userTile(BuildContext context, String name, int level) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FriendProfileScreen(
                name: name,
                level: level,
                totalSteps: 30000,
                recentDistance: 2.0,
                recentTime: 20,
                recentKcal: 300,
              ),
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const CircleAvatar(backgroundColor: Colors.grey),
                const SizedBox(width: 10),
                Text("$name - 동행 Lv $level"),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                onFriendDeleted(name);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(text),
    );
  }
}
