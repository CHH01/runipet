from extensions import db
from datetime import datetime

class Inquiry(db.Model):
    __tablename__ = 'inquiries'

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)

    # 문의한 사용자
    user_id = db.Column(db.Integer, db.ForeignKey("users.id"), nullable=False)

    # 문의 제목/내용
    title = db.Column(db.String(100), nullable=False)
    content = db.Column(db.Text, nullable=False)

    # 문의 등록 시각
    created_at = db.Column(db.DateTime, default=datetime.utcnow)

    # 답변 내용 (nullable)
    reply = db.Column(db.Text, nullable=True)

    # 답변 등록 시각
    replied_at = db.Column(db.DateTime, nullable=True)

    # 답변 여부 (자동 처리 용이, reply 존재 여부와 별도)
    is_answered = db.Column(db.Boolean, default=False)