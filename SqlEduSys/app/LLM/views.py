from flask import jsonify, request, Blueprint, current_app
from app.LLM.services import generate_sql, validate_sql, generate_nl_queries_service, generate_sql_for_nl
from app.utils.response import ApiResponse
from app import db
from app.models.nl_queries import NLQueries
from app.models.schema import Sqls
from app.LLM.prompts import SCHEMA_TO_NL_PROMPT, NL_TO_SQL_PROMPT
from app.LLM.model import get_llm_response
from app.LLM import llm_bp

sql_stu_bp = Blueprint('sql_stu', __name__)

@sql_stu_bp.route('/generator', methods=['POST'])
def generate():
    try:
        data = request.get_json()
        # 假设data包含了用户输入的schema和其他信息
        query = data.get('query', '')
        queries = generate_sql(query)
        return ApiResponse.success(data=queries, message="SQL queries generated successfully.")
    except Exception as e:
        return ApiResponse.error(message=str(e))

@sql_stu_bp.route('/validator', methods=['POST'])
def validate():
    try:
        data = request.get_json()
        print(data)
        data = data.get('data', '')
        print(data)
        query_description = data.get('query_description', '')
        generated_sql = data.get('generated_sql', '')
        print(query_description)
        print(generated_sql)
        if not query_description or not generated_sql:
            return  ApiResponse.error(message='数据输入异常')#需要控制下前端打印异常信息

        validation_result =validate_sql  (query_description, generated_sql)
        print(validation_result)
        return ApiResponse.success(data=validation_result, message="调用验证")
    except Exception as e:
        return ApiResponse.error(message=str(e))

@llm_bp.route('/generate_nl_queries', methods=['POST'])
def generate_nl_queries():
    try:
        data = request.get_json()
        schema_ids = data.get('schema_ids', [])
        
        if not schema_ids:
            return ApiResponse.error(message="No schema IDs provided")

        # 获取所有选中的schema内容
        schemas = []
        for schema_id in schema_ids:
            schema = Sqls.query.get_or_404(schema_id)
            schemas.append(schema)

        # 合并所有schema内容
        combined_schema = "\n\n".join(schema.file_content for schema in schemas)
        
        # 生成查询描述
        queries = generate_nl_queries_service(combined_schema)
        if not queries:
            return ApiResponse.error(message="Failed to generate queries")
            
        # 保存到数据库（关联到第一个schema）
        primary_schema_id = schema_ids[0]
        for query in queries:
            # 解析查询文本和涉及的表
            table_start = query.find('[涉及表：') + 6
            table_end = query.find(']')
            if table_start > 5 and table_end > table_start:
                involved_tables = query[table_start:table_end].strip()
                query_text = query[table_end + 1:].strip()
                
                nl_query = NLQueries(
                    query_text=query_text,
                    involved_tables=involved_tables,
                    schema_id=primary_schema_id,
                    status='pending'
                )
                db.session.add(nl_query)
        
        db.session.commit()
        return ApiResponse.success(message="Generated NL queries successfully")
        
    except Exception as e:
        db.session.rollback()
        current_app.logger.error(f"Error generating queries: {str(e)}")
        return ApiResponse.error(message=str(e))

@llm_bp.route('/generate_sql/<int:query_id>', methods=['POST'])
def generate_sql_endpoint(query_id):
    try:
        # 获取查询记录
        query = NLQueries.query.get_or_404(query_id)
        schema = Sqls.query.get(query.schema_id)
        
        # 生成SQL
        generated_sql = generate_sql_for_nl(
            schema.file_content,
            query.query_text,
            query.involved_tables
        )
        
        if not generated_sql:
            return ApiResponse.error(message="Failed to generate SQL")
        
        # 更新数据库
        query.generated_sql = generated_sql
        query.status = 'approved'  # 或者根据需要设置其他状态
        db.session.commit()
        
        return ApiResponse.success(data={"sql": generated_sql})
        
    except Exception as e:
        print(f"Error generating SQL: {str(e)}")
        return ApiResponse.error(message=str(e))

# 获取查询列表
@llm_bp.route('/nl_queries/<int:schema_id>', methods=['GET'])
def get_nl_queries(schema_id):
    try:
        queries = NLQueries.query.filter_by(schema_id=schema_id).all()
        data = [{
            'id': q.id,
            'query_text': q.query_text,
            'involved_tables': q.involved_tables,
            'status': q.status,
            'generated_sql': q.generated_sql,
            'created_at': q.created_at.strftime('%Y-%m-%d %H:%M:%S')
        } for q in queries]
        return ApiResponse.success(data=data)
    except Exception as e:
        current_app.logger.error(f"Error fetching queries: {str(e)}")
        return ApiResponse.error(message=str(e))
