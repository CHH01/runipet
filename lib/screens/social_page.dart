import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/leaderboard_provider.dart';
import '../providers/social_provider.dart';
import 'friend_request_page.dart';
import 'friend_add_page.dart';
import 'friend_profile_screen.dart';

class SocialPage extends StatefulWidget {
  const SocialPage({super.key});

  @override
  State<SocialPage> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
  @override
  void initState() {
    super.initState();
    // 친구 목록 로드
    Future.microtask(() => 
      Provider.of<SocialProvider>(context, listen: false).loadFriends()
    );
  }

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
                  Expanded(
                    child: Consumer<SocialProvider>(
                      builder: (context, socialProvider, child) {
                        if (socialProvider.isLoading) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (socialProvider.error != null) {
                          return Center(child: Text('에러: ${socialProvider.error}'));
                        }

                        final friends = socialProvider.friends;
                        if (friends.isEmpty) {
                          return const Center(child: Text('친구가 없습니다.'));
                        }

                        return ListView.builder(
                          itemCount: friends.length,
                          itemBuilder: (context, index) {
                            final friend = friends[index];
                            return _userTile(
                              context,
                              friend.username,
                              friend.level,
                              onDelete: () async {
                                try {
                                  await socialProvider.deleteFriend(friend.friendId.toString());
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('${friend.username}님을 친구 목록에서 삭제했습니다.')),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('친구 삭제 실패: $e')),
                                  );
                                }
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
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
                            builder: (_) => FriendRequestPage(
                              onFriendAccepted: (friend) {
                                // 친구 목록 새로고침
                                Provider.of<SocialProvider>(context, listen: false).loadFriends();
                              },
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ),
            // 랭킹 탭
            Consumer<LeaderboardProvider>(
              builder: (context, leaderboardProvider, child) {
                if (leaderboardProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (leaderboardProvider.error != null) {
                  return Center(child: Text('에러: ${leaderboardProvider.error}'));
                }

                final leaderboard = leaderboardProvider.entries;
                final topRankers = leaderboard.take(3).toList();

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // 상위 랭커 3명
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (topRankers.length > 1)
                            _topRanker(2, topRankers[1].nickname, topRankers[1].totalSteps, topRankers[1].totalExperience, topRankers[1].rankIcon),
                          if (topRankers.isNotEmpty)
                            _topRanker(1, topRankers[0].nickname, topRankers[0].totalSteps, topRankers[0].totalExperience, topRankers[0].rankIcon),
                          if (topRankers.length > 2)
                            _topRanker(3, topRankers[2].nickname, topRankers[2].totalSteps, topRankers[2].totalExperience, topRankers[2].rankIcon),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // 랭킹 리스트
                      Expanded(
                        child: ListView.builder(
                          itemCount: leaderboard.length,
                          itemBuilder: (context, index) {
                            final ranker = leaderboard[index];
                            return _rankingTile(
                              ranker.rank,
                              ranker.nickname,
                              ranker.totalSteps,
                              ranker.totalExperience,
                              ranker.rankIcon,
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

  Widget _userTile(BuildContext context, String name, int level, {required VoidCallback onDelete}) {
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
              onPressed: onDelete,
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

  Widget _rankingTile(int rank, String name, int steps, int experience, String rankIcon) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
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
          CircleAvatar(
            backgroundImage: AssetImage(rankIcon),
            radius: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('$steps 걸음 • $experience XP'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _topRanker(int rank, String name, int steps, int experience, String rankIcon) {
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
                backgroundImage: AssetImage(rankIcon),
                radius: 40,
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
        Text('$steps 걸음 • $experience XP'),
      ],
    );
  }
}
