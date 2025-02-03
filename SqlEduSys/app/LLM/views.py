from flask import jsonify, request, Blueprint
from app.LLM.services import generate_sql,validate_sql
from app.utils.response import ApiResponse

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
