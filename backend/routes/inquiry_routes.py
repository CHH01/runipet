from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from models.inquiries import Inquiry
from models.user import User
from extensions import db
from datetime import datetime

inquiry_bp = Blueprint("inquiry", __name__)

# ✅ 사용자 1:1 문의 등록
@inquiry_bp.route("/inquiry", methods=["POST"])
@jwt_required()
def create_inquiry():
    user_id = get_jwt_identity()
    data = request.get_json()

    new_inquiry = Inquiry(
        user_id=user_id,
        title=data.get("title"),
        content=data.get("content"),
        created_at=datetime.utcnow()
    )
    db.session.add(new_inquiry)
    db.session.commit()

    return jsonify({"message": "문의가 등록되었습니다."}), 201

# ✅ 내 문의 목록 조회
@inquiry_bp.route("/inquiry", methods=["GET"])
@jwt_required()
def get_my_inquiries():
    user_id = get_jwt_identity()
    inquiries = Inquiry.query.filter_by(user_id=user_id).all()

    result = []
    for i in inquiries:
        result.append({
            "id": i.id,
            "title": i.title,
            "content": i.content,
            "reply": i.reply,
            "created_at": i.created_at.isoformat() if i.created_at else None,
            "replied_at": i.replied_at.isoformat() if i.replied_at else None,
            "is_answered": i.is_answered
        })

    return jsonify(result), 200

# ✅ 전체 문의(관리자용)
@inquiry_bp.route("/admin/inquiries", methods=["GET"])
@jwt_required()
def get_all_inquiries():
    user_id = get_jwt_identity()
    user = User.query.get(user_id)
    if not user or user.role != "ADMIN":
        return jsonify({"error": "관리자 권한이 없습니다."}), 403

    inquiries = Inquiry.query.all()
    result = []
    for i in inquiries:
        result.append({
            "id": i.id,
            "user_id": i.user_id,
            "title": i.title,
            "content": i.content,
            "reply": i.reply,
            "created_at": i.created_at.isoformat() if i.created_at else None,
            "replied_at": i.replied_at.isoformat() if i.replied_at else None,
            "is_answered": i.is_answered
        })

    return jsonify(result), 200

# ✅ 문의 답변 등록(관리자용)
@inquiry_bp.route("/admin/inquiries/<int:inquiry_id>/reply", methods=["POST"])
@jwt_required()
def reply_to_inquiry(inquiry_id):
    user_id = get_jwt_identity()
    user = User.query.get(user_id)
    if not user or user.role != "ADMIN":
        return jsonify({"error": "관리자 권한이 없습니다."}), 403

    data = request.get_json()
    inquiry = Inquiry.query.get(inquiry_id)
    if not inquiry:
        return jsonify({"error": "해당 문의가 존재하지 않습니다."}), 404

    inquiry.reply = data.get("reply")
    inquiry.replied_at = datetime.utcnow()
    inquiry.is_answered = True
    db.session.commit()

    return jsonify({"message": "답변이 등록되었습니다."}), 200