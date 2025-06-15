from flask import Blueprint, jsonify
from models.shop import Shop
from models.items import Item

shop_bp = Blueprint("shop", __name__)

@shop_bp.route("/shop-items", methods=["GET"])
def get_shop_items():
    # 상점에 등록된 모든 아이템 목록을 불러옴
    shop_items = Shop.query.all()

    result = []
    for entry in shop_items:
        item = Item.query.get(entry.item_id)
        if item:
            result.append({
                "item_id": item.id,
                "name": item.name,
                "description": item.description,
                "price": entry.price,
                "category": item.category,
                "image_url": item.image_url if hasattr(item, "image_url") else None
            })

    return jsonify(result), 200