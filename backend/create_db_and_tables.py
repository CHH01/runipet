import sys
import os
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from flask import Flask
from models import db
from config.config import Config

def create_app():
    app = Flask(__name__)
    app.config.from_object(Config)
    db.init_app(app)
    return app

app = create_app()

with app.app_context():
    db.create_all()
    print("✅ 모든 테이블이 성공적으로 생성되었습니다.")