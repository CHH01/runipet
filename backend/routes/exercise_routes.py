from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from models.exercise_record import ExerciseRecord
from extensions import db

exercise_bp = Blueprint("exercise", __name__)

# ✅ 운동 기록 저장
@exercise_bp.route("/exercises", methods=["POST"])
@jwt_required()
def save_exercise():
    user_id = get_jwt_identity()
    data = request.get_json()

    start_time = data.get("start_time")
    end_time = data.get("end_time")
    distance = data.get("distance")
    calories = data.get("calories")
    steps = data.get("steps")
    pet_id = data.get("pet_id")  # 선택값

    if None in [start_time, end_time, distance, calories, steps]:
        return jsonify({"error": "모든 운동 기록 항목이 필요합니다."}), 400

    record = ExerciseRecord(
        user_id=user_id,
        start_time=start_time,
        end_time=end_time,
        distance=distance,
        calories=calories,
        steps=steps,
        pet_id=pet_id
    )
    db.session.add(record)
    db.session.commit()

    return jsonify({"message": "운동 기록이 저장되었습니다."}), 201

# ✅ 내 운동 기록 전체 조회
@exercise_bp.route("/exercises", methods=["GET"])
@jwt_required()
def get_exercise_records():
    user_id = get_jwt_identity()
    records = ExerciseRecord.query.filter_by(user_id=user_id).all()

    result = []
    for r in records:
        result.append({
            "id": r.id,
            "start_time": r.start_time.isoformat() if r.start_time else None,
            "end_time": r.end_time.isoformat() if r.end_time else None,
            "distance": r.distance,
            "calories": r.calories,
            "steps": r.steps,
            "pet_id": r.pet_id,
            "is_anomaly": r.is_anomaly
        })

    return jsonify(result), 200