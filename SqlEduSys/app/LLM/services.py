# app/services/sql_generator.py

import os
import json
import time

from flask import request, current_app
from openai import OpenAI
from dotenv import load_dotenv

load_dotenv()

client = OpenAI(
    api_key=os.getenv("DASHSCOPE_API_KEY"),
    base_url="https://dashscope.aliyuncs.com/compatible-mode/v1",
)
schema_sql = """
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    username VARCHAR(50),
    email VARCHAR(100),
    age INT
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    user_id INT,
    product_name VARCHAR(100),
    order_date DATE,
    total_price DECIMAL(10, 2),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10, 2)
);
"""
def generate_sql(query: str):

    few_shot = """
    示例 1:
    查询需求：查询所有年龄大于25岁的用户。
    SQL：SELECT * FROM users WHERE age > 25;

    示例 2:
    查询需求：查询价格大于100的所有产品。
    SQL：SELECT * FROM products WHERE price > 100;

    示例 3:
    查询需求：查询某个用户的所有订单。
    SQL：SELECT * FROM orders WHERE user_id = 1;

    示例 4:
    查询需求：查询所有购买了"Laptop"产品的用户。
    SQL：SELECT u.username, o.product_name FROM users u JOIN orders o ON u.user_id = o.user_id WHERE o.product_name = 'Laptop';
    """
    system_message = {
        'role': 'system',
        'content': f"""
        你是一个多条SQL生成助手。以下是数据库的 Schema：
        {schema_sql}
        请根据该 Schema 为数据库生成SQL，要求考虑查询内容区间，表与表之间的关系，根据以下自然语言查询生成相应的 SQL。示例：
        {few_shot },生成符合条件的SQL, 注意，只返回样例中SQL：部分，不要有过多信息。 """
    }

    user_message = {
        'role': 'user',
        'content': f"请根据以下自然语言描述生成 SQL: {query}"
    }

    try:
        print(query)
        data = request.get_json()
        query = data.get('query', '')
        start_time = time.time()
        completion = client.chat.completions.create(
            model="qwen-plus",
            messages=[system_message, user_message]
        )
        end_time = time.time()
        elapsed_time = end_time - start_time
        print("本次调用花费时间为", elapsed_time)
        output_data = completion.model_dump()
        sql = output_data["choices"][0]["message"]["content"]
        print("大模型返回数据为",sql)

        return sql
    except Exception as e:
        print(f"Error generating SQL: {e}")
        return None


def validate_sql(query_description: str, generated_sql: str):
    few_shot_examples = """
    示例 1:
    查询需求：查询所有年龄大于25岁的用户。
     SQL：SELECT * FROM users WHERE age > 25;
    验证：SQL 符合描述。

    示例 2:
    查询需求：查询价格大于100的所有产品。
     SQL：SELECT * FROM products WHERE price > 100;
    验证：SQL 符合描述。

    示例 3:
    查询需求：查询某个用户的所有订单。
      SQL：SELECT * FROM orders WHERE user_id = 1;
    验证：SQL 符合描述。

    示例 4:
    查询需求：查询所有购买了"Laptop"产品的用户。
      SQL：SELECT u.username, o.product_name FROM users u JOIN orders o ON u.user_id = o.user_id WHERE o.product_name = 'Laptop';
    验证：SQL 符合描述。

    示例 5:
    查询需求：查询所有价格大于100的订单。
     SQL：SELECT * FROM orders WHERE total_price > 100;
    验证：SQL 符合描述。

    如果 SQL 不符合描述：
    示例：
    查询需求：查询年龄大于30岁的用户。
     SQL：SELECT * FROM users WHERE age < 30;
    验证：SQL 不符合描述，应修改为：SELECT * FROM users WHERE age > 30;
 
    """
    system_message = {
        'role': 'system',
        'content': f"""
        你是一个 SQL 验证助手。以下是数据库的 Schema：
        {schema_sql}
        请根据该 Schema 和以下查询需求验证 SQL 是否正确。如果 SQL 不符合描述，请进行纠正，并给出修改后的 SQL。
        示例：
        {few_shot_examples}
        查询需求：{query_description}
        SQL：{generated_sql}
        验证结果：
        """
    }

    try:
        start_time = time.time()
        completion = client.chat.completions.create(
            model="qwen-plus",
            messages=[system_message]
        )
        end_time = time.time()
        elapsed_time = end_time - start_time
        print("本次调用花费时间为", elapsed_time)

        output_data = completion.model_dump()
        result = output_data["choices"][0]["message"]["content"]
        print("大模型返回数据为", result)

        return result
    except Exception as e:
        print(f"Error validating SQL: {e}")
        return None

def generate_nl_queries_service(schemas, knowledge_points):
    """
    生成自然语言查询的服务函数
    
    Args:
        schemas: 列表，每个元素包含 id, filename 和 file_content
        knowledge_points: 列表，每个元素包含 id, point_name, description, example_sql 和 count
    """
    try:
        # 构建schema内容
        schema_content = ""
        for schema in schemas:
            schema_content += f"\n-- Schema ID: {schema.id}\n"
            schema_content += f"-- Filename: {schema.filename}\n"
            schema_content += f"{schema.file_content}\n"
        
        all_queries = []
        
        # 为每个知识点生成查询
        for point in knowledge_points:
            # 构建prompt
            prompt = SCHEMA_TO_NL_PROMPT.format(
                schema_content=schema_content,
                point_name=point['point_name'],
                point_description=point['description'],
                example_sql=point['example_sql'],
                count=point['count']
            )

            # 调用千问模型生成查询
            start_time = time.time()
            completion = client.chat.completions.create(
                model="qwen-plus",
                messages=[{'role': 'system', 'content': prompt}]
            )
            print(f"生成查询耗时: {time.time() - start_time}秒")

            # 解析返回结果
            result = completion.choices[0].message.content
            queries = []
            
            # 处理生成的查询
            for query in result.split('\n'):
                if query.startswith('@[') and ']' in query:
                    tables = query[2:query.find(']')].split(',')
                    description = query[query.find(']')+1:].strip()
                    
                    queries.append({
                        'query_text': description,
                        'involved_tables': ','.join(tables),
                        'schema_ids': ','.join(str(s.id) for s in schemas),
                        'knowledge_point_id': point['id']
                    })
            
            all_queries.extend(queries)
        
        return all_queries

    except Exception as e:
        print(f"生成查询描述错误: {str(e)}")
        return None

def generate_sql_for_nl(schema_content: str, query_text: str, involved_tables: str):
    """
    为自然语言查询生成SQL的服务函数
    
    Args:
        schema_content: 合并后的schema内容，包含所有相关表的结构
        query_text: 自然语言查询描述
        involved_tables: 涉及的表名，逗号分隔
    """
    system_message = {
        'role': 'system',
        'content': f"""
        你是一个SQL生成助手。根据给定的数据库Schema和自然语言查询生成对应的SQL语句。
        
        数据库Schema：
        {schema_content}
        
        涉及的表：{involved_tables}
        自然语言查询：{query_text}
        
        请生成准确的SQL语句，确保：
        1. 只使用提供的Schema中定义的表和字段
        2. 正确处理表之间的关系
        3. 使用正确的SQL语法和函数
        4. 查询结果满足自然语言描述的需求
        """
    }

    try:
        start_time = time.time()
        completion = client.chat.completions.create(
            model="qwen-plus",
            messages=[
                system_message,
                {'role': 'user', 'content': query_text}
            ]
        )
        end_time = time.time()
        print(f"生成SQL耗时: {end_time - start_time}秒")

        result = completion.choices[0].message.content
        print("生成的SQL:", result)
        return result.strip()


    except Exception as e:
        print(f"生成SQL错误: {str(e)}")
        return None

def get_experiment_report_response(prompt: str) -> str:
    """
    调用大模型API获取实验报告响应
    """
    try:
        current_app.logger.info("Sending request to LLM API for experiment report...")

        # 构建完整的 prompt
        full_prompt = f"""
        你是一个专业的实验报告生成器，负责根据提供的信息生成实验报告。

        请根据以下信息生成实验报告：
        
        {prompt}
        
        请确保报告内容清晰、结构合理，并符合实验要求。
        """

        completion = client.chat.completions.create(
            model="qwen-plus",
            messages=[
                {
                    "role": "system",
                    "content": "你是一个专业的实验报告生成器，精通实验设计和报告撰写。"
                },
                {
                    "role": "user",
                    "content": full_prompt
                }
            ]
        )

        if completion and completion.choices:
            response_text = completion.choices[0].message.content
            return response_text.strip()  # 返回生成的实验报告内容
        else:
            current_app.logger.error("Invalid response format from LLM API")
            return None

    except Exception as e:
        current_app.logger.error(f"Error in get_experiment_report_response: {str(e)}")
        return None





