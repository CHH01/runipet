from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from models.social_relations import SocialRelation
from models.user import User
from extensions import db

friend_bp = Blueprint("friend", __name__)

# ✅ 내 친구 목록 조회
@friend_bp.route("/friends", methods=["GET"])
@jwt_required()
def get_friends():
    user_id = get_jwt_identity()
    friends = SocialRelation.query.filter_by(user_id=user_id, status="ACCEPTED").all()
    
    result = []
    for rel in friends:
        friend = User.query.get(rel.friend_id)
        if friend:
            result.append({
                "friend_id": friend.id,
                "username": friend.username,
                "nickname": friend.nickname
            })

    return jsonify(result), 200

# ✅ 친구 요청 보내기
@friend_bp.route("/friends/request", methods=["POST"])
@jwt_required()
def send_friend_request():
    user_id = get_jwt_identity()
    data = request.get_json()
    friend_username = data.get("username")

    friend = User.query.filter_by(username=friend_username).first()
    if not friend:
        return jsonify({"error": "해당 사용자를 찾을 수 없습니다."}), 404
    if friend.id == user_id:
        return jsonify({"error": "자기 자신에게 친구 요청을 보낼 수 없습니다."}), 400

    # 중복 요청/이미 친구 여부 확인
    existing = SocialRelation.query.filter_by(user_id=user_id, friend_id=friend.id).first()
    if existing:
        return jsonify({"error": "이미 친구 요청을 보냈거나 친구 상태입니다."}), 409

    relation = SocialRelation(user_id=user_id, friend_id=friend.id, status="PENDING")
    db.session.add(relation)
    db.session.commit()

    return jsonify({"message": "친구 요청이 전송되었습니다."}), 201

# ✅ 친구 요청 수락
@friend_bp.route("/friends/accept", methods=["POST"])
@jwt_required()
def accept_friend_request():
    user_id = get_jwt_identity()
    data = request.get_json()
    requester_id = data.get("requester_id")

    request_rel = SocialRelation.query.filter_by(user_id=requester_id, friend_id=user_id, status="PENDING").first()
    if not request_rel:
        return jsonify({"error": "수락할 친구 요청이 없습니다."}), 404

    # 상태 업데이트 및 역방향 친구 관계 추가
    request_rel.status = "ACCEPTED"
    db.session.add(SocialRelation(user_id=user_id, friend_id=requester_id, status="ACCEPTED"))
    db.session.commit()

    return jsonify({"message": "친구 요청을 수락하였습니다."}), 200

# ✅ 친구 삭제 (쿼리 파라미터로 friend_id 받음)
@friend_bp.route("/friends/remove", methods=["DELETE"])
@jwt_required()
def remove_friend():
    user_id = get_jwt_identity()
    friend_id = request.args.get("friend_id")

    if not friend_id:
        return jsonify({"error": "friend_id 쿼리 파라미터가 필요합니다."}), 400

    rel1 = SocialRelation.query.filter_by(user_id=user_id, friend_id=friend_id, status="ACCEPTED").first()
    rel2 = SocialRelation.query.filter_by(user_id=friend_id, friend_id=user_id, status="ACCEPTED").first()

    if not rel1 and not rel2:
        return jsonify({"error": "해당 친구 관계를 찾을 수 없습니다."}), 404

    if rel1:
        db.session.delete(rel1)
    if rel2:
        db.session.delete(rel2)

    db.session.commit()

    return jsonify({"message": "친구가 삭제되었습니다."}), 200