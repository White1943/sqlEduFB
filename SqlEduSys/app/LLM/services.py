# app/services/sql_generator.py

import os
import json
import time

from flask import request
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

def generate_nl_queries_service(schema_content: str):
    """
    生成自然语言查询的服务函数
    """
    few_shot = """
    示例输出：
    @查询1：[涉及表：users] 查询所有年龄大于25岁的用户信息
    @查询2：[涉及表：products] 查找所有价格高于1000元的产品
    @查询3：[涉及表：users,orders] 统计2023年每个用户的总订单金额
    """
    
    system_message = {
        'role': 'system',
        'content': f"""
        你是一个SQL查询描述生成助手。根据给定的数据库Schema生成10个不同的查询描述。
        数据库Schema如下：
        {schema_content}
        
        请按照以下格式生成查询描述：
        {few_shot}
        
        注意：
        1. 每个查询都以@开头
        2. 包含[涉及表：table1,table2]格式的表名
        3. 查询描述要具体且符合业务场景
        4. 包含不同难度的查询
        """
    }

    try:
        start_time = time.time()
        completion = client.chat.completions.create(
            model="qwen-plus",
            messages=[{'role': 'system', 'content': system_message['content']}]
        )
        end_time = time.time()
        print(f"生成查询描述耗时: {end_time - start_time}秒")

        output_data = completion.model_dump()
        result = output_data["choices"][0]["message"]["content"]
        print("生成的查询描述:", result)

        # 分割并清理查询描述
        queries = [q.strip() for q in result.split('@') if q.strip()]
        return queries

    except Exception as e:
        print(f"生成查询描述错误: {str(e)}")
        return None

def generate_sql_for_nl(schema_content: str, query_text: str, involved_tables: str):
    """
    为自然语言查询生成SQL的服务函数
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
        1. 语法正确
        2. 使用正确的表连接
        3. 合理的条件筛选
        4. 必要时使用子查询或聚合函数
        """
    }

    try:
        start_time = time.time()
        completion = client.chat.completions.create(
            model="qwen-plus",
            messages=[{'role': 'system', 'content': system_message['content']}]
        )
        end_time = time.time()
        print(f"生成SQL耗时: {end_time - start_time}秒")

        output_data = completion.model_dump()
        result = output_data["choices"][0]["message"]["content"]
        print("生成的SQL:", result)
        
        return result.strip()

    except Exception as e:
        print(f"生成SQL错误: {str(e)}")
        return None





