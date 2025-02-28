from typing import Optional
import json
import requests
from flask import current_app
from datetime import datetime
from app.utils.response import ApiResponse
from requests.adapters import HTTPAdapter
from urllib3.util.retry import Retry
import logging
import os
from openai import OpenAI

class LLMResponse:
    def __init__(self, text: str, error: Optional[str] = None):
        self.text = text
        self.error = error
        self.timestamp = datetime.now()

# 创建 OpenAI 客户端
client = OpenAI(
    api_key=os.getenv("DASHSCOPE_API_KEY"),
    base_url="https://dashscope.aliyuncs.com/compatible-mode/v1",
)

def get_llm_response(prompt: str) -> str:
    """
    调用大模型API获取响应
    """
    try:
        current_app.logger.info("Sending request to LLM API...")
        
        # 添加 few-shot 示例
        few_shot_examples = """
        示例数据库结构：
        CREATE TABLE users (
            id INT PRIMARY KEY,
            username VARCHAR(50),
            email VARCHAR(100),
            is_active BOOLEAN
        );
        
        CREATE TABLE orders (
            id INT PRIMARY KEY,
            user_id INT,
            total DECIMAL(10,2),
            created_at TIMESTAMP
        );

        知识点示例：
        名称：多表连接查询
        描述：掌握基本的表连接操作
        示例SQL：SELECT * FROM users u JOIN orders o ON u.id = o.user_id;

        生成的查询描述示例：
        @[users,orders] 查找最近一个月内下单金额超过1000元的用户信息
        @[users] 统计所有活跃用户的数量和非活跃用户的数量
        @[orders] 分析每个月的订单总金额变化趋势

        注意：
        1. 每个查询都以 @[表名1,表名2,...] 开头，标明涉及的表
        2. 表名之间用逗号分隔，不能有空格
        3. 查询描述要清晰明确，体现知识点特点
        4. 确保查询在给定表结构中可执行
        """
        
        # 构建完整的 prompt
        full_prompt = f"""
        {few_shot_examples}
        
        现在，请根据以下信息生成新的查询描述：
        
        {prompt}
        
        请确保：
        1. 严格按照 @[表名1,表名2] 查询描述 的格式输出
        2. 表名必须来自提供的数据库结构
        3. 查询描述要体现知识点特征
        4. 查询要有实际业务意义
        """
        
        completion = client.chat.completions.create(
            model="qwen-plus",
            messages=[
                {
                    "role": "system",
                    "content": "你是一个专业的SQL教师，精通数据库查询和自然语言处理。你的任务是生成符合格式要求的自然语言查询描述。"
                },
                {
                    "role": "user",
                    "content": full_prompt
                }
            ]
        )
        
        if completion and completion.choices:
            response_text = completion.choices[0].message.content
            # 验证响应格式
            lines = response_text.strip().split('\n')
            valid_lines = []
            for line in lines:
                line = line.strip()
                if line and line.startswith('@[') and ']' in line:
                    valid_lines.append(line)
            
            if valid_lines:
                return '\n'.join(valid_lines)
            else:
                current_app.logger.error("Invalid response format")
                return None
        else:
            current_app.logger.error("Invalid response format from LLM API")
            return None
            
    except Exception as e:
        current_app.logger.error(f"Error in get_llm_response: {str(e)}")
        return None

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
