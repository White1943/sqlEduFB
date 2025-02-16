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

        # 获取所有选中的schema
        schemas = [Sqls.query.get_or_404(schema_id) for schema_id in schema_ids]
        
        # 生成查询描述
        queries = generate_nl_queries_service(schemas)
        if not queries:
            return ApiResponse.error(message="Failed to generate queries")
            
        # 保存到数据库
        for query in queries:
            nl_query = NLQueries(
                query_text=query['query_text'],
                involved_tables=query['involved_tables'],
                schema_ids=','.join(map(str, schema_ids)),  # 存储所有相关的schema_ids
                status='pending'
            )
            db.session.add(nl_query)
        
        db.session.commit()
        return ApiResponse.success(message="Generated NL queries successfully")
        
    except Exception as e:
        db.session.rollback()
        print(f"Error generating queries: {str(e)}")
        return ApiResponse.error(message=str(e))

@llm_bp.route('/generate_sql', methods=['POST'])
def generate_sql_endpoint():
    try:
        data = request.get_json()
        query_id = data.get('query_id')
        query_text = data.get('query_text')
        involved_tables = data.get('involved_tables')
        schema_ids = data.get('schema_ids')

        if not all([query_id, query_text, involved_tables, schema_ids]):
            return ApiResponse.error(message="Missing required parameters")

        # 获取查询记录
        query = NLQueries.query.get_or_404(query_id)
        
        # 获取所有相关的schema内容
        schema_contents = []
        table_schemas = {}  # 用于存储每个表对应的schema内容
        
        for schema_id in schema_ids.split(','):
            schema = Sqls.query.get_or_404(int(schema_id))
            schema_contents.append(schema.file_content)
            
            # 解析schema内容，找到涉及的表的结构
            for table in involved_tables.split(','):
                table = table.strip()
                # 在schema内容中查找表结构
                if table.lower() in schema.file_content.lower():
                    table_schemas[table] = schema.file_content

        # 合并所有相关的schema内容
        combined_schema = "\n\n".join(
            f"-- Schema {schema_id}:\n{content}" 
            for schema_id, content in table_schemas.items()
        )
        
        # 生成SQL
        generated_sql = generate_sql_for_nl(
            combined_schema,
            query_text,
            involved_tables
        )
        
        if not generated_sql:
            return ApiResponse.error(message="Failed to generate SQL")
        
        # 更新数据库
        query.generated_sql = generated_sql
        query.status = 'approved'
        db.session.commit()
        
        return ApiResponse.success(data={"sql": generated_sql})
        
    except Exception as e:
        print(f"Error generating SQL: {str(e)}")
        return ApiResponse.error(message=str(e))

# 获取查询列表
@llm_bp.route('/nl_queries/<int:schema_id>', methods=['GET'])
def get_nl_queries(schema_id):
    try:
        # 使用 FIND_IN_SET 或正则表达式来精确匹配逗号分隔的ID
        queries = NLQueries.query.filter(
            db.text(f"FIND_IN_SET('{schema_id}', schema_ids) > 0")
        ).all()
        
        # 或者使用正则表达式匹配
        # pattern = f"(^{schema_id}$|^{schema_id},|,{schema_id}$|,{schema_id},)"
        # queries = NLQueries.query.filter(
        #     NLQueries.schema_ids.regexp(pattern)
        # ).all()
        
        data = [query.to_dict() for query in queries]
        return ApiResponse.success(data=data)
    except Exception as e:
        print(f"Error fetching queries: {str(e)}")
        return ApiResponse.error(message=str(e))
