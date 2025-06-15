from flask import Blueprint, jsonify
from models.notice import Notice

notice_bp = Blueprint("notice", __name__)

# ✅ 전체 공지사항 조회 (최신순)
@notice_bp.route("/notices", methods=["GET"])
def get_notices():
    notices = Notice.query.order_by(Notice.created_at.desc()).all()
    result = [{
        "id": n.id,
        "title": n.title,
        "content": n.content,
        "created_at": n.created_at.isoformat() if n.created_at else None
    } for n in notices]
    return jsonify(result), 200