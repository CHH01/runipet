import 'package:flutter/foundation.dart';
import '../models/inventory_item.dart';

class InventoryProvider with ChangeNotifier {
  List<InventoryItem> _items = [];
  bool _isLoading = false;
  String? _error;

  List<InventoryItem> get items => _items;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadInventoryItems() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: API 호출로 변경
      await Future.delayed(const Duration(seconds: 1)); // 임시 딜레이
      _items = [
        InventoryItem(
          id: 'basic_feed',
          name: '기본 사료',
          description: '포만감 +10%',
          imagePath: 'assets/images/items/basic_feed.png',
          effect: {'type': 'satiety', 'value': 10},
        ),
        InventoryItem(
          id: 'super_feed',
          name: '고급 사료',
          description: '포만감 +18%',
          imagePath: 'assets/images/items/super_feed.png',
          effect: {'type': 'satiety', 'value': 18},
        ),
        InventoryItem(
          id: 'premium_feed',
          name: '프리미엄 사료',
          description: '포만감 +25%',
          imagePath: 'assets/images/items/premium_feed.png',
          effect: {'type': 'satiety', 'value': 25},
        ),
        InventoryItem(
          id: 'cold_medicine',
          name: '감기약',
          description: '감기 치료',
          imagePath: 'assets/images/items/cold_medicine.png',
          effect: {'type': 'cure', 'disease': '감기'},
        ),
        InventoryItem(
          id: 'fever_medicine',
          name: '해열제',
          description: '고열 치료',
          imagePath: 'assets/images/items/fever_medicine.png',
          effect: {'type': 'cure', 'disease': '고열'},
        ),
        InventoryItem(
          id: 'digestive',
          name: '소화제',
          description: '배탈 치료',
          imagePath: 'assets/images/items/digestive.png',
          effect: {'type': 'cure', 'disease': '배탈'},
        ),
        InventoryItem(
          id: 'shower',
          name: '샤워',
          description: '병 확률 감소 (120분)',
          imagePath: 'assets/images/items/shower.png',
          effect: {'type': 'buff', 'duration': 120, 'effect': 0.5},
        ),
        InventoryItem(
          id: 'brush',
          name: '빗질',
          description: '행복지수 +20%',
          imagePath: 'assets/images/items/brush.png',
          effect: {'type': 'happiness', 'value': 20},
        ),
        InventoryItem(
          id: 'toy',
          name: '놀이',
          description: '행복지수 +35%',
          imagePath: 'assets/images/items/toy.png',
          effect: {'type': 'happiness', 'value': 35},
        ),
      ];
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> useItem(String itemId) async {
    try {
      // TODO: API 호출로 변경
      await Future.delayed(const Duration(milliseconds: 500)); // 임시 딜레이
      // 아이템 사용 로직 구현
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }
} 