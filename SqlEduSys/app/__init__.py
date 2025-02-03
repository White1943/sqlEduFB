from flask import Flask
from flask_cors import CORS
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate

from .LLM.views import sql_stu_bp
from .config import Config
from .schema.upload import bp as schema_upload_bp
db = SQLAlchemy()
migrate = Migrate()

def create_app():
    app = Flask(__name__)

    app.config.from_object(Config)  # 从 Config 类中加载配置
    CORS(app, resources={r"/*": {"origins": "http://localhost:5173"}})

    db.init_app(app)
    migrate.init_app(app, db)
    from .auth import auth_bp
    app.register_blueprint(auth_bp, url_prefix='/auth')
    app.register_blueprint(sql_stu_bp, url_prefix='/sql')
    app.register_blueprint(schema_upload_bp, url_prefix='/schema')

    return app
# app\__init__.py