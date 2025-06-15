from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from models.pit_stop import PitStop
from models.pit_stop_rewards import PitStopReward
from extensions import db
from datetime import datetime

pitstop_bp = Blueprint("pitstop", __name__)

@pitstop_bp.route("/pitstops", methods=["GET"])
def get_all_pitstops():
    pitstops = PitStop.query.all()
    result = []
    for p in pitstops:
        result.append({
            "id": p.id,
            "name": p.name,
            "description": p.description,
            "latitude": p.latitude,
            "longitude": p.longitude,
            "reward_type": p.reward_type,
            "reward_value": p.reward_value
        })
    return jsonify(result), 200

@pitstop_bp.route("/pitstops/<int:pitstop_id>", methods=["GET"])
def get_pitstop(pitstop_id):
    pitstop = PitStop.query.get(pitstop_id)
    if not pitstop:
        return jsonify({"error": "해당 피트스탑이 존재하지 않습니다."}), 404

    return jsonify({
        "id": pitstop.id,
        "name": pitstop.name,
        "description": pitstop.description,
        "latitude": pitstop.latitude,
        "longitude": pitstop.longitude,
        "reward_type": pitstop.reward_type,
        "reward_value": pitstop.reward_value
    }), 200

@pitstop_bp.route("/pitstops/<int:pitstop_id>/reward", methods=["POST"])
@jwt_required()
def claim_reward(pitstop_id):
    user_id = get_jwt_identity()

    existing_claim = PitStopReward.query.filter_by(
        user_id=user_id, pit_stop_id=pitstop_id
    ).first()

    if existing_claim:
        return jsonify({"message": "이미 해당 피트스탑 보상을 수령하였습니다."}), 400

    pitstop = PitStop.query.get(pitstop_id)
    if not pitstop:
        return jsonify({"error": "해당 피트스탑이 존재하지 않습니다."}), 404

    new_claim = PitStopReward(
        user_id=user_id,
        pit_stop_id=pitstop_id,
        claimed_at=datetime.utcnow()
    )
    db.session.add(new_claim)
    db.session.commit()

    return jsonify({
        "message": "피트스탑 보상을 수령하였습니다.",
        "reward_type": pitstop.reward_type,
        "reward_value": pitstop.reward_value
    }), 200