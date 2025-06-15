from extensions import db

# 사용자 간 친구(팔로우) 관계 저장
class SocialRelation(db.Model):
    __tablename__ = 'social_relations'

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)

    # 요청한 사용자
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)

    # 친구(상대) 사용자
    friend_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)

    # 관계 상태 (친구 요청:PENDING, 수락:ACCEPTED, 차단:BANNED)
    status = db.Column(db.Enum('PENDING', 'ACCEPTED', 'BANNED'), nullable=False)

    # 요청/수락/차단 시각
    updated_at = db.Column(db.DateTime, server_default=db.func.current_timestamp())