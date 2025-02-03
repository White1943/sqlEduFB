from typing import Optional
import json
import requests
from flask import current_app
from datetime import datetime
from app.utils.response import ApiResponse

class LLMResponse:
    def __init__(self, text: str, error: Optional[str] = None):
        self.text = text
        self.error = error
        self.timestamp = datetime.now()

def get_llm_response(prompt: str):
    """
    调用大模型API获取响应
    
    Args:
        prompt: 输入的prompt文本
    
    Returns:
        ApiResponse: 包含模型响应的标准化返回
    """
    try:
        # API配置
        api_url = current_app.config.get('LLM_API_URL', 'http://localhost:8000/v1/chat/completions')
        api_key = current_app.config.get('LLM_API_KEY', '')
        
        # 构建请求数据
        headers = {
            'Content-Type': 'application/json',
            'Authorization': f'Bearer {api_key}'
        }
        
        data = {
            "model": "Qwen-7B-Chat",
            "messages": [
                {
                    "role": "system",
                    "content": "你是一个专业的SQL专家，精通数据库查询和自然语言处理。"
                },
                {
                    "role": "user",
                    "content": prompt
                }
            ],
            "temperature": 0.7,
            "max_tokens": 2000
        }
        
        # 发送请求
        response = requests.post(api_url, headers=headers, json=data, timeout=30)
        response.raise_for_status()
        
        # 解析响应
        result = response.json()
        if 'choices' in result and len(result['choices']) > 0:
            response_text = result['choices'][0]['message']['content']
            # 记录成功的调用
            log_llm_call(prompt, LLMResponse(response_text))
            return ApiResponse.success(data=response_text)
        else:
            return ApiResponse.error(message="Invalid response format from LLM API")
            
    except requests.exceptions.RequestException as e:
        current_app.logger.error(f"LLM API request failed: {str(e)}")
        return ApiResponse.error(message=f"Failed to get response from LLM: {str(e)}", status_code=500)
    except json.JSONDecodeError as e:
        current_app.logger.error(f"Failed to parse LLM response: {str(e)}")
        return ApiResponse.error(message="Invalid response format from LLM API", status_code=500)
    except Exception as e:
        current_app.logger.error(f"Unexpected error in LLM call: {str(e)}")
        return ApiResponse.error(message=str(e), status_code=500)

def log_llm_call(prompt: str, response: LLMResponse) -> None:
    """
    记录LLM调用日志
    """
    try:
        current_app.logger.info(
            f"LLM Call Log:\n"
            f"Timestamp: {response.timestamp}\n"
            f"Prompt: {prompt}\n"
            f"Response: {response.text}\n"
            f"Error: {response.error if response.error else 'None'}"
        )
    except Exception as e:
        current_app.logger.error(f"Failed to log LLM call: {str(e)}")
