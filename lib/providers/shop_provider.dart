import 'package:flutter/foundation.dart';
import '../models/shop_item.dart';

class ShopProvider with ChangeNotifier {
  List<ShopItem> _items = [
    ShopItem(
      id: 'basic_feed',
      name: '기본 사료',
      description: '포만감 +10%',
      imagePath: 'assets/images/items/basic_feed.png',
      price: 500,
      effect: {'type': 'satiety', 'value': 10},
      type: 'food',
    ),
    ShopItem(
      id: 'super_feed',
      name: '고급 사료',
      description: '포만감 +18%',
      imagePath: 'assets/images/items/super_feed.png',
      price: 700,
      effect: {'type': 'satiety', 'value': 18},
      type: 'food',
    ),
    ShopItem(
      id: 'premium_feed',
      name: '프리미엄 사료',
      description: '포만감 +25%',
      imagePath: 'assets/images/items/premium_feed.png',
      price: 1000,
      effect: {'type': 'satiety', 'value': 25},
      type: 'food',
    ),
    ShopItem(
      id: 'cold_medicine',
      name: '감기약',
      description: '감기 치료',
      imagePath: 'assets/images/items/cold_medicine.png',
      price: 800,
      effect: {'type': 'cure', 'disease': '감기'},
      type: 'medicine',
    ),
    ShopItem(
      id: 'fever_medicine',
      name: '해열제',
      description: '고열 치료',
      imagePath: 'assets/images/items/fever_medicine.png',
      price: 1000,
      effect: {'type': 'cure', 'disease': '고열'},
      type: 'medicine',
    ),
    ShopItem(
      id: 'digestive',
      name: '소화제',
      description: '배탈 치료',
      imagePath: 'assets/images/items/digestive.png',
      price: 1200,
      effect: {'type': 'cure', 'disease': '배탈'},
      type: 'medicine',
    ),
    ShopItem(
      id: 'shower',
      name: '샤워',
      description: '병 확률 감소 (120분)',
      imagePath: 'assets/images/items/shower.png',
      price: 1500,
      effect: {'type': 'buff', 'duration': 120, 'effect': 0.5},
      type: 'accessory',
    ),
    ShopItem(
      id: 'brush',
      name: '빗질',
      description: '행복지수 +20%',
      imagePath: 'assets/images/items/brush.png',
      price: 1800,
      effect: {'type': 'happiness', 'value': 20},
      type: 'accessory',
    ),
    ShopItem(
      id: 'toy',
      name: '놀이',
      description: '행복지수 +35%',
      imagePath: 'assets/images/items/toy.png',
      price: 2000,
      effect: {'type': 'happiness', 'value': 35},
      type: 'accessory',
    ),
  ];

  bool _isLoading = false;
  String? _error;

  List<ShopItem> get items => _items;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadShopItems() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: API 호출로 변경
      await Future.delayed(const Duration(seconds: 1)); // 임시 딜레이
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> purchaseItem(String itemId) async {
    try {
      // TODO: API 호출로 변경
      await Future.delayed(const Duration(milliseconds: 500)); // 임시 딜레이
      // 아이템 구매 로직 구현
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  List<ShopItem> getItemsByType(String type) {
    return _items.where((item) => item.type == type).toList();
  }

  ShopItem? getItemById(String id) {
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }
} 