from datetime import datetime
from app import db

class NLQueries(db.Model):
    __tablename__ = 'nl_queries'
    
    id = db.Column(db.Integer, primary_key=True)
    query_text = db.Column(db.Text, nullable=False)
    generated_sql = db.Column(db.Text)
    involved_tables = db.Column(db.String(255))
    schema_ids = db.Column(db.String(255))  # 存储关联的schema id
    knowledge_point_id = db.Column(db.Integer, db.ForeignKey('knowledge_points.id'))
    status = db.Column(db.String(20), default='pending')  # pending, approved, rejected
    created_at = db.Column(db.DateTime, default=datetime.now)
    updated_at = db.Column(db.DateTime, default=datetime.now, onupdate=datetime.now)

    # 添加知识点关联
    knowledge_point = db.relationship('KnowledgePoint', backref='queries')

    def to_dict(self):
        return {
            'id': self.id,
            'query_text': self.query_text,
            'generated_sql': self.generated_sql,
            'involved_tables': self.involved_tables,
            'schema_ids': self.schema_ids,
            'knowledge_point_id': self.knowledge_point_id,
            'knowledge_point': self.knowledge_point.point_name if self.knowledge_point else None,
            'status': self.status,
            'created_at': self.created_at.strftime('%Y-%m-%d %H:%M:%S'),
            'updated_at': self.updated_at.strftime('%Y-%m-%d %H:%M:%S')
        }