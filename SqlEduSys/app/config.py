import os
from datetime import timedelta
from dotenv import load_dotenv


load_dotenv()

class Config:
    # 从环境变量中获取数据库连接字符串和密钥
    SQLALCHEMY_DATABASE_URI = os.getenv('DATABASE_URL')
    SECRET_KEY = os.getenv('SECRET_KEY')  # 应用密钥
    SQLALCHEMY_TRACK_MODIFICATIONS = False  # 禁用 SQLAlchemy 对象修改追踪
 
    CORS_ORIGINS = os.getenv('CORS_ORIGINS')
 
    
    # LLM配置
    LLM_API_URL = os.getenv('LLM_API_URL', 
        'http://localhost:8000/v1/chat/completions')
    LLM_API_KEY = os.getenv('LLM_API_KEY')
    
    # 文件上传配置
    MAX_CONTENT_LENGTH = 5 * 1024 * 1024  # 5MB
    UPLOAD_FOLDER = os.getenv('UPLOAD_FOLDER', 'uploads')
    
    # 日志配置
    LOG_LEVEL = os.getenv('LOG_LEVEL', 'INFO')

class DevelopmentConfig(Config):
    DEBUG = True
    
class ProductionConfig(Config):
    DEBUG = False
    
class TestingConfig(Config):
    TESTING = True
    SQLALCHEMY_DATABASE_URI = os.getenv('TEST_DATABASE_URL', 
        'mysql+pymysql://root:123456@localhost:3306/sqledu_test') 