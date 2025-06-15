from extensions import db

# 상점에서 판매되는 모든 아이템 목록을 저장하는 테이블
class Item(db.Model):
    __tablename__ = 'items'

    # 아이템 고유 ID
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)

    # 아이템 이름
    name = db.Column(db.String(100), nullable=False)

    # 아이템 설명
    description = db.Column(db.String(255), nullable=True)

    # 아이템 종류 (예: 음식, 용품, 약 등)
    category = db.Column(
        db.Enum('FOOD', 'TOOL', 'MEDICINE'),
        nullable=False
    )

    # 아이템 이미지 (바이너리 저장)
    image = db.Column(db.LargeBinary, nullable=True)

    # 사용 시 회복 또는 효과 수치 (예: 포만감 20 회복)
    effect_value = db.Column(db.Integer, nullable=True)