import os
from dotenv import load_dotenv


load_dotenv()

class Config:
    # 从环境变量中获取数据库连接字符串和密钥
    SQLALCHEMY_DATABASE_URI = os.getenv('DATABASE_URL')
    SECRET_KEY = os.getenv('SECRET_KEY')  # 应用密钥
    SQLALCHEMY_TRACK_MODIFICATIONS = False  # 禁用 SQLAlchemy 对象修改追踪
