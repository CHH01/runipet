import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FriendAddPage extends StatefulWidget {
  const FriendAddPage({super.key});

  @override
  State<FriendAddPage> createState() => _FriendAddPageState();
}

class _FriendAddPageState extends State<FriendAddPage> {
  final TextEditingController _searchController = TextEditingController();
  late final ApiService _apiService;
  List<Map<String, dynamic>> _searchResults = [];
  String _searchQuery = '';
  final Set<String> _sentRequests = {}; // 요청 보낸 친구 ID 저장
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService(
      baseUrl: 'http://localhost:5000',
      secureStorage: const FlutterSecureStorage()
    );
  }

  Future<void> _searchUsers(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final results = await _apiService.searchUsers(query);
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('사용자 검색 중 오류가 발생했습니다: $e')),
        );
      }
    }
  }

  Future<void> _sendFriendRequest(String userId) async {
    try {
      await _apiService.sendFriendRequest(userId);
      setState(() {
        _sentRequests.add(userId);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('친구 요청을 보냈습니다')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('친구 요청 전송 중 오류가 발생했습니다: $e')),
        );
      }
    }
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
                _searchUsers(value);
              },
            ),
            const SizedBox(height: 16),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final user = _searchResults[index];
                    final userId = user['id'];
                    final alreadySent = _sentRequests.contains(userId);

                    return Card(
                      color: const Color(0xFFFFF5D1),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: user['profile_image'] != null
                              ? NetworkImage(user['profile_image'])
                              : const AssetImage('assets/profile_male.png') as ImageProvider,
                        ),
                        title: Text('${user['nickname']} - Lv.${user['level']}'),
                        subtitle: Text(user['email'] ?? ''),
                        trailing: alreadySent
                            ? const Text("요청 완료", style: TextStyle(color: Colors.grey))
                            : IconButton(
                                icon: const Icon(Icons.add_circle, color: Colors.green),
                                onPressed: () => _sendFriendRequest(userId),
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
