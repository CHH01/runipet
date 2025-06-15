import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_settings_provider.dart';
import '../providers/auth_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _goalStepsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<UserSettingsProvider>().loadSettings();
    });
  }

  @override
  void dispose() {
    _goalStepsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
        backgroundColor: Colors.orange,
      ),
      body: Consumer<UserSettingsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('설정을 불러오는데 실패했습니다: ${provider.error}'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.loadSettings(),
                    child: Text('다시 시도'),
                  ),
                ],
              ),
            );
          }

          final settings = provider.settings;
          if (settings == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('설정을 불러올 수 없습니다.'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.loadSettings(),
                    child: Text('다시 시도'),
                  ),
                ],
              ),
            );
          }

          _goalStepsController.text = settings.goal_steps?.toString() ?? '10000';

          return ListView(
            padding: EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '목표 걸음 수',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _goalStepsController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: '목표 걸음 수',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: () {
                              final goalSteps = int.tryParse(_goalStepsController.text);
                              if (goalSteps != null && goalSteps > 0) {
                                provider.updateStepGoal(goalSteps);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('유효한 걸음 수를 입력해주세요.'),
                                  ),
                                );
                              }
                            },
                            child: Text('저장'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '알림 설정',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      // 배고픔 알림
                      SwitchListTile(
                        title: Text('배고픔 알림'),
                        subtitle: Text('펫이 배고플 때 알림을 받습니다.'),
                        value: settings.hunger_notify,
                        onChanged: (value) {
                          provider.updateHungerNotify(value);
                        },
                      ),
                      Divider(),
                      // 성장 알림
                      SwitchListTile(
                        title: Text('성장 알림'),
                        subtitle: Text('펫이 성장할 때 알림을 받습니다.'),
                        value: settings.growth_notify,
                        onChanged: (value) {
                          provider.updateGrowthNotify(value);
                        },
                      ),
                      Divider(),
                      // 동기부여 알림
                      SwitchListTile(
                        title: Text('동기부여 알림'),
                        subtitle: Text('운동 동기부여 알림을 받습니다.'),
                        value: settings.motivation_notify,
                        onChanged: (value) {
                          provider.updateMotivationNotify(value);
                        },
                      ),
                      Divider(),
                      // 친구 알림
                      SwitchListTile(
                        title: Text('친구 알림'),
                        subtitle: Text('친구 관련 알림을 받습니다.'),
                        value: settings.friend_notify,
                        onChanged: (value) {
                          provider.updateFriendNotify(value);
                        },
                      ),
                      Divider(),
                      // 리더보드 알림
                      SwitchListTile(
                        title: Text('리더보드 알림'),
                        subtitle: Text('리더보드 순위 변동 알림을 받습니다.'),
                        value: settings.leaderboard_notify,
                        onChanged: (value) {
                          provider.updateLeaderboardNotify(value);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32),
              // 로그아웃 버튼
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
                  onPressed: () => _showLogoutDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    '로그아웃',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // 계정 삭제 버튼
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
                  onPressed: () => _showDeleteAccountDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    '계정 삭제',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('로그아웃'),
        content: const Text('정말 로그아웃 하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              context.read<AuthProvider>().logout();
              Navigator.pop(context);
            },
            child: const Text('로그아웃'),
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteAccountDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('계정 삭제'),
        content: const Text(
          '계정을 삭제하면 모든 데이터가 영구적으로 삭제됩니다.\n정말 계정을 삭제하시겠습니까?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              context.read<AuthProvider>().deleteAccount();
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }
}
