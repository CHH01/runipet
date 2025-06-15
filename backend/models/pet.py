from extensions import db

# 사용자와 연결된 가상 펫의 정보를 저장하는 테이블
class Pet(db.Model):
    __tablename__ = 'pets'

    id = db.Column(db.Integer, primary_key=True, autoincrement=True, nullable=False)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), unique=True, nullable=False)

    # 펫의 별명 (사용자가 설정)
    nickname = db.Column(db.String(50), nullable=False)

    # 펫 종류 (예: 개, 고양이, 토끼 등)
    type = db.Column(db.String(30), nullable=False)

    # 펫의 현재 레벨 (기본 1레벨부터 시작)
    level = db.Column(db.Integer, default=1)

    # 펫의 누적 경험치
    exp = db.Column(db.Integer, default=0)

    # 현재 성장 단계 (pet_stages 테이블 참조)
    stage_id = db.Column(db.Integer, db.ForeignKey('pet_stages.id'))

    # 상태 메시지 ID (pet_status_messages 테이블 참조)
    status_message_id = db.Column(db.Integer, db.ForeignKey('pet_status_messages.id'))

    # 펫의 포만감 수치 (0 ~ 100%)
    fullness = db.Column(db.Integer, nullable=False, default=100)

    # 펫의 행복도 수치 (0 ~ 100%)
    happiness = db.Column(db.Integer, nullable=False, default=100)

    # 펫의 현재 건강 상태 (정상, 고열, 감기, 배탈)
    health_status = db.Column(
        db.Enum('NORMAL', 'FEVER', 'COLD', 'STOMACH'),
        nullable=False,
        default='NORMAL'
    )