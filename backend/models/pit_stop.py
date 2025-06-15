from extensions import db

# 운동 중 지나치는 위치 정보 또는 코인 보상 거점 정보 저장
class PitStop(db.Model):
    __tablename__ = 'pit_stops'

    # 피트스탑 고유 ID
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)

    # 피트스탑 이름
    name = db.Column(db.String(100), nullable=False)

    # 위도, 경도 좌표
    latitude = db.Column(db.Float, nullable=False)
    longitude = db.Column(db.Float, nullable=False)

    # 설명 또는 메모
    description = db.Column(db.String(255), nullable=True)

    # 보상 타입 (예: COIN 등)
    reward_type = db.Column(db.String(50), nullable=True)

    # 보상 값 (예: 100, 아이템ID 등)
    reward_value = db.Column(db.String(100), nullable=True)