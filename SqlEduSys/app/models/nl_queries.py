from datetime import datetime
from app import db

class NLQueries(db.Model):
    __tablename__ = 'nl_queries'

    id = db.Column(db.Integer, primary_key=True)
    query_text = db.Column(db.Text, nullable=False)          
    involved_tables = db.Column(db.Text, nullable=False)       
    status = db.Column(db.Enum('pending', 'approved', 'rejected'), 
                      default='pending')                      
    generated_sql = db.Column(db.Text)                       
    schema_id = db.Column(db.Integer, db.ForeignKey('sqls.id'), 
                         nullable=False)                      
    created_at = db.Column(db.DateTime, default=datetime.utcnow) 
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, 
                          onupdate=datetime.utcnow)

    # 建立与Sqls表的关系
    schema = db.relationship('Sqls', backref=db.backref('nl_queries', lazy=True))

    def __repr__(self):
        return f'<NLQuery {self.id}: {self.query_text[:50]}...>'

    def to_dict(self):
        return {
            'id': self.id,
            'query_text': self.query_text,
            'involved_tables': self.involved_tables,
            'status': self.status,
            'generated_sql': self.generated_sql,
            'schema_id': self.schema_id,
            'created_at': self.created_at.strftime('%Y-%m-%d %H:%M:%S'),
            'updated_at': self.updated_at.strftime('%Y-%m-%d %H:%M:%S')
        } 