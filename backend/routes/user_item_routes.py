from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from models.user_items import UserItem
from models.items import Item
from extensions import db

user_item_bp = Blueprint("user_item", __name__)

@user_item_bp.route("/my-items", methods=["GET"])
@jwt_required()
def get_user_items():
    user_id = get_jwt_identity()
    user_items = UserItem.query.filter_by(user_id=user_id).all()

    result = []
    for ui in user_items:
        item = Item.query.get(ui.item_id)
        if item:
            result.append({
                "item_id": item.id,
                "name": item.name,
                "description": item.description,
                "category": item.category,
                "quantity": ui.quantity
            })

    return jsonify(result), 200


@user_item_bp.route("/use-item", methods=["POST"])
@jwt_required()
def use_item():
    user_id = get_jwt_identity()
    data = request.get_json()
    item_id = data.get("item_id")

    if not item_id:
        return jsonify({"error": "item_id가 필요합니다."}), 400

    user_item = UserItem.query.filter_by(user_id=user_id, item_id=item_id).first()

    if not user_item or user_item.quantity <= 0:
        return jsonify({"error": "해당 아이템을 가지고 있지 않거나 수량이 부족합니다."}), 404

    user_item.quantity -= 1
    db.session.commit()

    return jsonify({"message": "아이템이 성공적으로 사용되었습니다."}), 200