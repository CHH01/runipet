from extensions import db

# 사용자 개인 설정 정보를 저장하는 테이블
class UserSettings(db.Model):
    __tablename__ = 'user_settings'

    # 사용자 ID (users 테이블과 1:1 관계, 기본키)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), primary_key=True)

    # 사용자가 설정한 목표 걸음 수
    goal_steps = db.Column(db.Integer, default=10000)

    # 사용자가 선택한 테마 ID (themes 테이블의 외래키)
    theme_id = db.Column(db.Integer, db.ForeignKey('themes.id'), nullable=True)

    # 오늘의 걸음 수
    today_steps = db.Column(db.Integer, default=0)

    # 각종 알림 기능 설정 여부
    hunger_notify = db.Column(db.Boolean, default=True)
    growth_notify = db.Column(db.Boolean, default=True)
    motivation_notify = db.Column(db.Boolean, default=True)
    friend_notify = db.Column(db.Boolean, default=True)
    leaderboard_notify = db.Column(db.Boolean, default=True)

    # 배경음악 설정 여부
    bgm_enabled = db.Column(db.Boolean, default=True)