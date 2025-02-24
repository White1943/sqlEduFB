from flask import jsonify, request, current_app
from app import db
from app.models.nl_queries import NLQueries
from app.utils.response import ApiResponse
from . import statistics_bp
from sqlalchemy import func
from app.models.knowledges import KnowledgePoint
from app.models.knowledges import KnowledgeCategory

@statistics_bp.route('/statistics', methods=['GET'])
def get_statistics():
    """获取生成的自然语言描述和 SQL 的统计信息"""
    try:
        # 统计生成的自然语言描述语句数量
        total_nl_queries = NLQueries.query.count()
        
        # 统计生成的 SQL 的数量
        total_generated_sql = NLQueries.query.filter(NLQueries.generated_sql.isnot(None)).count()
        
        # 按天统计生成的自然语言描述数量
        daily_nl_queries = (
            db.session.query(
                func.date(NLQueries.created_at).label('date'),
                func.count(NLQueries.id).label('count')
            )
            .group_by(func.date(NLQueries.created_at))
            .all()
        )

        # 将结果转换为字典格式
        daily_nl_queries_data = {str(date): count for date, count in daily_nl_queries}

        return ApiResponse.success(data={
            'total_nl_queries': total_nl_queries,
            'total_generated_sql': total_generated_sql,
            'daily_nl_queries': daily_nl_queries_data
        })
    except Exception as e:
        current_app.logger.error(f"获取统计信息失败: {str(e)}")
        return ApiResponse.error(message="获取统计信息失败")
@statistics_bp.route('/queries/<date>', methods=['GET'])
def get_queries_by_date(date):
    """获取指定日期的自然语言描述语句"""
    print(date)
    try:
        queries = NLQueries.query.filter(func.date(NLQueries.created_at) == date).all()
        
        # 将查询结果转换为字典格式
        queries_data = [query.to_dict() for query in queries]  # 假设 NLQueries 有 to_dict 方法
        
        return ApiResponse.success(data=queries_data)
    except Exception as e:
        current_app.logger.error(f'获取查询语句失败: {str(e)}')
        return ApiResponse.error(message="获取查询语句失败")

@statistics_bp.route('/categories', methods=['GET'])
def get_categories_statistics():
    """获取每个知识点大类的自然语言描述语句数量"""
    try:
        categories_stats = (
            db.session.query(
                KnowledgeCategory.id.label('category_id'),  
                KnowledgeCategory.category_name.label('category_name'),  # 添加类别名称
                func.count(NLQueries.id).label('count')
            )
            .join(KnowledgePoint, KnowledgePoint.id == NLQueries.knowledge_point_id)
            .join(KnowledgeCategory, KnowledgeCategory.id == KnowledgePoint.category_id)
            .group_by(KnowledgeCategory.id, KnowledgeCategory.category_name)  # 需要同时按ID和名称分组
            .all()
        )

        # 将结果转换为包含类别名称的字典格式
        categories_data = [{
            'id': category_id,
            'name': category_name,
            'count': count
        } for category_id, category_name, count in categories_stats]

        return ApiResponse.success(data=categories_data)
    except Exception as e:
        current_app.logger.error(f"获取大类统计信息失败: {str(e)}")
        return ApiResponse.error(message="获取大类统计信息失败")

