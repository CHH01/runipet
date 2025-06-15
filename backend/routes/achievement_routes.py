from flask import Blueprint, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from models.achievement import Achievement
from models.user_achievements import UserAchievement

achievement_bp = Blueprint("achievement", __name__)

# ✅ 전체 업적 목록 조회
@achievement_bp.route("/achievements", methods=["GET"])
def get_all_achievements():
    achievements = Achievement.query.all()
    result = []
    for a in achievements:
        result.append({
            "id": a.id,
            "name": a.name,
            "description": a.description,
            "condition": a.condition,
            "image_url": a.image_url,
            "reward_type": a.reward_type,
            "reward_value": a.reward_value
        })
    return jsonify(result), 200

# ✅ 특정 업적 ID로 조회
@achievement_bp.route("/achievements/<int:achievement_id>", methods=["GET"])
def get_achievement_by_id(achievement_id):
    a = Achievement.query.get(achievement_id)
    if not a:
        return jsonify({"error": "해당 업적 정보를 찾을 수 없습니다."}), 404

    return jsonify({
        "id": a.id,
        "name": a.name,
        "description": a.description,
        "condition": a.condition,
        "image_url": a.image_url,
        "reward_type": a.reward_type,
        "reward_value": a.reward_value
    }), 200

# ✅ 내 업적 달성 현황 조회
@achievement_bp.route("/my-achievements", methods=["GET"])
@jwt_required()
def get_my_achievements():
    user_id = get_jwt_identity()
    user_achievements = UserAchievement.query.filter_by(user_id=user_id).all()
    result = []
    for ua in user_achievements:
        achievement = Achievement.query.get(ua.achievement_id)
        if achievement:
            result.append({
                "achievement_id": achievement.id,
                "name": achievement.name,
                "description": achievement.description,
                "condition": achievement.condition,
                "image_url": achievement.image_url,
                "reward_type": achievement.reward_type,
                "reward_value": achievement.reward_value,
                "achieved_at": ua.achieved_at.isoformat() if ua.achieved_at else None
            })
    return jsonify(result), 200