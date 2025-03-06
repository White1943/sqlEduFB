from datetime import datetime

from app.LLM.model import get_llm_response
from app.LLM.prompts import generate_prompt
from flask import request, jsonify, current_app, Response
from . import experiment_bp
from app.models.experiments import Experiment
from app import db
from app.utils.response import ApiResponse
from sqlalchemy import or_
import json
from app.models.nl_queries import NLQueries
from app.models.schema import Sqls
from app.models.knowledges import KnowledgePoint
from app.LLM.services import get_experiment_report_response
import sys
sys.setrecursionlimit(100000)

@experiment_bp.route('/generate', methods=['POST'])
def generate_experiment():
    """生成实验报告"""
    try:
        data = request.get_json()
        schema_ids = data.get('schema_ids', [])
        experimentCount = data.get('count', 1)  # 获取生成数量
        points = data.get('points', [])
        version = data.get('version', 'student')  # 获取版本信息
        print(points)
        # print(count)
        # print(schema_ids)
        print(data)

        if not schema_ids or not points:
            return ApiResponse.error(message="请选择数据库模式和知识点")
        schemas = Sqls.query.filter(Sqls.id.in_(schema_ids)).all()
        if not schemas:
            return ApiResponse.error(message="未找到选中的数据库模式")

        schema_info = "\n".join([schema.file_content for schema in schemas])  
        generated_queries = []
        nl_queries = []
        for point in points:
            point_id = point.get('id')
            generateCount = point.get('generateCount', 1)
            
            knowledge_points = KnowledgePoint.query.get(point_id)
            if not knowledge_points: 
                print("知识点不存在")
                continue
            print(knowledge_points.point_name,point_id)

 
            nl_query= NLQueries.query.filter(
                NLQueries.knowledge_point_id == knowledge_points.id,
                NLQueries.status == 'approved',
                db.or_(*[db.text(f"FIND_IN_SET('{schema_id}', schema_ids) > 0") for schema_id in schema_ids])
            ).all()   
            nl_queries.extend(nl_query)
        
        dataExperiment   = ""
        for query in nl_queries:
            dataExperiment += f"<strong>题目:</strong> {query.query_text}<br><strong>答案:</strong> {query.generated_sql}<br><br>"
        # print(dataExperiment)
        schemas = Sqls.query.filter(Sqls.id.in_(schema_ids)).all()
        # print("schemas ",schemas)

        schema_info = "\n".join([schema.file_content for schema in schemas])
        # print( "schema_info" ,schema_info)
        print("schema_info is ok")
        # 下面的代码执行有问题
        for i in range(experimentCount):

            print("轮次",i)

        # 不是为每个知识点生成一个实验报告，而是一个实验报告就得包含所有前端传入的知识点，相应数量为generateCount


            # 生成教师版报告
            teacher_prompt = generate_prompt(schema_info, points, 'teacher', dataExperiment)
            teacher_response = get_experiment_report_response(teacher_prompt)

            if teacher_response is None:
                return ApiResponse.error(message="教师版报告生成失败")

            current_app.logger.info(f"教师版报告内容长度: {len(teacher_response)}")
            # current_app.logger.info(f"准备插入的内容: {schema_ids}, {points}")
            # current_app.logger.info(f"教师版报告内容: {teacher_response.strip()}")
            # print(datetime.now().strftime('%Y-%m-%d-%H-%M-%S'))
            # 创建教师版实验记录
            # print(teacher_response.strip())
            print("打印教师实验内容")
            try:
                teacher_experiment = Experiment(
                    title=f"教师版实验报告 - {datetime.now().strftime('%Y-%m-%d-%H-%M-%S')}",
                    description="根据选中的数据库模式生成的教师版实验报告",
                    notes=json.dumps({"schema_ids": schema_ids, "points": points}),
                    report_content=teacher_response.strip(),
                    version='teacher',
                    points_category_id=None
                )
                db.session.add(teacher_experiment)
                db.session.commit()  # 提交事务
                current_app.logger.info("教师版实验记录插入成功")
            except Exception as e:
                current_app.logger.error(f"插入教师版实验记录失败: {str(e)}")
                return ApiResponse.error(message="插入教师版实验记录失败")

            # 生成学生版报告
            student_prompt = generate_prompt(schema_info, points, 'student', dataExperiment)
            student_response = get_experiment_report_response(student_prompt)

            if student_response is None:

                return ApiResponse.error(message="学生版报告生成失败")

            # 在插入之前检查内容长度
            current_app.logger.info(f"学生版报告内容长度: {len(student_response)}")

            # 创建学生版实验记录
            try:
                student_experiment = Experiment(
                    title=f"学生版实验报告 -   ",
                    description="根据选中的数据库模式生成的学生版实验报告",
                    content=json.dumps({"schema_ids": schema_ids, "points": points}),
                    report_content=student_response.strip(),
                    version='student',
                    points_category_id=None
                )
                db.session.add(student_experiment)
                db.session.commit()
                current_app.logger.info("学生版实验记录插入成功")
            except Exception as e:
                current_app.logger.error(f"插入学生版实验记录失败: {str(e)}")
                return ApiResponse.error(message="插入学生版实验记录失败")
         
        return ApiResponse.success(message="实验报告生成成功", data={"message": "所有实验报告已成功生成"})
    except Exception as e:
        current_app.logger.error(f"处理请求时发生错误: {str(e)}")
        return ApiResponse.error(message="处理请求时发生错误")

 

@experiment_bp.route('/download/<int:experiment_id>', methods=['GET'])
def download_experiment(experiment_id):
    """下载实验报告"""
    experiment = Experiment.query.get_or_404(experiment_id)
    return Response(experiment.report_content, mimetype='application/vnd.openxmlformats-officedocument.wordprocessingml.document', headers={"Content-Disposition": f"attachment;filename=实验报告_{experiment_id}.doc"})

@experiment_bp.route('/points/category/<int:category_id>', methods=['GET'])
def get_experiment_by_points_category(category_id):
    """获取实验报告"""
    experiments = Experiment.query.filter(Experiment.points_category_id == category_id).all()
    return ApiResponse.success(data=experiments)

@experiment_bp.route('/queries', methods=['GET'])
def get_experiments():
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
        query = Experiment.query.filter(db.or_(*conditions))
        
        # 获取总数
        total = query.count()
        
        # 分页
        paginated = query.order_by(Experiment.id.desc()).paginate(
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