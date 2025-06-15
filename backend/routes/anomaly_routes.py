from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from models.anomaly_record import AnomalyRecord
from models.user import User
from extensions import db
from datetime import datetime

anomaly_bp = Blueprint("anomaly", __name__)

# ✅ 이상 기록 보고(저장)
@anomaly_bp.route("/anomaly/report", methods=["POST"])
@jwt_required()
def report_anomaly():
    user_id = get_jwt_identity()
    data = request.get_json()

    record_type = data.get("record_type")      # 예: steps_per_minute, calories, speed
    value = data.get("value")                  # 실제 측정 값
    reason = data.get("reason")                # 감지 사유

    if not record_type or value is None or not reason:
        return jsonify({"error": "유형, 값, 사유를 모두 입력해야 합니다."}), 400

    anomaly = AnomalyRecord(
        user_id=user_id,
        record_type=record_type,
        value=value,
        reason=reason,
        detected_at=datetime.utcnow()
    )
    db.session.add(anomaly)
    db.session.commit()

    return jsonify({"message": "이상 기록이 저장되었습니다."}), 201

# ✅ 관리자: 이상 기록 전체 조회
@anomaly_bp.route("/admin/anomalies", methods=["GET"])
@jwt_required()
def get_anomalies():
    admin_id = get_jwt_identity()
    admin = User.query.get(admin_id)

    if not admin or admin.role != "ADMIN":
        return jsonify({"error": "접근 권한이 없습니다."}), 403

    records = AnomalyRecord.query.order_by(AnomalyRecord.detected_at.desc()).all()

    result = []
    for r in records:
        result.append({
            "id": r.id,
            "user_id": r.user_id,
            "record_type": r.record_type,
            "value": r.value,
            "reason": r.reason,
            "detected_at": r.detected_at.isoformat()
        })

    return jsonify(result), 200