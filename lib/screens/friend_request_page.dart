import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/social_provider.dart';
import '../models/friend_data.dart';

class FriendRequestPage extends StatefulWidget {
  final Function(FriendData) onFriendAccepted;

  const FriendRequestPage({
    Key? key,
    required this.onFriendAccepted,
  }) : super(key: key);

  @override
  State<FriendRequestPage> createState() => _FriendRequestPageState();
}

class _FriendRequestPageState extends State<FriendRequestPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Consumer<SocialProvider>(
                builder: (context, socialProvider, child) {
                  if (socialProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (socialProvider.error != null) {
                    return Center(child: Text('에러: ${socialProvider.error}'));
                  }

                  final requests = socialProvider.pendingRequests;
                  final filtered = requests.where((request) {
                    return request.username.toLowerCase().contains(_searchQuery.toLowerCase());
                  }).toList();

                  if (filtered.isEmpty) {
                    return const Center(child: Text('친구 요청이 없습니다.'));
                  }

                  return ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final request = filtered[index];
                      return Card(
                        color: const Color(0xFFFFF5D1),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: request.profileImage != null
                                ? NetworkImage(request.profileImage!)
                                : null,
                            backgroundColor: Colors.grey,
                            child: request.profileImage == null
                                ? const Icon(Icons.person)
                                : null,
                          ),
                          title: Text(request.username),
                          subtitle: Text('Level ${request.level}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.check_circle, color: Colors.green),
                                onPressed: () async {
                                  try {
                                    await socialProvider.acceptFriendRequest(request.userId.toString());
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("${request.username}님 친구 수락됨")),
                                    );
                                    widget.onFriendAccepted(request);
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("친구 수락 실패: $e")),
                                    );
                                  }
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.cancel, color: Colors.red),
                                onPressed: () async {
                                  try {
                                    await socialProvider.rejectFriendRequest(request.userId.toString());
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("${request.username}님 친구 거절됨")),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("친구 거절 실패: $e")),
                                    );
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                      );
                    },
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
