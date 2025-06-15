from extensions import db

# 사용자가 보유하고 있는 아이템 정보를 저장하는 테이블 (N:M 관계)
class UserItem(db.Model):
    __tablename__ = 'user_items'

    # 고유 ID (복합키 대신 단일 기본키 사용)
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)

    # 사용자 ID
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)

    # 아이템 ID
    item_id = db.Column(db.Integer, db.ForeignKey('items.id'), nullable=False)

    # 현재 보유 수량
    quantity = db.Column(db.Integer, default=0, nullable=False)