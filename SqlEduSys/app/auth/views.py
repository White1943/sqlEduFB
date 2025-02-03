from flask import jsonify, request, Blueprint
from flask_login import login_required
from sqlalchemy.sql.functions import current_user
from werkzeug.security import check_password_hash, generate_password_hash
from app import db
from . import auth_bp
# from . import auth
from app.utils.response import ApiResponse

from app.models import User


@auth_bp.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    username = data.get('username')
    password = data.get('password')
    user = User.query.filter_by(username=username).first()
    if user and check_password_hash(user.password_hash, password):

        return ApiResponse.success(data={"username": username, "is_admin":user.is_admin }, message="Login successful")
    else:
        return ApiResponse.error(message="Invalid username or password")

@auth_bp.route('/register', methods=['POST'])
def register():
    data = request.get_json()
    username = data.get('username')
    password = data.get('password')
    email = data.get('email')


    if not username or not email or not password:
        return jsonify({'message': 'Missing fields'}), 400

    hashed_password = generate_password_hash(password)

    new_user = User(username=username, email=email, password_hash=hashed_password)
    db.session.add(new_user)
    db.session.commit()
    return ApiResponse.success(message="User registered successfully")
    # return jsonify({'message': 'User registered successfully'}), 201


@login_required
@auth_bp.route('/logout')
def logout():
    print(current_user.id)































# app\auth\views.py