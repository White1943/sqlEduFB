from app import db
from datetime import datetime

class KnowledgeCategory(db.Model):
    __tablename__ = 'knowledge_category'
    
    id = db.Column(db.Integer, primary_key=True)
    category_name = db.Column(db.String(255), nullable=False)
    description = db.Column(db.Text)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    # 建立与知识点的关系
    points = db.relationship('KnowledgePoint', backref='category', lazy='dynamic')

    def to_dict(self):
        return {
            'id': self.id,
            'category_name': self.category_name,
            'description': self.description,
            'created_at': self.created_at.isoformat(),
            'updated_at': self.updated_at.isoformat()
        }

class KnowledgePoint(db.Model):
    __tablename__ = 'knowledge_point'
    
    id = db.Column(db.Integer, primary_key=True)
    category_id = db.Column(db.Integer, db.ForeignKey('knowledge_category.id'), nullable=False)
    point_name = db.Column(db.String(255), nullable=False)
    description = db.Column(db.Text)
    example_sql = db.Column(db.Text)
    explanation = db.Column(db.Text)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    def to_dict(self):
        return {
            'id': self.id,
            'category_id': self.category_id,
            'category_name': self.category.category_name,
            'point_name': self.point_name,
            'description': self.description,
            'example_sql': self.example_sql,
            'explanation': self.explanation,
            'created_at': self.created_at.isoformat(),
            'updated_at': self.updated_at.isoformat()
        } 