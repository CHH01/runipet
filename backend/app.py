from flask import Flask
from flask_cors import CORS
from extensions import db, jwt
from config.config import Config

# ✅ Blueprint 라우트 임포트
from routes.auth_routes import auth_bp
from routes.exercise_routes import exercise_bp
from routes.pet_routes import pet_bp
from routes.friend_routes import friend_bp
from routes.inquiry_routes import inquiry_bp
from routes.challenge_routes import challenge_bp
from routes.leaderboard_routes import leaderboard_bp
from routes.pitstop_routes import pitstop_bp
from routes.report_routes import report_bp
from routes.shop_routes import shop_bp
from routes.theme_routes import theme_bp
from routes.user_item_routes import user_item_bp
from routes.anomaly_routes import anomaly_bp
from routes.achievement_routes import achievement_bp
from routes.pet_stage_routes import pet_stage_bp
from routes.pet_status_message_routes import pet_status_message_bp
from routes.user_settings_routes import user_settings_bp
from routes.notice_routes import notice_bp

app = Flask(__name__)
app.config.from_object(Config)

CORS(app)
db.init_app(app)
jwt.init_app(app)

# ✅ 모든 라우트 등록
app.register_blueprint(auth_bp)
app.register_blueprint(exercise_bp)
app.register_blueprint(pet_bp)
app.register_blueprint(friend_bp)
app.register_blueprint(inquiry_bp)
app.register_blueprint(challenge_bp)
app.register_blueprint(leaderboard_bp)
app.register_blueprint(pitstop_bp)
app.register_blueprint(report_bp)
app.register_blueprint(shop_bp)
app.register_blueprint(theme_bp)
app.register_blueprint(user_item_bp)
app.register_blueprint(anomaly_bp)
app.register_blueprint(achievement_bp)
app.register_blueprint(pet_stage_bp)
app.register_blueprint(pet_status_message_bp)
app.register_blueprint(user_settings_bp)
app.register_blueprint(notice_bp)

@app.route("/")
def index():
    return "Flask Server Running"

@app.route("/ping")
def ping():
    return "pong", 200

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000, debug=True)