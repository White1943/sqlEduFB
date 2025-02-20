from flask import Blueprint

llm_bp = Blueprint('llm', __name__)
sql_stu_bp = Blueprint('stu', __name__)
from . import views   