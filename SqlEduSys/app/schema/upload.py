from flask import Blueprint, request, jsonify
from app.extensions import db
from app.models.schema import Sqls  
from datetime import datetime

 
bp = Blueprint('schema_upload', __name__)

@bp.route('/upload', methods=['POST'])
def upload_sql():
    try:
        if 'file' not in request.files:
            return jsonify({'code': 400, 'msg': 'No file part'}), 400
        
        file = request.files['file']
        if file.filename == '':
            return jsonify({'code': 400, 'msg': 'No selected file'}), 400

        # 读取文件内容
        file_content = file.read().decode('utf-8')
        
        # 创建新的SQL文件记录
        new_sql = Sqls(
            filename=file.filename,
            file_content=file_content
        )
        
        db.session.add(new_sql)
        db.session.commit()

        return jsonify({
            'code': 200,
            'msg': 'File uploaded successfully'
        })

    except Exception as e:
        db.session.rollback()
        return jsonify({'code': 500, 'msg': str(e)}), 500

@bp.route('/files', methods=['GET'])
def get_sql_files():
    try:
        sql_files = Sqls.query.order_by(Sqls.created_at.desc()).all()
        return jsonify({
            'code': 200,
            'msg': 'success',
            'data': [{
                'id': sql.id,
                'filename': sql.filename,
                'file_content': sql.file_content,
                'created_at': sql.created_at.strftime('%Y-%m-%d %H:%M:%S')
            } for sql in sql_files]
        })

    except Exception as e:
        return jsonify({'code': 500, 'msg': str(e)}), 500