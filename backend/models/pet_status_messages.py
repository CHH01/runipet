from extensions import db

# 펫의 상태에 따라 출력할 메시지를 저장하는 테이블
class PetStatusMessage(db.Model):
    __tablename__ = 'pet_status_messages'

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)

    # 건강 상태 (예: NORMAL, FEVER, COLD, STOMACH)
    health_status = db.Column(
        db.Enum('NORMAL', 'FEVER', 'COLD', 'STOMACH'),
        nullable=False
    )

    # 포만감 상태 구간 (0~100)
    min_fullness = db.Column(db.Integer, nullable=False)
    max_fullness = db.Column(db.Integer, nullable=False)

    # 행복도 상태 구간 (0~100)
    min_happiness = db.Column(db.Integer, nullable=False)
    max_happiness = db.Column(db.Integer, nullable=False)

    # 출력할 상태 메시지
    message = db.Column(db.String(255), nullable=False)