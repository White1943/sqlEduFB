# app/auth/__init__.py

from flask import Blueprint

# 创建身份验证蓝本，命名为 'auth'
auth_bp = Blueprint('auth', __name__)

# 导入视图文件，确保路由被注册到蓝本中
from . import views
# app\auth\__init__.py