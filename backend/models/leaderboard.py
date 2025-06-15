from extensions import db

# 리더보드에 나타날 사용자 기록 저장 테이블
class Leaderboard(db.Model):
    __tablename__ = 'leaderboards'

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)

    # 사용자 ID
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)

    # 리더보드 유형 (예: 일간, 주간, 월간 등)
    type = db.Column(db.Enum('DAILY', 'WEEKLY', 'MONTHLY'), nullable=False)

    # 누적 경험치
    total_experience = db.Column(db.Integer, nullable=False, default=0)

    # 총 걸음 수
    total_steps = db.Column(db.Integer, nullable=False, default=0)

    # 랭크 아이콘(이미지 경로)
    rank_icon = db.Column(db.String(255), nullable=True)

    # 등록 시각
    recorded_at = db.Column(db.DateTime, server_default=db.func.current_timestamp())