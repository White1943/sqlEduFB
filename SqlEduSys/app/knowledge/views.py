from flask import request, jsonify, current_app
from . import knowledge_bp
from app.models.knowledges import KnowledgeCategory, KnowledgePoint
from app import db
from app.utils.response import ApiResponse

# 知识点分类相关接口
@knowledge_bp.route('/categories', methods=['GET'])
def get_categories():
    """获取所有知识点分类"""
    try:
        categories = KnowledgeCategory.query.all()
        return ApiResponse.success(data=[category.to_dict() for category in categories])
    except Exception as e:
        current_app.logger.error(f"获取知识点分类失败: {str(e)}")
        return ApiResponse.error(message="获取知识点分类失败")

@knowledge_bp.route('/categories', methods=['POST'])
def add_category():
    """添加知识点分类"""
    try:
        data = request.get_json()
        category = KnowledgeCategory(
            category_name=data.get('category_name'),
            description=data.get('description')
        )
        db.session.add(category)
        db.session.commit()
        return ApiResponse.success(data=category.to_dict(), message="添加成功")
    except Exception as e:
        db.session.rollback()
        current_app.logger.error(f"添加知识点分类失败: {str(e)}")
        return ApiResponse.error(message="添加知识点分类失败")

@knowledge_bp.route('/categories/<int:category_id>', methods=['PUT'])
def update_category(category_id):
    """更新知识点分类"""
    try:
        category = KnowledgeCategory.query.get_or_404(category_id)
        data = request.get_json()
        category.category_name = data.get('category_name', category.category_name)
        category.description = data.get('description', category.description)
        db.session.commit()
        return ApiResponse.success(data=category.to_dict(), message="更新成功")
    except Exception as e:
        db.session.rollback()
        current_app.logger.error(f"更新知识点分类失败: {str(e)}")
        return ApiResponse.error(message="更新知识点分类失败")

@knowledge_bp.route('/categories/<int:category_id>', methods=['DELETE'])
def delete_category(category_id):
    """删除知识点分类"""
    try:
        category = KnowledgeCategory.query.get_or_404(category_id)
        db.session.delete(category)
        db.session.commit()
        return ApiResponse.success(message="删除成功")
    except Exception as e:
        db.session.rollback()
        current_app.logger.error(f"删除知识点分类失败: {str(e)}")
        return ApiResponse.error(message="删除知识点分类失败")

# 知识点相关接口
@knowledge_bp.route('/points', methods=['GET'])
def get_points():
    """获取所有知识点"""
    try:
        points = KnowledgePoint.query.all()
        return ApiResponse.success(data=[point.to_dict() for point in points])
    except Exception as e:
        current_app.logger.error(f"获取知识点失败: {str(e)}")
        return ApiResponse.error(message="获取知识点失败")

@knowledge_bp.route('/points', methods=['POST'])
def add_point():
    """添加知识点"""
    try:
        data = request.get_json()
        point = KnowledgePoint(
            category_id=data.get('category_id'),
            point_name=data.get('point_name'),
            description=data.get('description'),
            example_sql=data.get('example_sql'),
            explanation=data.get('explanation')
        )
        db.session.add(point)
        db.session.commit()
        return ApiResponse.success(data=point.to_dict(), message="添加成功")
    except Exception as e:
        db.session.rollback()
        current_app.logger.error(f"添加知识点失败: {str(e)}")
        return ApiResponse.error(message="添加知识点失败")

@knowledge_bp.route('/points/<int:point_id>', methods=['PUT'])
def update_point(point_id):
    """更新知识点"""
    try:
        point = KnowledgePoint.query.get_or_404(point_id)
        data = request.get_json()
        point.category_id = data.get('category_id', point.category_id)
        point.point_name = data.get('point_name', point.point_name)
        point.description = data.get('description', point.description)
        point.example_sql = data.get('example_sql', point.example_sql)
        point.explanation = data.get('explanation', point.explanation)
        db.session.commit()
        return ApiResponse.success(data=point.to_dict(), message="更新成功")
    except Exception as e:
        db.session.rollback()
        current_app.logger.error(f"更新知识点失败: {str(e)}")
        return ApiResponse.error(message="更新知识点失败")

@knowledge_bp.route('/points/<int:point_id>', methods=['DELETE'])
def delete_point(point_id):
    """删除知识点"""
    try:
        point = KnowledgePoint.query.get_or_404(point_id)
        db.session.delete(point)
        db.session.commit()
        return ApiResponse.success(message="删除成功")
    except Exception as e:
        db.session.rollback()
        current_app.logger.error(f"删除知识点失败: {str(e)}")
        return ApiResponse.error(message="删除知识点失败") 