from flask import request, jsonify, current_app
from . import experiment_bp
from app.models.experiments import Experiment
from app import db
from app.utils.response import ApiResponse
from sqlalchemy import or_

# 实验相关接口
@experiment_bp.route('/generate', methods=['POST'])
def generate_experiment():
    """生成实验"""
    try:
        data = request.json
        return ApiResponse.success(data)
    except Exception as e:
        current_app.logger.error(f"生成实验失败: {str(e)}")
        return ApiResponse.error(message="生成实验失败")