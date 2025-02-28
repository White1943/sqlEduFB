from flask import Blueprint


schema_bp= Blueprint('schema', __name__)

# 导入视图文件，确保路由被注册到蓝本中
from . import views