import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/pet_provider.dart';
import 'main_screen.dart';

class PetSelectScreen extends StatefulWidget {
  const PetSelectScreen({super.key});

  @override
  State<PetSelectScreen> createState() => _PetSelectScreenState();
}

class _PetSelectScreenState extends State<PetSelectScreen> {
  final TextEditingController nameController = TextEditingController();
  String selectedType = 'dog';

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void _goToPetHome() async {
    final name = nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('펫 이름을 입력해주세요.')),
      );
      return;
    }

    // 펫 상태 초기화
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastSatiety', 100);
    await prefs.setInt('lastHappiness', 100);
    await prefs.setInt('lastUpdate', DateTime.now().millisecondsSinceEpoch);

    // PetProvider를 통해 펫 데이터 생성
    final petProvider = Provider.of<PetProvider>(context, listen: false);
    await petProvider.createPet(name, selectedType);

    // 펫 정보를 저장하고 메인 화면으로 이동
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('가상동물 선택')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('펫 이름을 지어주세요:', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: '예: 누룽이',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Text('펫 종류를 선택하세요:', style: TextStyle(fontSize: 18)),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _animalButton('dog', '강아지', 'assets/images/pet/dog/stage_3_child/normal.png'),
                _animalButton('cat', '고양이', 'assets/images/pet/cat/stage_3_child/normal.png'),
                _animalButton('rabbit', '토끼', 'assets/images/pet/rabbit/stage_3_child/normal.png'),
              ],
            ),
            Spacer(),
            ElevatedButton(
              onPressed: _goToPetHome,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: Text('펫 선택 완료', style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _animalButton(String type, String label, String assetPath) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedType = type;
        });
      },
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: selectedType == type ? Colors.orange : Colors.transparent, width: 3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset(assetPath, width: 100, height: 100),
          ),
          SizedBox(height: 6),
          Text(label),
        ],
      ),
    );
  }
}
