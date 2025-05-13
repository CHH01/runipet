import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String nickname = '러너';
  int petLevel = 5;
  int totalSteps = 30000;
  double recentDistance = 2.0; // km
  int recentTime = 20; // minutes
  int recentKcal = 300;

  final TextEditingController _nicknameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nicknameController.text = nickname;
  }

  void _saveNickname() {
    setState(() {
      nickname = _nicknameController.text.trim();
    });
    Navigator.pop(context);
  }

  void _showNicknameDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('닉네임 변경'),
        content: TextField(
          controller: _nicknameController,
          decoration: InputDecoration(hintText: '새 닉네임 입력'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('취소')),
          TextButton(onPressed: _saveNickname, child: Text('저장')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD9F7B3),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.notifications_active, size: 30),
                    SizedBox(width: 10),
                    Icon(Icons.mail_outline, size: 30),
                  ],
                ),
              ),
              SizedBox(height: 20),
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/images/user_profile.png'),
              ),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {},
                child: Text('프로필 이미지 변경'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: StadiumBorder(),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text('닉네임', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              GestureDetector(
                onTap: _showNicknameDialog,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12),
                  margin: EdgeInsets.only(top: 6),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(nickname, style: TextStyle(fontSize: 18)),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text('펫 정보', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 6),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Image.asset('assets/images/pet_happy.png', width: 60),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('루니 펫: 누룽이 Lv. $petLevel', style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('누적 걸음 수: $totalSteps'),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text('최근 기록', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 6),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text('거리', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('${recentDistance}KM', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Column(
                      children: [
                        Text('시간', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('${recentTime}분', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Column(
                      children: [
                        Text('칼로리', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('${recentKcal}Kcal', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}