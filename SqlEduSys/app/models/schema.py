from app  import db
from datetime import datetime

class Sqls(db.Model):
    __tablename__ = 'sqls'
    
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    filename = db.Column(db.String(255), nullable=False)
    file_content = db.Column(db.Text, nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.now)
    
    def __repr__(self):
        return (f'<S'
                f'qls {self.filename}>')

    def to_dict(self):
        return {
            'id': self.id,
            'filename': self.filename,
            'file_content': self.file_content,
            'created_at': self.created_at.strftime('%Y-%m-%d %H:%M:%S'),
            'updated_at': self.updated_at.strftime('%Y-%m-%d %H:%M:%S')
        }