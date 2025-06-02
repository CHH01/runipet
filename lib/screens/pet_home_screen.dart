import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_screen.dart';
import 'inventory_screen.dart';
import 'profile_screen.dart';
import 'package:provider/provider.dart';
import '../providers/pet_provider.dart';
import '../models/pet_data.dart';
import '../models/user_data.dart';

class PetHomeScreen extends StatefulWidget {
  final String petName;
  final String petType;

  const PetHomeScreen({
    super.key,
    required this.petName,
    required this.petType,
  });

  @override
  State<PetHomeScreen> createState() => _PetHomeScreenState();
}

class _PetHomeScreenState extends State<PetHomeScreen> {
  late String petName;
  int petLevel = 1;
  int petExp = 0;
  int maxExp = 5000;
  int happiness = 100;
  int satiety = 100;
  String petStatus = '행복';
  String petMessage = '산책가요';
  String backgroundPath = 'assets/images/pet_bg_1.png';

  String get petImagePath {
    String status = 'normal';
    String stage;
    
    // 레벨에 따른 성장 단계 결정
    if (petLevel <= 3) {
      stage = 'stage_1_egg';
    } else if (petLevel <= 7) {
      stage = 'stage_2_hatch';
      if (petStatus != '행복') {
        status = 'sick';
      } else if (satiety < 30) {
        status = 'hungry';
      }
    } else if (petLevel <= 12) {
      stage = 'stage_3_child';
      if (petStatus != '행복') {
        status = 'sick';
      } else if (satiety < 30) {
        status = 'hungry';
      }
    } else if (petLevel <= 25) {
      stage = 'stage_4_adult';
      if (petStatus != '행복') {
        status = 'sick';
      } else if (satiety < 30) {
        status = 'hungry';
      }
    } else {
      stage = 'stage_5_elder';
      if (petStatus != '행복') {
        status = 'sick';
      } else if (satiety < 30) {
        status = 'hungry';
      }
    }

    return 'assets/images/pet/${widget.petType}/$stage/$status.png';
  }

  Duration? buffRemaining;
  double? activeBuffEffect;
  Timer? _buffTimer;
  Timer? _diseaseCheckTimer;
  DateTime? lastHungerNotiTime;
  Timer? _messageUpdateTimer;

  @override
  void initState() {
    super.initState();
    petName = widget.petName;
    _applySatietyAndHappinessDecay();
    _startDiseaseCheckTimer();
    _updatePetMessage();
    // 펫 데이터 로드
    Future.microtask(() => 
      Provider.of<PetProvider>(context, listen: false).loadPetData()
    );
  }

  Future<void> _applySatietyAndHappinessDecay() async {
    final prefs = await SharedPreferences.getInstance();
    int lastSatiety = prefs.getInt('lastSatiety') ?? satiety;
    int lastHappiness = prefs.getInt('lastHappiness') ?? happiness;
    int lastUpdate = prefs.getInt('lastUpdate') ?? DateTime.now().millisecondsSinceEpoch;
    int minutesPassed = DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(lastUpdate)).inMinutes;
    int decreaseCount = minutesPassed ~/ 10; // 10분마다 1씩 감소

    setState(() {
      satiety = (lastSatiety - decreaseCount).clamp(0, 100);
      happiness = (lastHappiness - decreaseCount).clamp(0, 100);
      _updatePetMessage();
    });

    // 현재 상태와 시간 저장
    prefs.setInt('lastSatiety', satiety);
    prefs.setInt('lastHappiness', happiness);
    prefs.setInt('lastUpdate', DateTime.now().millisecondsSinceEpoch);
  }

  void _startDiseaseCheckTimer() {
    _diseaseCheckTimer = Timer.periodic(Duration(minutes: 10), (_) {
      _checkForDisease();
    });
  }

  void _checkForDisease() {
    // 알 단계(레벨 3 이하)에서는 발병하지 않음
    if (petLevel <= 3) return;
    if (petStatus != '행복') return;

    double probability = 0;
    if (happiness < 15 && satiety < 15) {
      probability = 0.7;
    } else if (happiness < 30 && satiety < 30) {
      probability = 0.5;
    } else if (happiness < 50 && satiety < 50) {
      probability = 0.3;
    }

    if (probability > 0 && _isNotProtected()) {
      final rand = Random().nextDouble();
      if (rand < probability) {
        List<String> diseases = ['고열', '감기', '배탈'];
        final chosen = diseases[Random().nextInt(diseases.length)];

        setState(() {
          petStatus = chosen;
          petMessage = '몸이 안 좋아요... ($chosen)';
        });
      }
    }
  }

  void _updatePetMessage() {
    if (petStatus != '행복') {
      petMessage = '몸이 안 좋아요... ($petStatus)';
    } else if (satiety < 30) {
      petMessage = '배가 고파요...';
    } else if (happiness < 30) {
      petMessage = '심심해요...';
    } else {
      petMessage = '산책가요';
    }
  }

  bool _isNotProtected() {
    return buffRemaining == null;
  }

  void handleExerciseResult(Map<String, dynamic> result) {
    int xp = result['xp'] ?? 0;

    setState(() {
      petExp += xp;
      while (petExp >= maxExp && petLevel < 30) {
        petExp -= maxExp;
        petLevel++;
        _onLevelUp();
      }
      petMessage = '운동하고 왔어요!';
    });
    _checkSatietyAndNotify();

    if (result['buff'] != null) {
      final buff = result['buff'];
      Duration duration = Duration(minutes: buff['duration']);
      double effect = buff['effect'];
      if (activeBuffEffect == null || effect < activeBuffEffect!) {
        _applyBuff(duration, effect);
      }
    }
  }

  void _goToInventory() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InventoryScreen(
          userData: UserData(
            coin: 1000,
            inventory: {},
          ),
          onUserDataChanged: (newUserData) {
            setState(() {
              // 사용자 데이터 업데이트
            });
          },
        ),
      ),
    );
    if (result is Map && result['buff'] != null) {
      final buff = result['buff'];
      _applyBuff(Duration(minutes: buff['duration']), buff['effect']);
      setState(() {
        petMessage = '샤워하고 개운해졌어요!';
      });
      return;
    }
    if (result is Map && result['itemEffect'] != null) {
      final effect = result['itemEffect'];
      final String itemType = effect['type'];
      final String itemName = result['itemName'] ?? '아이템';

      setState(() {
        switch (itemType) {
          case 'satiety':
            satiety = (satiety + effect['value']).clamp(0, 100).toInt();
            petMessage = '$itemName 먹고 배불러요!';
            break;
          case 'happiness':
            happiness = (happiness + effect['value']).clamp(0, 100).toInt();
            petMessage = '$itemName 덕분에 기분 좋아요!';
            break;
          case 'cure':
            if (petStatus == effect['disease']) {
              petStatus = '행복';
              petMessage = '$itemName 먹고 나았어요!';
            } else {
              petMessage = '$itemName은 지금 필요 없어요';
            }
            break;
        }
      });
    }
  }

  void _applyBuff(Duration duration, double effect) {
    _buffTimer?.cancel();

    setState(() {
      buffRemaining = duration;
      activeBuffEffect = effect;
    });

    _buffTimer = Timer.periodic(Duration(minutes: 1), (timer) {
      if (buffRemaining == null) {
        timer.cancel();
        return;
      }

      setState(() {
        buffRemaining = buffRemaining! - Duration(minutes: 1);
        if (buffRemaining!.inMinutes <= 0) {
          buffRemaining = null;
          activeBuffEffect = null;
          _buffTimer?.cancel();
        }
      });
    });
  }

  String _formatBuffTime(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(d.inMinutes)}분';
  }

  @override
  void dispose() {
    _saveSatietyAndHappinessState();
    _diseaseCheckTimer?.cancel();
    _buffTimer?.cancel();
    _messageUpdateTimer?.cancel();
    super.dispose();
  }

  Future<void> _saveSatietyAndHappinessState() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('lastSatiety', satiety);
    prefs.setInt('lastHappiness', happiness);
    prefs.setInt('lastUpdate', DateTime.now().millisecondsSinceEpoch);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PetProvider>(
      builder: (context, petProvider, child) {
        if (petProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (petProvider.error != null) {
          return Center(child: Text('에러: ${petProvider.error}'));
        }

        final petData = petProvider.petData;
        if (petData == null) {
          return const Center(child: Text('펫 데이터를 불러올 수 없습니다.'));
        }

        double expPercent = petData.exp / petData.maxExp;

        return Scaffold(
          appBar: AppBar(
            title: Text(petData.name),
          ),
          body: Stack(
            children: [
              Positioned.fill(child: Image.asset(backgroundPath, fit: BoxFit.cover)),
              SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ProfileScreen()),
                            ),
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
                                  Container(
                                    width: 180,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
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
                              if (buffRemaining != null) ...[
                                SizedBox(height: 4),
                                Text(
                                  '버프 남은 시간: ${_formatBuffTime(buffRemaining!)}',
                                  style: TextStyle(color: Colors.redAccent),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _statusIndicator('행복', petData.happiness),
                          _statusIndicator('포만감', petData.satiety),
                        ],
                      ),
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                      ),
                      child: Text(petMessage, style: TextStyle(fontSize: 16)),
                    ),
                    SizedBox(height: 8),
                    Image.asset(petImagePath, height: 280),
                    SizedBox(height: 8),
                    Text(
                      petStatus,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _goToInventory,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: Text('아이템 사용', style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _statusIndicator(String label, int value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha((0.8 * 255).toInt()),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text('$label  $value%', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }

  void _checkSatietyAndNotify() async {
    final setting = context.findAncestorStateOfType<SettingScreenState>();
    if (setting == null) return;

    if (satiety < 50 && setting.hungerNoti) {
      final now = DateTime.now();
      if (lastHungerNotiTime == null || now.difference(lastHungerNotiTime!).inHours >= 12) {
        await setting.scheduleHungerNotification(); // 또는 showHungerNotification() 등 단일 알림
        lastHungerNotiTime = now;
      }
    }
  }

  void _onLevelUp() {
    final setting = context.findAncestorStateOfType<SettingScreenState>();
    if (setting != null && setting.growthNoti) {
      setting.showGrowthNotification();
    }
  }
}
