# routes/pet_routes.py

from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from models.pet import Pet
from models.pet_status_messages import PetStatusMessage
from extensions import db

pet_bp = Blueprint("pet", __name__)

# ✅ 내 펫 정보 조회
@pet_bp.route("/pet", methods=["GET"])
@jwt_required()
def get_pet():
    user_id = get_jwt_identity()
    pet = Pet.query.filter_by(user_id=user_id).first()

    if not pet:
        return jsonify({"error": "등록된 펫이 없습니다."}), 404

    return jsonify({
        "pet_id": pet.id,
        "nickname": pet.nickname,
        "type": pet.type,
        "level": pet.level,
        "exp": pet.exp,
        "fullness": pet.fullness,
        "happiness": pet.happiness,
        "health_status": pet.health_status,
        "stage_id": pet.stage_id,
        "status_message_id": pet.status_message_id,
    }), 200

# ✅ 내 펫 정보 업데이트
@pet_bp.route("/pet", methods=["PUT"])
@jwt_required()
def update_pet():
    user_id = get_jwt_identity()
    pet = Pet.query.filter_by(user_id=user_id).first()

    if not pet:
        return jsonify({"error": "등록된 펫이 없습니다."}), 404

    data = request.get_json()

    pet.exp = data.get("exp", pet.exp)
    pet.level = data.get("level", pet.level)
    pet.fullness = data.get("fullness", pet.fullness)
    pet.happiness = data.get("happiness", pet.happiness)
    pet.health_status = data.get("health_status", pet.health_status)
    pet.stage_id = data.get("stage_id", pet.stage_id)
    pet.status_message_id = data.get("status_message_id", pet.status_message_id)

    db.session.commit()

    return jsonify({"message": "펫 상태가 업데이트되었습니다."}), 200

# ✅ 펫 상태 기반 메시지 조회
@pet_bp.route("/pet-status-message/<int:pet_id>", methods=["GET"])
def get_pet_status_message(pet_id):
    pet = Pet.query.get(pet_id)
    if not pet:
        return jsonify({"error": "해당 펫을 찾을 수 없습니다."}), 404

    # 건강 상태, 포만감(구간)에 따라 메시지 조회
    status_message = PetStatusMessage.query.filter(
        PetStatusMessage.health_status == pet.health_status,
        PetStatusMessage.min_fullness <= pet.fullness,
        PetStatusMessage.max_fullness >= pet.fullness,
    ).first()

    if not status_message:
        return jsonify({"message": "해당 상태에 대한 메시지가 존재하지 않습니다."}), 404

    return jsonify({
        "health_status": pet.health_status,
        "fullness": pet.fullness,
        "message": status_message.message
    }), 200