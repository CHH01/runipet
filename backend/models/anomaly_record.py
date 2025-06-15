from extensions import db

# 이상 운동 기록(비정상 패턴/치트 등)을 저장하는 테이블
class AnomalyRecord(db.Model):
    __tablename__ = 'anomaly_records'
    
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)

    # 이상 기록 유형 (예: steps_per_minute, calories, speed 등)
    record_type = db.Column(db.String(50), nullable=False)

    # 실제 측정 값
    value = db.Column(db.Float, nullable=True)

    # 감지 사유(설명)
    reason = db.Column(db.String(255), nullable=False)

    # 감지 시각
    detected_at = db.Column(db.DateTime, server_default=db.func.now())