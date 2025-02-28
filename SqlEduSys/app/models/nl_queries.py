from datetime import datetime
from app import db

class NLQueries(db.Model):
    __tablename__ = 'nl_queries'
    
    id = db.Column(db.Integer, primary_key=True)
    query_text = db.Column(db.Text, nullable=False)
    generated_sql = db.Column(db.Text)
    involved_tables = db.Column(db.Text, nullable=False)
    schema_ids = db.Column(db.Text, nullable=False)
    knowledge_point_id = db.Column(db.Integer, db.ForeignKey('knowledge_point.id'))
    status = db.Column(db.Enum('pending', 'approved', 'rejected'), default='pending')
    created_at = db.Column(db.DateTime, default=datetime.now)
    updated_at = db.Column(db.DateTime, default=datetime.now, onupdate=datetime.now)

    # 修改关联关系定义
    knowledge_point = db.relationship(
        'KnowledgePoint',
        backref=db.backref('queries', lazy='dynamic'),
        foreign_keys=[knowledge_point_id]
    )

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