import 'package:flutter/material.dart';

class SelectPetScreen extends StatefulWidget {
  const SelectPetScreen({super.key});

  @override
  State<SelectPetScreen> createState() => _SelectPetScreenState();
}

class _SelectPetScreenState extends State<SelectPetScreen> {
  String? selectedPet;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFAEEA95), // 연한 초록 배경
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 30),
            // 로고
            Text(
              'RuniPet',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            SizedBox(height: 60),
            // 동물 선택 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPetOption('토끼', 'assets/images/rabbit.png'),
                _buildPetOption('강아지', 'assets/images/dog.png'),
                _buildPetOption('고양이', 'assets/images/cat.png'),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('토끼', style: TextStyle(fontSize: 16)),
                Text('강아지', style: TextStyle(fontSize: 16)),
                Text('고양이', style: TextStyle(fontSize: 16)),
              ],
            ),
            Spacer(),
            // 선택 완료 버튼
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 30),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: selectedPet != null
                      ? () {
                          // 다음 화면 이동 또는 상태 저장
                          print('선택된 동물: $selectedPet');
                          Navigator.pushNamed(context, '/start_exercise');
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: Text(
                    '선택 완료',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPetOption(String petName, String assetPath) {
    final isSelected = selectedPet == petName;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPet = petName;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: Colors.orange, width: 3) : null,
        ),
        padding: EdgeInsets.all(8),
        child: CircleAvatar(
          radius: 45,
          backgroundImage: AssetImage(assetPath),
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}
