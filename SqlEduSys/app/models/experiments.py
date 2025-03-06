from app import db
from datetime import datetime
from markdown import markdown
import bleach

class Experiment(db.Model):
    __tablename__ = 'experiments'

    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(255), nullable=False, comment='实验标题')
    description = db.Column(db.Text, comment='实验描述')
    created_at = db.Column(db.DateTime, default=db.func.current_timestamp(), comment='创建时间')
    updated_at = db.Column(db.DateTime, default=db.func.current_timestamp(), onupdate=db.func.current_timestamp(), comment='更新时间')
    status = db.Column(db.String(20), default='draft', comment='状态：draft-草稿，published-已发布')
    content = db.Column(db.JSON, default=None, comment='实验内容，包含查询等信息')
    knowledge_points = db.Column(db.JSON, default=None, comment='关联的知识点信息')
    report_content = db.Column(db.String(1000), comment='实验报告内容，支持富文本格式')
    objectives = db.Column(db.Text, comment='实验目标')
    requirements = db.Column(db.Text, comment='实验要求')
    steps = db.Column(db.Text, comment='实验步骤')
    notes = db.Column(db.Text, comment='实验注意事项')
    version = db.Column(db.Enum('teacher', 'student'), default='student', comment='实验报告版本：teacher-教师版，student-学生版')
    points_category_id = db.Column(db.Integer, comment='知识点分类ID')

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

    @staticmethod
    def on_changed_report(target, value, oldvalue, initiator):
        if value == oldvalue:  # 如果值没有变化，则不处理
            return
        allowed_tags = ['a', 'abbr', 'acronym', 'b', 'blockquote', 'code',
                        'em', 'i', 'li', 'ol', 'pre', 'strong', 'ul',
                        'h1', 'h2', 'h3', 'p']
        target.report_content = bleach.linkify(bleach.clean(
            markdown(value, output_format='html'),
            tags=allowed_tags, strip=True))






