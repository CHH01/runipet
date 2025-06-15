from extensions import db

# 사용자가 특정 피트스탑을 방문해 코인을 획득한 이력을 저장
class PitStopReward(db.Model):
    __tablename__ = 'pit_stop_rewards'

    # 보상 고유 ID
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)

    # 사용자 ID
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)

    # 피트스탑 ID
    pit_stop_id = db.Column(db.Integer, db.ForeignKey('pit_stops.id'), nullable=False)

    # 보상 수령 일시
    claimed_at = db.Column(db.DateTime, server_default=db.func.current_timestamp())