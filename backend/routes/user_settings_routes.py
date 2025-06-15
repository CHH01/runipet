from flask import Blueprint, jsonify, request
from flask_jwt_extended import jwt_required, get_jwt_identity
from models.user_settings import UserSettings
from extensions import db

user_settings_bp = Blueprint("user_settings", __name__)

# ✅ 사용자 설정 정보 조회
@user_settings_bp.route("/user-settings", methods=["GET"])
@jwt_required()
def get_user_settings():
    user_id = get_jwt_identity()
    settings = UserSettings.query.filter_by(user_id=user_id).first()
    if settings:
        return jsonify({
            "user_id": settings.user_id,
            "goal_steps": settings.goal_steps,
            "today_steps": settings.today_steps,
            "hunger_notify": settings.hunger_notify,
            "growth_notify": settings.growth_notify,
            "motivation_notify": settings.motivation_notify,
            "friend_notify": settings.friend_notify,
            "leaderboard_notify": settings.leaderboard_notify,
            "bgm_enabled": settings.bgm_enabled,
            "theme_id": settings.theme_id
        }), 200
    return jsonify({"error": "설정 정보를 찾을 수 없습니다."}), 404

# ✅ 사용자 설정 정보 업데이트
@user_settings_bp.route("/user-settings", methods=["PUT"])
@jwt_required()
def update_user_settings():
    user_id = get_jwt_identity()
    data = request.get_json()
    settings = UserSettings.query.filter_by(user_id=user_id).first()

    if not settings:
        return jsonify({"error": "설정 정보가 존재하지 않습니다."}), 404

    settings.goal_steps = data.get("goal_steps", settings.goal_steps)
    settings.today_steps = data.get("today_steps", settings.today_steps)
    settings.hunger_notify = data.get("hunger_notify", settings.hunger_notify)
    settings.growth_notify = data.get("growth_notify", settings.growth_notify)
    settings.motivation_notify = data.get("motivation_notify", settings.motivation_notify)
    settings.friend_notify = data.get("friend_notify", settings.friend_notify)
    settings.leaderboard_notify = data.get("leaderboard_notify", settings.leaderboard_notify)
    settings.bgm_enabled = data.get("bgm_enabled", settings.bgm_enabled)
    settings.theme_id = data.get("theme_id", settings.theme_id)

    db.session.commit()
    return jsonify({"message": "사용자 설정이 업데이트되었습니다."}), 200