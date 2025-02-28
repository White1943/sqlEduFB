from flask import Blueprint, request
from app import db
from app.models.schema import Sqls
from app.utils.response import ApiResponse
from . import schema_bp

@schema_bp.route('/upload', methods=['POST'])
def upload_sql():
    try:
        if 'file' not in request.files:
            return ApiResponse.error(message="No file part")
        
        file = request.files['file']
        if file.filename == '':
            return ApiResponse.error(message="No selected file")

        try:
            # 读取文件内容并指定编码
            file_content = file.read().decode('utf-8')
        except UnicodeDecodeError:
            return ApiResponse.error(message="文件编码格式不正确，请使用UTF-8编码")
        
        # 添加文件大小检查
        if len(file_content) > 5 * 1024 * 1024:  # 5MB 限制
            return ApiResponse.error(message="文件大小超过限制")

        # 创建新的SQL文件记录
        try:
            new_sql = Sqls(
                filename=file.filename,
                file_content=file_content
            )
            db.session.add(new_sql)
            db.session.commit()
        except Exception as db_error:
            print(f"数据库错误: {str(db_error)}")  # 添加日志
            db.session.rollback()
            return ApiResponse.error(message="数据库保存失败", status_code=500)

        return ApiResponse.success(message="File uploaded successfully")

    except Exception as e:
        print(f"上传处理错误: {str(e)}")  # 添加日志
        db.session.rollback()
        return ApiResponse.error(message=f"文件上传失败: {str(e)}", status_code=500)

@schema_bp.route('/files', methods=['GET'])
def get_sql_files():
    try:
        sql_files = Sqls.query.order_by(Sqls.created_at.desc()).all()
        data = [{
            'id': sql.id,
            'filename': sql.filename,
            'file_content': sql.file_content,
            'created_at': sql.created_at.strftime('%Y-%m-%d %H:%M:%S')
        } for sql in sql_files]
        
        return ApiResponse.success(data=data, message="Success")

    except Exception as e:
        return ApiResponse.error(message=str(e), status_code=500)

@schema_bp.route('/sql/<int:sql_id>', methods=['DELETE'])
def delete_sql(sql_id):
    try:
        sql = Sqls.query.get_or_404(sql_id)
        db.session.delete(sql)
        db.session.commit()
        return ApiResponse.success(message="SQL deleted successfully")
    except Exception as e:
        db.session.rollback()
        return ApiResponse.error(message=str(e), status_code=500)

@schema_bp.route('/sql/<int:sql_id>', methods=['PUT'])
def update_sql(sql_id):
    try:
        sql = Sqls.query.get_or_404(sql_id)
        data = request.get_json()
        
        if 'filename' in data:
            sql.filename = data['filename']
        if 'file_content' in data:
            sql.file_content = data['file_content']
            
        db.session.commit()
        return ApiResponse.success(message="SQL updated successfully")
    except Exception as e:
        db.session.rollback()
        return ApiResponse.error(message=str(e), status_code=500)