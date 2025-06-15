from extensions import db

# 사용자가 어떤 업적을 달성했는지 저장하는 테이블 (N:M 관계)
class UserAchievement(db.Model):
    __tablename__ = 'user_achievements'

    # 고유 ID (복합키 대신 단일 기본키 사용)
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)

    # 사용자 ID (users 테이블 외래키)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)

    # 업적 ID (achievements 테이블 외래키)
    achievement_id = db.Column(db.Integer, db.ForeignKey('achievements.id'), nullable=False)

    # 업적 달성 일자
    achieved_at = db.Column(db.DateTime, server_default=db.func.current_timestamp())