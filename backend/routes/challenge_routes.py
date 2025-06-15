from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from models.challenge import Challenge
from models.user import User
from extensions import db

challenge_bp = Blueprint("challenge", __name__)

# ✅ 사용자의 모든 챌린지 조회
@challenge_bp.route("/challenges", methods=["GET"])
@jwt_required()
def get_challenges():
    user_id = get_jwt_identity()
    challenges = Challenge.query.filter_by(user_id=user_id).all()
    result = [{
        "id": c.id,
        "title": c.title,
        "description": c.description,
        "progress": c.progress,
        "goal": c.goal,
        "completed": c.completed,
        "reward": c.reward,
        "reward_claimed": c.reward_claimed
    } for c in challenges]
    return jsonify(result), 200

# ✅ 챌린지 추가(생성)
@challenge_bp.route("/challenges", methods=["POST"])
@jwt_required()
def create_challenge():
    user_id = get_jwt_identity()
    data = request.get_json()
    title = data.get("title")
    goal = data.get("goal")
    reward = data.get("reward", 0)

    if not title or goal is None:
        return jsonify({"error": "챌린지명과 목표값을 모두 입력해야 합니다."}), 400

    description = data.get("description", "")

    c = Challenge(
        user_id=user_id,
        title=title,
        description=description,
        goal=goal,
        reward=reward
    )
    db.session.add(c)
    db.session.commit()
    return jsonify({"message": "도전과제가 등록되었습니다."}), 201

# ✅ 챌린지 진행도/완료여부 갱신
@challenge_bp.route("/challenges/<int:challenge_id>/progress", methods=["PUT"])
@jwt_required()
def update_challenge(challenge_id):
    user_id = get_jwt_identity()
    c = Challenge.query.filter_by(id=challenge_id, user_id=user_id).first()
    if not c:
        return jsonify({"error": "도전과제를 찾을 수 없습니다."}), 404
    data = request.get_json()
    c.progress = data.get("progress", c.progress)
    c.completed = c.progress >= c.goal
    db.session.commit()
    return jsonify({
        "id": c.id,
        "title": c.title,
        "description": c.description,
        "progress": c.progress,
        "goal": c.goal,
        "completed": c.completed,
        "reward": c.reward,
        "reward_claimed": c.reward_claimed
    }), 200

# ✅ 챌린지 보상 수령
@challenge_bp.route("/challenges/<int:challenge_id>/reward", methods=["POST"])
@jwt_required()
def claim_reward(challenge_id):
    user_id = get_jwt_identity()
    challenge = Challenge.query.filter_by(id=challenge_id, user_id=user_id).first()
    
    if not challenge:
        return jsonify({"error": "도전과제를 찾을 수 없습니다."}), 404
        
    if not challenge.completed:
        return jsonify({"error": "아직 완료되지 않은 도전과제입니다."}), 400
        
    if challenge.reward_claimed:
        return jsonify({"error": "이미 보상을 받은 도전과제입니다."}), 400
        
    # 사용자의 코인 증가
    user = User.query.get(user_id)
    user.coins += challenge.reward
    
    # 보상 수령 상태 업데이트
    challenge.reward_claimed = True
    
    db.session.commit()
    return jsonify({
        "message": "보상을 받았습니다.",
        "reward": challenge.reward,
        "total_coins": user.coins
    }), 200

@challenge_bp.route("/challenges/init", methods=["POST"])
@jwt_required()
def init_challenges():
    user_id = get_jwt_identity()
    
    # 기존 도전과제가 있는지 확인
    existing_challenges = Challenge.query.filter_by(user_id=user_id).all()
    if existing_challenges:
        return jsonify({"message": "이미 도전과제가 존재합니다."}), 400
    
    # 기본 도전과제 생성
    challenges = [
        Challenge(
            user_id=user_id,
            title="첫 운동",
            description="운동 시작하기",
            progress=0,
            goal=1,
            completed=False,
            reward=100,
            reward_claimed=False
        ),
        Challenge(
            user_id=user_id,
            title="50km 달리기",
            description="누적 거리 50km 달성",
            progress=0,
            goal=50,
            completed=False,
            reward=3000,
            reward_claimed=False
        ),
        Challenge(
            user_id=user_id,
            title="1시간 유지",
            description="운동 시작 1시간 달성",
            progress=0,
            goal=1,
            completed=False,
            reward=500,
            reward_claimed=False
        ),
        Challenge(
            user_id=user_id,
            title="화이팅!",
            description="10회 운동 달성",
            progress=0,
            goal=10,
            completed=False,
            reward=1000,
            reward_claimed=False
        )
    ]
    
    for challenge in challenges:
        db.session.add(challenge)
    
    try:
        db.session.commit()
        return jsonify({"message": "도전과제가 생성되었습니다."}), 201
    except Exception as e:
        db.session.rollback()
        return jsonify({"error": str(e)}), 500