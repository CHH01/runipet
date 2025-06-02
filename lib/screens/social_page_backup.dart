import 'package:flutter/material.dart';
import 'friend_request_page.dart';
import 'friend_add_page.dart';
import 'friend_profile_screen.dart';

class SocialPage extends StatelessWidget {
  final String gender;
  final List<Map<String, dynamic>> friends;
  final void Function(Map<String, dynamic>) onFriendAccepted;
  final void Function(String name) onFriendDeleted;

  const SocialPage({
    super.key,
    required this.gender,
    required this.friends,
    required this.onFriendAccepted,
    required this.onFriendDeleted,
  });

  @override
  Widget build(BuildContext context) {
    final profileImage = 'assets/profile_$gender.png';

    return Scaffold(
      backgroundColor: const Color(0xFFD5F3C4),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD5F3C4),
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(profileImage),
              radius: 18,
            ),
            const SizedBox(width: 8),
            const Text(
              '소셜',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Padding(
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