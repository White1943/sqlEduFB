from flask import jsonify, request, current_app
from app import db
from app.models.nl_queries import NLQueries
from app.utils.response import ApiResponse
from . import statistics_bp
from sqlalchemy import func

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
