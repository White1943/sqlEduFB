from datetime import datetime
from app import db

class NLQueries(db.Model):
    __tablename__ = 'nl_queries'

    id = db.Column(db.Integer, primary_key=True)
    query_text = db.Column(db.Text, nullable=False)
    involved_tables = db.Column(db.Text, nullable=False)  # 表名列表，逗号分隔
    schema_ids = db.Column(db.Text, nullable=False)  # schema_id列表，逗号分隔
    status = db.Column(db.Enum('pending', 'approved', 'rejected'), default='pending')
    generated_sql = db.Column(db.Text)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    def __repr__(self):
        return f'<NLQuery {self.id}: {self.query_text[:50]}...>'

    def to_dict(self):
        return {
            'id': self.id,
            'query_text': self.query_text,
            'involved_tables': self.involved_tables,
            'schema_ids': self.schema_ids,
            'status': self.status,
            'generated_sql': self.generated_sql,
            'created_at': self.created_at.strftime('%Y-%m-%d %H:%M:%S'),
            'updated_at': self.updated_at.strftime('%Y-%m-%d %H:%M:%S')
        } 