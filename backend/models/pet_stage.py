from extensions import db

# 펫의 성장 단계를 저장하는 테이블
class PetStage(db.Model):
    __tablename__ = 'pet_stages'

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)

    # 펫 종류 (예: 개, 고양이, 토끼 등)
    type = db.Column(db.String(30), nullable=False)

    # 단계 이름 (예: 알, 부화, 유년기, 성체, 노년기)
    stage_name = db.Column(db.String(50), nullable=False)

    # 해당 단계에 필요한 최소 레벨
    min_level = db.Column(db.Integer, nullable=False)

    # 해당 단계의 최대 레벨 (프론트 요구에 따라 추가)
    max_level = db.Column(db.Integer, nullable=False)

    # 해당 단계 이미지(이미지 URL 추천)
    image_url = db.Column(db.String(255), nullable=False)