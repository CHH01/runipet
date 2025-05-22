import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import '../core/constants/image_paths.dart';

class PetHomeScreen extends StatefulWidget {
  final String petName;
  final String petType;

  const PetHomeScreen({
    required this.petName,
    required this.petType,
    super.key,
  });

  @override
  State<PetHomeScreen> createState() => _PetHomeScreenState();
}

class _PetHomeScreenState extends State<PetHomeScreen> {
  late String petName;
  late String petType;

  int petLevel = 1;
  int petExp = 0;
  int maxExp = 5000;
  int happiness = 100;
  int satiety = 100;

  String petStatus = '행복';
  String petMessage = '처음 만났어요!';
  Timer? conditionTimer;

  @override
  void initState() {
    super.initState();
    petName = widget.petName;
    petType = widget.petType;

    conditionTimer = Timer.periodic(Duration(minutes: 20), (_) {
      setState(() {
        happiness = (happiness - 1).clamp(0, 100);
        satiety = (satiety - 1).clamp(0, 100);
        _updatePetStatus();
      });
    });
  }

  int _getGrowthStage() {
    if (petLevel < 3) return 1;
    if (petLevel < 7) return 2;
    if (petLevel < 12) return 3;
    if (petLevel < 25) return 4;
    return 5;
  }

  void _updatePetStatus() {
    final stage = _getGrowthStage();
    final rand = Random();

    if (happiness <= 20 && satiety <= 20) {
      petStatus = '우울+배고픔';
      petMessage = '배고프고 외로워요…';
    } else if (happiness <= 30) {
      petStatus = '우울';
      petMessage = '기분이 별로예요…';
    } else if (satiety < 30) {
      petStatus = '배고픔';
      petMessage = '배고파요 ㅠㅠ';
    } else if (_shouldTriggerIllness(stage)) {
      final illness = ['고열', '감기', '배탈'][rand.nextInt(3)];
      petStatus = illness;
      petMessage = '몸이 아파요…';
    } else {
      petStatus = '행복';
      petMessage = '산책가요!';
    }
  }

  bool _shouldTriggerIllness(int stage) {
    final rand = Random();
    int threshold = 50;
    int chance = 30;
    if (stage == 2) { threshold = 30; chance = 50; }
    else if (stage == 3) { threshold = 15; chance = 70; }

    return happiness < threshold && satiety < threshold && rand.nextInt(100) < chance;
  }

  @override
  void dispose() {
    conditionTimer?.cancel();
    super.dispose();
  }

  void _goToInventory() async {
    final result = await Navigator.pushNamed(context, '/inventory');
    if (result is ItemModel) {
      _applyItem(result);
    }
  }

  void _applyItem(ItemModel item) {
    // 아이템 효과 적용 로직 구현 예정
  }


  @override
  Widget build(BuildContext context) {
    int petStage = _getGrowthStage();
    String petImagePath = getPetImagePath(stage: petStage, status: petStatus, type: petType);
    double expPercent = petExp / maxExp;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: Image.asset('assets/images/pet_bg_1.png', fit: BoxFit.cover)),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/profile'),
                        child: CircleAvatar(
                          backgroundImage: AssetImage('assets/images/user_profile.png'),
                          radius: 24,
                        ),
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(petName, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                              SizedBox(width: 8),
                              Text('Lv. $petLevel', style: TextStyle(fontSize: 18)),
                            ],
                          ),
                          SizedBox(height: 6),
                          Stack(
                            children: [
                              Container(width: 180, height: 12, color: Colors.grey[300]),
                              Container(
                                width: 180 * expPercent,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Text('Exp ${(expPercent * 100).toStringAsFixed(0)} %'),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _statusIndicator('행복', happiness),
                      _statusIndicator('포만감', satiety),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                  ),
                  child: Text(petMessage, style: TextStyle(fontSize: 16)),
                ),
                Image.asset(petImagePath, height: 180),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(petStatus, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _actionButton('아이템 사용', Colors.orange, _goToInventory),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusIndicator(String label, int value) => Container(
    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.8),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text('$label  $value%', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
  );

  Widget _actionButton(String label, Color color, VoidCallback onTap) => ElevatedButton(
    onPressed: onTap,
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
    ),
    child: Text(label, style: TextStyle(color: Colors.black, fontSize: 16)),
  );
}
