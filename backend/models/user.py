from extensions import db

class User(db.Model):
    __tablename__ = 'users'

    # 사용자 고유 ID (PK)
    id = db.Column(db.Integer, primary_key=True, autoincrement=True, nullable=False)

    # 로그인에 사용되는 고유 아이디
    username = db.Column(db.String(50), unique=True, nullable=False)

    # 비밀번호 해시값 (프론트에서 "password"로 받고 DB에는 hash로 저장)
    password_hash = db.Column(db.String(255), nullable=False)

    # 이메일 (계정 인증/복구용)
    email = db.Column(db.String(255), unique=True, nullable=False)

    # 앱 내 닉네임
    nickname = db.Column(db.String(50), nullable=False)

    # 프로필 이미지 (이미지 주소/경로 또는 바이너리)
    profile_image = db.Column(db.String(255), nullable=True)  # 바이너리 대신 이미지 경로 추천

    # 보유 코인 수
    coins = db.Column(db.Integer, default=0)

    # 사용자 권한 (일반 사용자 또는 관리자)
    role = db.Column(db.Enum('USER', 'ADMIN'), nullable=False, default='USER')

    # 외부 서비스 연동 여부
    is_linked_external = db.Column(db.Boolean, default=False)

    # 가입 시각
    registered_at = db.Column(db.DateTime, server_default=db.func.current_timestamp())