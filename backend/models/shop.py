from extensions import db

# 상점에서 판매 중인 아이템 목록과 가격을 저장하는 테이블
class Shop(db.Model):
    __tablename__ = 'shop'

    # 상점 아이템 고유 ID
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)

    # 아이템 ID (items 테이블 참조)
    item_id = db.Column(db.Integer, db.ForeignKey('items.id'), nullable=False)

    # 판매 가격 (코인 기준)
    price = db.Column(db.Integer, nullable=False)

    # 현재 판매 중 여부
    is_available = db.Column(db.Boolean, default=True)