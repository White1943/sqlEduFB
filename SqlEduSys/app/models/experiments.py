from app import db
from datetime import datetime

class Experiment(db.Model):
    """实验报告模型"""
    __tablename__ = 'experiments'

    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(255), nullable=False, comment='实验标题')
    description = db.Column(db.Text, comment='实验描述')
    created_at = db.Column(db.DateTime, default=datetime.utcnow, comment='创建时间')
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, comment='更新时间')
    status = db.Column(db.String(20), default='draft', comment='状态：draft-草稿，published-已发布')

    # 实验内容（存储为JSON字符串）
    content = db.Column(db.JSON, comment='实验内容，包含查询等信息')
    
    # 关联的知识点（存储为JSON字符串，包含知识点ID和数量）
    knowledge_points = db.Column(db.JSON, comment='关联的知识点信息')
    
    # 实验报告具体内容
    report_content = db.Column(db.Text, comment='实验报告内容，支持富文本格式')
    objectives = db.Column(db.Text, comment='实验目标')
    requirements = db.Column(db.Text, comment='实验要求')
    steps = db.Column(db.Text, comment='实验步骤')
    notes = db.Column(db.Text, comment='实验注意事项')
    
    def to_dict(self):
        return {
            'id': self.id,
            'title': self.title,
            'description': self.description,
            'created_at': self.created_at.strftime('%Y-%m-%d %H:%M:%S'),
            'updated_at': self.updated_at.strftime('%Y-%m-%d %H:%M:%S'),
            'status': self.status,
            'content': self.content,
            'knowledge_points': self.knowledge_points,
            'report_content': self.report_content,
            'objectives': self.objectives,
            'requirements': self.requirements,
            'steps': self.steps,
            'notes': self.notes
        }

class ExperimentLog(db.Model):
    """实验操作日志"""
    __tablename__ = 'experiment_logs'

    id = db.Column(db.Integer, primary_key=True)
    experiment_id = db.Column(db.Integer, db.ForeignKey('experiments.id'), nullable=False)
    action = db.Column(db.String(50), nullable=False, comment='操作类型：create, update, publish等')
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    details = db.Column(db.JSON, comment='操作详情')

    def to_dict(self):
        return {
            'id': self.id,
            'experiment_id': self.experiment_id,
            'action': self.action,
            'created_at': self.created_at.strftime('%Y-%m-%d %H:%M:%S'),
            'details': self.details
        }
