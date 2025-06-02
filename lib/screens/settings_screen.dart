import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/notification_provider.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  void _showConfirmDialog(BuildContext context, String title, String content, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child: const Text('확인', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _logout(BuildContext context) {
    _showConfirmDialog(
      context,
      '로그아웃',
      '정말 로그아웃 하시겠습니까?',
      () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('로그아웃하였습니다.')),
        );
        // 실제 로그아웃 기능은 여기에 구현
      },
    );
  }

  void _deleteAccount(BuildContext context) {
    _showConfirmDialog(
      context,
      '계정 삭제',
      '정말 계정을 삭제하시겠습니까?',
      () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('계정을 삭제하였습니다.')),
        );
        // 실제 계정 삭제 기능은 여기에 구현
      },
    );
  }

  Widget _settingTile(String title, {Widget? trailing}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF1DD),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(
      builder: (context, notificationProvider, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFFBE2B6),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text('설정', style: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold, fontSize: 38)),
            centerTitle: true,
            automaticallyImplyLeading: false,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            child: Column(
              children: [
                _settingTile(
                  '동물 배고픔',
                  trailing: Switch(
                    value: notificationProvider.hungerNoti,
                    onChanged: notificationProvider.toggleHungerNoti,
                    activeColor: Colors.green,
                  ),
                ),
                _settingTile(
                  '동물 성장',
                  trailing: Switch(
                    value: notificationProvider.growthNoti,
                    onChanged: notificationProvider.toggleGrowthNoti,
                    activeColor: Colors.green,
                  ),
                ),
                _settingTile(
                  '운동 동기부여',
                  trailing: Switch(
                    value: notificationProvider.motivationNoti,
                    onChanged: notificationProvider.toggleMotivationNoti,
                    activeColor: Colors.green,
                  ),
                ),
                _settingTile(
                  '친구 추가요청',
                  trailing: Switch(
                    value: notificationProvider.friendNoti,
                    onChanged: notificationProvider.toggleFriendNoti,
                    activeColor: Colors.green,
                  ),
                ),
                _settingTile(
                  '리더보드 순위',
                  trailing: Switch(
                    value: notificationProvider.leaderboardNoti,
                    onChanged: notificationProvider.toggleLeaderboardNoti,
                    activeColor: Colors.green,
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () => _logout(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    ),
                    child: const Text('로그아웃', style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () => _deleteAccount(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    ),
                    child: const Text('계정 삭제', style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
