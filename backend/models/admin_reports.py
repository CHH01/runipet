from extensions import db

# 사용자가 다른 사용자나 활동을 신고한 기록 저장 테이블
class AdminReport(db.Model):
    __tablename__ = 'admin_reports'

    # 신고 고유 ID
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)

    # 신고자 사용자 ID
    reporter_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)

    # 신고 대상 사용자 ID
    reported_user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)

    # 신고 사유
    reason = db.Column(db.String(255), nullable=False)

    # 신고 상세 내용 (선택)
    content = db.Column(db.Text, nullable=True)

    # 관리자 조치 내역 (선택)
    action_taken = db.Column(db.String(255), nullable=True)

    # 신고 일시
    reported_at = db.Column(db.DateTime, server_default=db.func.current_timestamp())