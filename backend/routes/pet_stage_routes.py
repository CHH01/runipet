from flask import Blueprint, jsonify
from models.pet_stage import PetStage

pet_stage_bp = Blueprint("pet_stage", __name__)

# ✅ 전체 성장 단계 조회
@pet_stage_bp.route("/pet-stages", methods=["GET"])
def get_all_pet_stages():
    stages = PetStage.query.all()
    result = []
    for stage in stages:
        result.append({
            "id": stage.id,
            "type": stage.type,
            "stage_name": stage.stage_name,
            "image_url": stage.image_url,
            "min_level": stage.min_level,
            "max_level": stage.max_level
        })
    return jsonify(result), 200

# ✅ 특정 성장 단계 ID로 조회
@pet_stage_bp.route("/pet-stages/<int:stage_id>", methods=["GET"])
def get_pet_stage_by_id(stage_id):
    stage = PetStage.query.get(stage_id)
    if not stage:
        return jsonify({"error": "해당 성장 단계 정보를 찾을 수 없습니다."}), 404

    return jsonify({
        "id": stage.id,
        "type": stage.type,
        "stage_name": stage.stage_name,
        "image_url": stage.image_url,
        "min_level": stage.min_level,
        "max_level": stage.max_level
    }), 200