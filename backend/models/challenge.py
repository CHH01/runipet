from extensions import db

# 사용자별 도전과제(챌린지) 정보를 저장하는 테이블
class Challenge(db.Model):
    __tablename__ = 'challenges'

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)

    # 챌린지명
    title = db.Column(db.String(100), nullable=False)

    # 설명
    description = db.Column(db.String(255), nullable=True)

    # 현재 진행도
    progress = db.Column(db.Integer, default=0)

    # 목표값(예: 목표 걸음 수, 횟수 등)
    goal = db.Column(db.Integer, nullable=False)

    # 완료 여부
    completed = db.Column(db.Boolean, default=False)

    # 보상 코인
    reward = db.Column(db.Integer, default=0)

    # 보상 수령 여부
    reward_claimed = db.Column(db.Boolean, default=False)