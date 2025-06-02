import 'package:flutter/material.dart';

class FriendAddPage extends StatefulWidget {
  const FriendAddPage({super.key});

  @override
  State<FriendAddPage> createState() => _FriendAddPageState();
}

class _FriendAddPageState extends State<FriendAddPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _allUsers = [
    {'name': '현진', 'level': 2},
    {'name': '종천', 'level': 3},
    {'name': '원상', 'level': 4},
    {'name': '상욱', 'level': 5},
  ];

  String _searchQuery = '';
  final Set<String> _sentRequests = {}; // 요청 보낸 친구 이름 저장

  @override
  Widget build(BuildContext context) {
    final filteredUsers = _allUsers.where((user) {
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
            Text(
              '소셜',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
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
                hintText: "아이디, 이메일 입력",
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
                itemCount: filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = filteredUsers[index];
                  final name = user['name'];
                  final alreadySent = _sentRequests.contains(name);

                  return Card(
                    color: const Color(0xFFFFF5D1),
                    child: ListTile(
                      leading: const CircleAvatar(backgroundColor: Colors.grey),
                      title: Text('$name - Lv.${user['level']}'),
                      trailing: alreadySent
                          ? const Text("요청 완료", style: TextStyle(color: Colors.grey))
                          : IconButton(
                        icon: const Icon(Icons.add_circle, color: Colors.green),
                        onPressed: () {
                          setState(() {
                            _sentRequests.add(name);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('$name 님에게 친구 요청을 보냈습니다')),
                          );
                        },
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
