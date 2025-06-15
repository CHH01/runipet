from extensions import db

# 사용자가 선택 가능한 테마 정보를 저장하는 테이블
class Theme(db.Model):
    __tablename__ = 'themes'

    # 테마 고유 ID
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)

    # 테마 이름 (예: 봄, 여름, 가을, 겨울)
    name = db.Column(db.String(50), nullable=False)

    # 테마 설명 (선택적)
    description = db.Column(db.String(255), nullable=True)

    # 테마 이미지 URL (이미지 경로 저장)
    image_url = db.Column(db.String(255), nullable=True)