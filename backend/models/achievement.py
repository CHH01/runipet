from extensions import db

# 사용자가 달성 가능한 업적 정보를 저장하는 테이블
class Achievement(db.Model):
    __tablename__ = 'achievements'

    # 업적 고유 ID
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)

    # 업적 이름
    name = db.Column(db.String(100), nullable=False)

    # 업적 설명 (예: "하루 만보 걷기")
    description = db.Column(db.String(255), nullable=True)

    # 업적 달성 조건 (예: "10000걸음 달성", 프론트 요구 시 명확하게 추가)
    condition = db.Column(db.String(255), nullable=False)

    # 업적 이미지 URL (프론트에서 직접 이미지 주소를 받을 때 사용)
    image_url = db.Column(db.String(255), nullable=True)

    # 보상 타입 (예: "코인", "아이템", "경험치" 등)
    reward_type = db.Column(db.String(50), nullable=False)

    # 보상 값 (예: 코인 개수, 아이템ID, 경험치 수치 등)
    reward_value = db.Column(db.String(100), nullable=False)