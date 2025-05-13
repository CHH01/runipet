import 'dart:async';
import 'package:flutter/material.dart';

class PetInteractionScreen extends StatefulWidget {
  const PetInteractionScreen({super.key});

  @override
  State<PetInteractionScreen> createState() => _PetInteractionScreenState();
}

class _PetInteractionScreenState extends State<PetInteractionScreen> {
  String petName = '누룽이';
  int petLevel = 1;
  double petExp = 0.0;
  String petStatus = '행복';
  int petStamina = 100;
  String petMood = '안녕!';
  String petImage = 'assets/images/pet_happy.png';
  int foodCount = 3;
  int medicineCount = 2;
  Timer? staminaTimer;

  @override
  void initState() {
    super.initState();
    staminaTimer = Timer.periodic(Duration(minutes: 20), (_) {
      setState(() {
        petStamina = (petStamina - 1).clamp(0, 100);
        _updatePetState();
      });
    });
  }

  void _updatePetState() {
    if (petStamina < 30) {
      petStatus = '위험';
      petMood = '너무 힘들어요 ㅠㅠ';
      petImage = 'assets/images/pet_critical.png';
    } else if (petStamina < 60) {
      petStatus = '배고픔';
      petMood = '배고파요 ㅠㅠ';
      petImage = 'assets/images/pet_sad.png';
    } else {
      petStatus = '행복';
      petMood = '산책가요';
      petImage = 'assets/images/pet_happy.png';
    }
  }

  void feedPet() {
    if (foodCount > 0) {
      setState(() {
        foodCount--;
        petStamina = (petStamina + 20).clamp(0, 100);
        _gainExp(0.1);
        _updatePetState();
        petMood = '고마워요!';
      });
    }
  }

  void giveMedicine() {
    if (medicineCount > 0) {
      setState(() {
        medicineCount--;
        petStamina = (petStamina + 10).clamp(0, 100);
        _gainExp(0.05);
        _updatePetState();
        petMood = '조금 나아졌어요!';
      });
    }
  }

  void _gainExp(double amount) {
    petExp += amount;
    if (petExp >= 1.0) {
      petLevel++;
      petExp = 0.0;
      petMood = '진화했어요!';
    }
  }

  @override
  void dispose() {
    staminaTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDEBE5),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset('assets/images/pet_background.png', fit: BoxFit.cover),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/profile'),
                        child: CircleAvatar(
                          backgroundImage: AssetImage('assets/images/user_profile.png'),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        width: 180,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('$petName   Lv.$petLevel', style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 4),
                            LinearProgressIndicator(
                              value: petExp,
                              minHeight: 6,
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                            ),
                            SizedBox(height: 4),
                            Text('상태: $petStatus'),
                            Text('체력: $petStamina%', style: TextStyle(
                              color: petStamina < 60 ? Colors.orange : Colors.black,
                            )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Center(
                  child: Column(
                    children: [
                      Image.asset(petImage, width: 150, height: 150),
                      SizedBox(height: 12),
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(petMood, style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _actionButton('먹이 주기 ($foodCount)', feedPet),
                    _actionButton('약 주기 ($medicineCount)', giveMedicine),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {},
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.directions_walk), label: '운동'),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: '상점'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: '소셜'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: '설정'),
        ],
      ),
    );
  }

  Widget _actionButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orangeAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: Text(text, style: TextStyle(fontSize: 16, color: Colors.black)),
    );
  }
}
