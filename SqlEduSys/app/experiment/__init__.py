from flask import Blueprint

experiment_bp = Blueprint('experiment', __name__)

from . import views 