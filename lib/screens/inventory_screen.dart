import 'package:flutter/material.dart';

class InventoryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> items = [
    {'name': '기본 사료', 'count': 3, 'effect': '배고픔 상태 10% 증가', 'category': 'food'},
    {'name': '고급 사료', 'count': 2, 'effect': '배고픔 상태 18% 증가', 'category': 'food'},
    {'name': '프리미엄 사료', 'count': 1, 'effect': '배고픔 상태 25% 증가', 'category': 'food'},
    {'name': '감기약', 'count': 2, 'effect': '감기 치료', 'category': 'medicine'},
    {'name': '해열제', 'count': 1, 'effect': '고열 치료', 'category': 'medicine'},
    {'name': '소화제', 'count': 1, 'effect': '배탈 치료', 'category': 'medicine'},
    {'name': '샤워', 'count': 2, 'effect': '병에 걸릴 확률 120분 동안 50% 하향', 'category': 'tool'},
    {'name': '빗질', 'count': 1, 'effect': '행복지수 20% 증가', 'category': 'tool'},
    {'name': '놀이', 'count': 3, 'effect': '행복지수 35% 증가\n버프: 경험치 증가량 1.5배', 'category': 'tool'},
  ];

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
                  // 아이템 아이콘 자리: 추후 Image.asset(item['image'])로 교체 가능
                  CircleAvatar(radius: 24, backgroundColor: Colors.orangeAccent),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${item['name']} : ${item['count']}개',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['effect'],
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: 아이템 사용 로직 또는 Navigator.pop(context, item);
                    },
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
}
