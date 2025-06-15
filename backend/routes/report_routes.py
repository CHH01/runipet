from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from models.admin_reports import AdminReport
from models.user import User
from extensions import db

report_bp = Blueprint("report", __name__)

@report_bp.route("/report", methods=["POST"])
@jwt_required()
def submit_report():
    reporter_id = get_jwt_identity()
    data = request.get_json()

    reported_user_id = data.get("reported_user_id")
    reason = data.get("reason")
    content = data.get("content")

    if not reported_user_id or not reason:
        return jsonify({"error": "신고 대상과 사유는 반드시 입력해야 합니다."}), 400

    report = AdminReport(
        reporter_id=reporter_id,
        reported_user_id=reported_user_id,
        reason=reason,
        content=content
    )
    db.session.add(report)
    db.session.commit()

    return jsonify({"message": "신고가 접수되었습니다."}), 201


@report_bp.route("/admin/reports", methods=["GET"])
@jwt_required()
def get_reports():
    admin_id = get_jwt_identity()
    admin = User.query.get(admin_id)

    if not admin or admin.role != "ADMIN":
        return jsonify({"error": "접근 권한이 없습니다."}), 403

    reports = AdminReport.query.order_by(AdminReport.reported_at.desc()).all()

    result = []
    for r in reports:
        result.append({
            "id": r.id,
            "reporter_id": r.reporter_id,
            "reported_user_id": r.reported_user_id,
            "reason": r.reason,
            "content": r.content,
            "action_taken": r.action_taken,
            "reported_at": r.reported_at.isoformat()
        })

    return jsonify(result), 200