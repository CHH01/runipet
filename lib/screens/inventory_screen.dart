import 'package:flutter/material.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  List<Map<String, dynamic>> items = [
    {
      'name': '기본 사료',
      'image': 'assets/images/items/basic_feed.png',
      'count': 3,
      'effect': {'type': 'satiety', 'value': 10},
    },
    {
      'name': '고급 사료',
      'image': 'assets/images/items/super_feed.png',
      'count': 2,
      'effect': {'type': 'satiety', 'value': 18},
    },
    {
      'name': '프리미엄 사료',
      'image': 'assets/images/items/premium_feed.png',
      'count': 1,
      'effect': {'type': 'satiety', 'value': 25},
    },
    {
      'name': '감기약',
      'image': 'assets/images/items/cold_medicine.png',
      'count': 2,
      'effect': {'type': 'cure', 'disease': '감기'},
    },
    {
      'name': '해열제',
      'image': 'assets/images/items/fever_medicine.png',
      'count': 1,
      'effect': {'type': 'cure', 'disease': '고열'},
    },
    {
      'name': '소화제',
      'image': 'assets/images/items/digestive.png',
      'count': 1,
      'effect': {'type': 'cure', 'disease': '배탈'},
    },
    {
      'name': '샤워',
      'image': 'assets/images/items/shower.png',
      'count': 2,
      'effect': {'type': 'buff', 'duration': 120, 'effect': 0.5},
    },
    {
      'name': '빗질',
      'image': 'assets/images/items/brush.png',
      'count': 1,
      'effect': {'type': 'happiness', 'value': 20},
    },
    {
      'name': '놀이',
      'image': 'assets/images/items/toy.png',
      'count': 3,
      'effect': {'type': 'happiness', 'value': 35},
    },
  ];

  void _useItem(int index) {
    final item = items[index];
    final effect = item['effect'];
    if (item['count'] <= 0) return;

    setState(() {
      items[index]['count']--;
    });

    if (effect['type'] == 'buff') {
      Navigator.pop(context, {
        'buff': {
          'type': effect['type'],
          'duration': effect['duration'],
          'effect': effect['effect'],
        }
      });
    } else {
      Navigator.pop(context, {
        'itemEffect': effect,
        'itemName': item['name'],
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('인벤토리')),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];

          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundImage: AssetImage(item['image']),
                    backgroundColor: Colors.white,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${item['name']} (${item['count']}개)',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(_getEffectText(item['effect']), style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: item['count'] > 0 ? () => _useItem(index) : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: Text('사용', style: TextStyle(color: Colors.black)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _getEffectText(Map<String, dynamic> effect) {
    switch (effect['type']) {
      case 'satiety':
        return '포만감 +${effect['value']}%';
      case 'happiness':
        return '행복지수 +${effect['value']}%';
      case 'cure':
        return '${effect['disease']} 치료';
      case 'buff':
        return '병 확률 감소 (${effect['duration']}분)';
      default:
        return '';
    }
  }
}
