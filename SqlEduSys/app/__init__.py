from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from app.config import Config
from flask_cors import CORS

# 创建db实例但不初始化
db = SQLAlchemy()
migrate = Migrate()

def create_app(config_class=Config):
    app = Flask(__name__)
    app.config.from_object(config_class)
    # 设置测试模式
    # app.config['TESTING'] = True  # 临时启用测试模式
    # 配置CORS，允许所有路由
    CORS(app, resources={
        r"/*": {
            "origins": ["http://localhost:5173"],  
            "methods": ["GET", "POST", "PUT", "DELETE", "OPTIONS"],  # 允许的方法
            "allow_headers": ["Content-Type", "Authorization"],  # 允许的请求头
            "supports_credentials": True  # 允许携带凭证
        }
    })
    # 初始化扩展
    db.init_app(app)
    migrate.init_app(app, db)

    # 注册蓝图
    from .auth import auth_bp
    app.register_blueprint(auth_bp, url_prefix='/auth')

    from .schema import schema_bp
    app.register_blueprint(schema_bp, url_prefix='/schema')

    from .LLM import llm_bp
    app.register_blueprint(llm_bp, url_prefix='/llm')
    from app.chat.views import chat_bp
    app.register_blueprint(chat_bp, url_prefix='/chat')
    from .knowledge import knowledge_bp
    app.register_blueprint(knowledge_bp, url_prefix='/knowledge')
    return app
# app\__init__.py