from app.extensions import db
from datetime import datetime

class Sqls(db.Model):
    __tablename__ = 'sqls'
    
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    filename = db.Column(db.String(255), nullable=False)
    file_content = db.Column(db.Text, nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.now)
    
    def __repr__(self):
        return f'<Sqls {self.filename}>'