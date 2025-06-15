import 'package:flutter/foundation.dart';
import '../models/inventory_item.dart';
import '../services/api_service.dart';

class InventoryProvider extends ChangeNotifier {
  final ApiService _apiService;
  List<InventoryItem> _items = [];
  bool _isLoading = false;
  String? _error;

  InventoryProvider(this._apiService) {
    _initializeDefaultItems();
  }

  void _initializeDefaultItems() {
    _items = [
      InventoryItem(
        id: 'basic_feed',
        name: '기본 사료',
        description: '포만감 +10%',
        imagePath: 'assets/images/items/basic_feed.png',
        effect: '{"type": "satiety", "value": 10}',
        category: 'feed',
      ),
      InventoryItem(
        id: 'super_feed',
        name: '고급 사료',
        description: '포만감 +18%',
        imagePath: 'assets/images/items/super_feed.png',
        effect: '{"type": "satiety", "value": 18}',
        category: 'feed',
      ),
      InventoryItem(
        id: 'premium_feed',
        name: '프리미엄 사료',
        description: '포만감 +25%',
        imagePath: 'assets/images/items/premium_feed.png',
        effect: '{"type": "satiety", "value": 25}',
        category: 'feed',
      ),
      InventoryItem(
        id: 'cold_medicine',
        name: '감기약',
        description: '감기 치료',
        imagePath: 'assets/images/items/cold_medicine.png',
        effect: '{"type": "cure", "disease": "감기"}',
        category: 'medicine',
      ),
      InventoryItem(
        id: 'fever_medicine',
        name: '해열제',
        description: '고열 치료',
        imagePath: 'assets/images/items/fever_medicine.png',
        effect: '{"type": "cure", "disease": "고열"}',
        category: 'medicine',
      ),
      InventoryItem(
        id: 'digestive',
        name: '소화제',
        description: '배탈 치료',
        imagePath: 'assets/images/items/digestive.png',
        effect: '{"type": "cure", "disease": "배탈"}',
        category: 'medicine',
      ),
      InventoryItem(
        id: 'shower',
        name: '샤워',
        description: '병 확률 감소 (120분)',
        imagePath: 'assets/images/items/shower.png',
        effect: '{"type": "buff", "duration": 120, "effect": 0.5}',
        category: 'care',
      ),
      InventoryItem(
        id: 'brush',
        name: '빗질',
        description: '행복지수 +20%',
        imagePath: 'assets/images/items/brush.png',
        effect: '{"type": "happiness", "value": 20}',
        category: 'care',
      ),
      InventoryItem(
        id: 'toy',
        name: '놀이',
        description: '행복지수 +35%',
        imagePath: 'assets/images/items/toy.png',
        effect: '{"type": "happiness", "value": 35}',
        category: 'care',
      ),
    ];
  }

  List<InventoryItem> get items => _items;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadInventoryItems() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.get('/inventory');
      if (response['status'] == 'success') {
        final List<dynamic> data = response['data'];
        _items = data.map((json) => InventoryItem.fromJson(json)).toList();
      } else {
        _error = '인벤토리를 불러오는데 실패했습니다';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> useItem(String itemId) async {
    try {
      final response = await _apiService.post('/inventory/$itemId/use', {});
      if (response['status'] == 'success') {
        await loadInventoryItems();
      } else {
        _error = '아이템 사용에 실패했습니다';
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
} 