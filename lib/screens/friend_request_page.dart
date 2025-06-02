import 'package:flutter/material.dart';

class FriendRequestPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onFriendAccepted;
  const FriendRequestPage({super.key, required this.onFriendAccepted});

  @override
  State<FriendRequestPage> createState() => _FriendRequestPageState();
}

class _FriendRequestPageState extends State<FriendRequestPage> {
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _requests = [
    {'name': '현진', 'level': 2},
    {'name': '종천', 'level': 3},
    {'name': '원상', 'level': 4},
  ];

  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filtered = _requests.where((user) {
      return user['name'].toString().contains(_searchQuery);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFD5F3C4),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD5F3C4),
        elevation: 0,
        title: Row(
          children: const [
            CircleAvatar(backgroundImage: AssetImage('assets/profile_male.png'), radius: 18),
            SizedBox(width: 8),
            Text('소셜', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: "아이디 또는 닉네임 검색",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final user = filtered[index];
                  final name = user['name'];

                  return Card(
                    color: const Color(0xFFFFF5D1),
                    child: ListTile(
                      leading: const CircleAvatar(backgroundColor: Colors.grey),
                      title: Text("$name - Lv.${user['level']}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.check_circle, color: Colors.green),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("$name님 친구 수락됨")),
                              );
                              widget.onFriendAccepted(user);
                              setState(() {
                                _requests.removeWhere((r) => r['name'] == name);
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.cancel, color: Colors.red),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("$name님 친구 거절됨")),
                              );
                              setState(() {
                                _requests.removeWhere((r) => r['name'] == name);
                              });
                            },
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
