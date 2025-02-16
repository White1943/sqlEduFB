from flask import Blueprint, request, jsonify, current_app, g
from app.models.chat import ChatModel, ChatHistory
from app.utils.response import ApiResponse
from app import db
from datetime import datetime
import os
from openai import OpenAI

chat_bp = Blueprint('chat', __name__)

@chat_bp.route('/models', methods=['GET'])
def get_models():
    """获取可用的聊天模型列表"""
    try:
        current_app.logger.debug('开始获取模型列表')
        models = ChatModel.query.filter_by(is_active=True).all()
        current_app.logger.debug(f'查询到的模型数量: {len(models)}')
        result = [{
            'id': model.id,
            'model_name': model.model_name,
            'model_identifier': model.model_identifier,
            'description': model.description
        } for model in models]
        current_app.logger.debug(f'返回的模型数据: {result}')
        return ApiResponse.success(data=result)
    except Exception as e:
        current_app.logger.error(f'获取模型列表失败: {str(e)}')
        return ApiResponse.error(message=str(e))

@chat_bp.route('/messages', methods=['GET'])
def get_chat_history():
    """获取聊天历史记录"""
    try:
        # 可以根据需要添加分页
        messages = ChatHistory.query.order_by(ChatHistory.created_at.asc()).all()
        return ApiResponse.success(data=[msg.to_dict() for msg in messages])
    except Exception as e:
        return ApiResponse.error(message=str(e))

@chat_bp.route('/chat', methods=['POST'])
def chat():
    """处理聊天请求"""
    
    try:
        data = request.get_json()
        if not data:
            return ApiResponse.error(message="请求数据为空")

        messages = data.get('messages', [])
        model_identifier = data.get('model')

        # 验证请求数据
        if not messages:
            return ApiResponse.error(message="消息内容不能为空")
        if not model_identifier:
            return ApiResponse.error(message="未指定模型类型")

        current_app.logger.info(f"开始处理聊天请求，使用模型: {model_identifier}")
        current_app.logger.debug(f"消息内容: {messages}")

        # 验证模型是否存在且可用
        model = ChatModel.query.filter_by(
            model_identifier=model_identifier,
            is_active=True
        ).first()
        
        if not model:
            return ApiResponse.error(message=f"模型 {model_identifier} 不可用")

        try:
            # 初始化 OpenAI 客户端
            client = OpenAI(
                api_key=os.getenv("DASHSCOPE_API_KEY"),
                base_url="https://dashscope.aliyuncs.com/compatible-mode/v1",
            )

            # 调用 API
            completion = client.chat.completions.create(
                model=model_identifier,
                messages=messages
            )

            current_app.logger.debug(f"API 响应: {completion}")

            # 获取回复内容
            assistant_message = completion.choices[0].message
            
            # 保存对话记录
            user_id = g.user.id if hasattr(g, 'user') else 2

            try:
                # 保存用户消息
                for message in messages:
                    chat_history = ChatHistory(
                        user_id=user_id,
                        model_type=model_identifier,
                        role=message['role'],
                        content=message['content']
                    )
                    db.session.add(chat_history)

                # 保存助手回复
                chat_history = ChatHistory(
                    user_id=user_id,
                    model_type=model_identifier,
                    role='assistant',
                    content=assistant_message.content
                )
                db.session.add(chat_history)
                db.session.commit()

            except Exception as db_error:
                current_app.logger.error(f"保存聊天记录失败: {str(db_error)}")
                db.session.rollback()  # 
                # 即使保存失败，我们仍然返回响应
                pass

            return ApiResponse.success(data={
                'response': assistant_message.content,
                'model': model_identifier
            })

        except Exception as api_error:
            current_app.logger.error(f"调用 API 失败: {str(api_error)}")
            return ApiResponse.error(message=f"调用 API 失败: {str(api_error)}")

    except Exception as e:
        current_app.logger.error(f"处理聊天请求失败: {str(e)}")
        return ApiResponse.error(message=f"处理请求失败: {str(e)}")

def get_ai_response(model: str, message: str) -> str:
    """获取 AI 回复
    这里需要实现实际的模型调用逻辑
    可以根据不同的模型调用不同的服务
    """
    # 示例实现
    if model == 'gpt-3.5-turbo':
        # 调用 OpenAI API
        pass
    elif model == 'qwen-7b':
        # 调用通义千问 API
        pass
    
    # 临时返回模拟响应
    return f"这是来自 {model} 的回复：我理解了您的问题 \"{message}\"..."