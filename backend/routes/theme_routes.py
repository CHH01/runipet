from flask import Blueprint, jsonify
from models.theme import Theme

theme_bp = Blueprint("theme", __name__)

# ✅ 전체 테마 조회
@theme_bp.route("/themes", methods=["GET"])
def get_all_themes():
    themes = Theme.query.all()
    result = []
    for t in themes:
        result.append({
            "id": t.id,
            "name": t.name,
            "description": t.description,
            "image_url": t.image_url
        })
    return jsonify(result), 200

# ✅ 특정 테마 조회
@theme_bp.route("/themes/<int:theme_id>", methods=["GET"])
def get_theme_by_id(theme_id):
    theme = Theme.query.get(theme_id)
    if not theme:
        return jsonify({"error": "해당 테마를 찾을 수 없습니다."}), 404

    return jsonify({
        "id": theme.id,
        "name": theme.name,
        "description": theme.description,
        "image_url": theme.image_url
    }), 200