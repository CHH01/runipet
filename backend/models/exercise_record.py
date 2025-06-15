from extensions import db

# 사용자의 운동 기록을 저장하는 테이블
class ExerciseRecord(db.Model):
    __tablename__ = 'exercise_records'

    # 운동 기록 고유 ID
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)

    # 사용자 ID (users 테이블 외래키)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)

    # 운동 시작 시각
    start_time = db.Column(db.DateTime, nullable=False)

    # 운동 종료 시각
    end_time = db.Column(db.DateTime, nullable=False)

    # 운동 거리 (km 단위, 실수)
    distance = db.Column(db.Float, nullable=False)

    # 운동 중 소모한 칼로리 (kcal)
    calories = db.Column(db.Float, nullable=False)

    # 운동 중 총 걸음 수
    steps = db.Column(db.Integer, nullable=False)

    # 운동 시 데려간 펫 ID (pets 테이블 외래키, 선택적)
    pet_id = db.Column(db.Integer, db.ForeignKey('pets.id'), nullable=True)

    # 비정상 기록 여부 (예: 치팅 여부 판별 시 사용)
    is_anomaly = db.Column(db.Boolean, default=False)