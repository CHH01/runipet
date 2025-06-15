from flask import Blueprint, request, jsonify
from models.pet_status_messages import PetStatusMessage

pet_status_message_bp = Blueprint("pet_status_message", __name__)

# ✅ 전체 메시지 조회
@pet_status_message_bp.route("/status-messages", methods=["GET"])
def get_all_messages():
    messages = PetStatusMessage.query.all()
    result = []
    for msg in messages:
        result.append({
            "id": msg.id,
            "health_status": msg.health_status,
            "min_fullness": msg.min_fullness,
            "max_fullness": msg.max_fullness,
            "min_happiness": msg.min_happiness,
            "max_happiness": msg.max_happiness,
            "message": msg.message
        })
    return jsonify(result), 200

# ✅ 조건별 메시지 조회 (건강+포만+행복 구간)
@pet_status_message_bp.route("/status-messages/filter", methods=["GET"])
def get_message_by_condition():
    health = request.args.get("health_status", type=str)
    fullness = request.args.get("fullness", type=int)
    happiness = request.args.get("happiness", type=int)

    query = PetStatusMessage.query
    if health:
        query = query.filter_by(health_status=health)
    if fullness is not None:
        query = query.filter(
            PetStatusMessage.min_fullness <= fullness,
            PetStatusMessage.max_fullness >= fullness
        )
    if happiness is not None:
        query = query.filter(
            PetStatusMessage.min_happiness <= happiness,
            PetStatusMessage.max_happiness >= happiness
        )

    messages = query.all()

    result = []
    for msg in messages:
        result.append({
            "id": msg.id,
            "health_status": msg.health_status,
            "min_fullness": msg.min_fullness,
            "max_fullness": msg.max_fullness,
            "min_happiness": msg.min_happiness,
            "max_happiness": msg.max_happiness,
            "message": msg.message
        })

    return jsonify(result), 200