import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/shop_provider.dart';
import '../models/shop_item.dart';
import '../models/user_data.dart';

class ShopPage extends StatefulWidget {
  final UserData userData;
  final Function(UserData) onUserDataChanged;

  const ShopPage({
    super.key,
    required this.userData,
    required this.onUserDataChanged,
  });

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  @override
  void initState() {
    super.initState();
    // 상점 아이템 로드
    Future.microtask(() => 
      Provider.of<ShopProvider>(context, listen: false).loadShopItems()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ShopProvider>(
      builder: (context, shopProvider, child) {
        if (shopProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (shopProvider.error != null) {
          return Center(child: Text('에러: ${shopProvider.error}'));
        }

        final items = shopProvider.items;

        return Scaffold(
          appBar: AppBar(
            title: const Text('상점'),
            actions: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.monetization_on, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.userData.coin}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          body: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return _buildShopItem(item);
            },
          ),
        );
      },
    );
  }

  Widget _buildShopItem(ShopItem item) {
    final canPurchase = widget.userData.coin >= item.price;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Image.asset(
              item.imagePath,
              width: 80,
              height: 80,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.description,
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.monetization_on, color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            '${item.price}',
                            style: const TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: canPurchase
                            ? () async {
                                try {
                                  await Provider.of<ShopProvider>(context, listen: false)
                                      .purchaseItem(item.id);
                                  
                                  // 사용자 데이터 업데이트
                                  final updatedUserData = widget.userData.copyWith(
                                    coin: widget.userData.coin - item.price,
                                  );
                                  widget.onUserDataChanged(updatedUserData);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('구매 완료!'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('구매 실패: $e'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text('구매'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
