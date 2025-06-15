from flask import Blueprint, jsonify
from models.leaderboard import Leaderboard
from models.user import User
from extensions import db

leaderboard_bp = Blueprint("leaderboard", __name__)

# ✅ 누적 경험치 기준 상위 20명 리더보드
@leaderboard_bp.route("/leaderboard", methods=["GET"])
def get_leaderboard():
    top_users = (
        db.session.query(Leaderboard, User)
        .join(User, Leaderboard.user_id == User.id)
        .order_by(Leaderboard.total_experience.desc())
        .limit(20)
        .all()
    )

    result = []
    for rank, (lb, user) in enumerate(top_users, start=1):
        result.append({
            "rank": rank,
            "user_id": user.id,
            "username": user.username,
            "nickname": user.nickname,
            "total_experience": lb.total_experience,
            "steps": lb.total_steps,
            "rank_icon": lb.rank_icon
        })

    return jsonify(result), 200