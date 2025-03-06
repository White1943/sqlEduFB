from flask import jsonify, request, Blueprint, current_app
from app.LLM.services import generate_sql, validate_sql, generate_nl_queries_service, generate_sql_for_nl
from app.utils.response import ApiResponse
from app import db
from app.models.nl_queries import NLQueries
from app.models.schema import Sqls
from app.LLM.prompts import SCHEMA_TO_NL_PROMPT, NL_TO_SQL_PROMPT
from app.LLM.model import get_llm_response
from app.LLM import llm_bp
from app.models.knowledges import KnowledgePoint,KnowledgeCategory
from app.LLM import sql_stu_bp
import json

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
        points = data.get('points', [])
        
        if not schema_ids or not points:
            return ApiResponse.error(message="请选择数据库模式和知识点")
            
        schemas = Sqls.query.filter(Sqls.id.in_(schema_ids)).all()
        if not schemas:
            return ApiResponse.error(message="未找到选中的数据库模式")
            
        schema_info = "\n".join([schema.file_content for schema in schemas])  
        generated_queries = []
        
        for point in points:
            point_id = point.get('id')
            count = point.get('generateCount', 1)
            
            knowledge_point = KnowledgePoint.query.get(point_id)
            if not knowledge_point:
                continue
            
            # 获取已有的查询，用于避免重复
            print("Point ID:", point_id)
            print("Schema IDs:", schema_ids)
            existing_queries = (NLQueries.query
                .filter(
                    NLQueries.knowledge_point_id == point_id,
                    db.or_(*[
                        db.text(f"FIND_IN_SET('{schema_id}', schema_ids) > 0")
                        for schema_id in schema_ids
                    ])
                )
                .with_entities(NLQueries.query_text)
                .all())
            existing_queries = [q.query_text for q in existing_queries]
            print("Existing Queries:", existing_queries)
            
            # 修改提示词，强调生成不同的查询
            prompt = f"""
            基于以下数据库表结构：
            {schema_info}
            
            知识点信息：
            名称：{knowledge_point.point_name}
            描述：{knowledge_point.description}
            示例SQL：{knowledge_point.example_sql}
            
            已有的查询描述：
            {json.dumps(existing_queries, ensure_ascii=False, indent=2)}
            
            请生成 {count} 个新的、不同的查询描述，要求：
            1. 每个查询都必须与已有查询不同
            2. 每个查询之间的内容也要不同
            3. 查询的难度和复杂度可以有所变化
            4. 确保查询符合知识点的要求和特点
            5. 每个查询都要以 @[表名1,表名2] 格式开头，后面跟着具体的查询描述
            
            返回格式示例：
            @[表1,表2] 第一个查询描述
            @[表3] 第二个查询描述
            ...
            """
            
            query_text = get_llm_response(prompt)
            print("LLM Response:", query_text)
            if query_text:
                # 处理返回的多个查询
                queries = [q.strip() for q in query_text.split('\n') if q.strip() and q.strip().startswith('@[')]
                
                # 确保不重复
                seen_queries = set()
                for query in queries:
                    if query not in seen_queries and len(seen_queries) < count:
                        if query.startswith('@[') and ']' in query:
                            tables = query[2:query.find(']')].split(',')
                            description = query[query.find(']')+1:].strip()
                            
                            # 检查是否与已有查询重复
                            if description not in existing_queries:
                                new_query = NLQueries(
                                    query_text=description,
                                    involved_tables=",".join(tables),
                                    schema_ids=",".join(map(str, schema_ids)),
                                    knowledge_point_id=point_id,
                                    status='pending'
                                )
                                db.session.add(new_query)
                                generated_queries.append(new_query)
                                seen_queries.add(query)
        
        # 提交所有生成的查询
        if generated_queries:
            try:
                db.session.commit()
                return ApiResponse.success(
                    data={
                        'queries': [query.to_dict() for query in generated_queries]
                    },
                    message=f"成功生成 {len(generated_queries)} 条查询"
                )
            except Exception as e:
                db.session.rollback()
                current_app.logger.error(f"保存查询失败: {str(e)}")
                return ApiResponse.error(message=f"保存查询失败: {str(e)}")
        else:
            return ApiResponse.error(message="未能生成任何查询")
            
    except Exception as e:
        current_app.logger.error(f"生成查询失败: {str(e)}")
        return ApiResponse.error(message=str(e))

def extract_tables_from_schema(schemas, table_names):
    """从schema中提取实际的表名"""
    actual_tables = set()
    for schema in schemas:
        content = schema.file_content.lower()
        for table in table_names:
            table = table.strip().lower()
            if f"create table `{table}`" in content or f"create table {table}" in content:
                actual_tables.add(table)
    return list(actual_tables)
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
        table_schemas = {}
        
        for schema_id in schema_ids.split(','):
            schema = Sqls.query.get_or_404(int(schema_id))
            schema_contents.append(schema.file_content)
            
            for table in involved_tables.split(','):
                table = table.strip()
                if table.lower() in schema.file_content.lower():
                    table_schemas[table] = schema.file_content

        combined_schema = "\n\n".join(
            f"-- Schema {schema_id}:\n{content}" 
            for schema_id, content in table_schemas.items()
        )
        
        # 修改 prompt，要求只返回 SQL 语句
        prompt = f"""
        基于以下数据库表结构：
        {combined_schema}
        
        自然语言查询：{query_text}
        涉及的表：{involved_tables}
        
        请直接返回对应的 SQL 查询语句，不要包含任何解释、说明或其他额外信息。
        
        只需要返回一个有效的 SQL 语句，不要包含```sql ```,但出于格式展示美观，仍需保留换行
        """
        
        # 正确传递参数
        generated_sql = generate_sql_for_nl(prompt, query_text, involved_tables)
        
        if not generated_sql:
            return ApiResponse.error(message="Failed to generate SQL")
        
        # 更新数据库，状态保持为 pending
        query.generated_sql = generated_sql
        query.status = 'pending'  # 默认为 pending 状态
        db.session.commit()
        
        return ApiResponse.success(data={"sql": generated_sql})
        
    except Exception as e:
        print(f"Error generating SQL: {str(e)}")
        return ApiResponse.error(message=str(e))

# 获取查询列表
@llm_bp.route('/nl_queries', methods=['GET'])
def get_nl_queries():
    try:
        # 获取查询参数
        schema_ids = request.args.get('schema_ids', '').split(',')
        page = request.args.get('page', 1, type=int)
        page_size = request.args.get('page_size', 10, type=int)
        
        if not schema_ids or schema_ids[0] == '':
            return ApiResponse.success(data={'items': [], 'total': 0})
            
        # 构建查询条件
        conditions = []
        for schema_id in schema_ids:
            conditions.append(db.text(f"FIND_IN_SET('{schema_id}', schema_ids) > 0"))
            
        # 构建查询
        query = NLQueries.query.filter(db.or_(*conditions))
        
        # 获取总数
        total = query.count()
        
        # 分页
        paginated = query.order_by(NLQueries.id.desc()).paginate(
            page=page,
            per_page=page_size,
            error_out=False
        )
        
        return ApiResponse.success(data={
            'items': [item.to_dict() for item in paginated.items],
            'total': total
        })
        
    except Exception as e:
        current_app.logger.error(f"获取查询列表失败: {str(e)}")
        return ApiResponse.error(message=str(e))
@llm_bp.route('/nl_queries/<int:query_id>', methods=['DELETE'])
def delete_nl_query(query_id):
    try:
        query = NLQueries.query.get_or_404(query_id)
        db.session.delete(query)
        db.session.commit()
        return ApiResponse.success(message="查询已删除")
    except Exception as e:
        db.session.rollback()
        current_app.logger.error(f"删除查询失败: {str(e)}")
        return ApiResponse.error(message=str(e))

@llm_bp.route('/nl_queries/update', methods=['PUT'])
def update_nl_query():
    try:
        data = request.get_json()
        query_id = data.get('id')
        query = NLQueries.query.get_or_404(query_id)
        
        # 更新字段
        query.query_text = data.get('query_text', query.query_text)
        query.involved_tables = data.get('involved_tables', query.involved_tables)
        query.generated_sql = data.get('generated_sql', query.generated_sql)  # 添加 SQL 更新
        
        db.session.commit()
        return ApiResponse.success(message="查询已更新")
    except Exception as e:
        db.session.rollback()
        current_app.logger.error(f"更新查询失败: {str(e)}")
        return ApiResponse.error(message=str(e))

# 添加新的状态切换接口
@llm_bp.route('/nl_queries/<int:query_id>/toggle_status', methods=['POST'])
def toggle_query_status(query_id):
    try:
        query = NLQueries.query.get_or_404(query_id)
        query.status = 'approved' if query.status == 'pending' else 'pending'
        db.session.commit()
        return ApiResponse.success(message=f"状态已更新为 {query.status}")
    except Exception as e:
        db.session.rollback()
        return ApiResponse.error(message=str(e))

