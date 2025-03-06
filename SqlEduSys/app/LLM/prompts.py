from  app.models.knowledges import KnowledgePoint


SCHEMA_TO_NL_PROMPT = """
你是一个SQL专家，请基于以下信息生成自然语言查询描述：

数据库表结构：
{schema_content}

知识点信息：
名称：{point_name}
描述：{point_description}
示例SQL：{example_sql}
需要生成的查询数量：{count}

请生成{count}个不同的查询描述，要求：
1. 每个查询都要体现该知识点的特点
2. 查询难度要适中，符合知识点要求
3. 确保查询在给定的数据库模式中可执行
4. 查询要有实际业务意义
5. 明确标注涉及的表名

输出格式：
@[表名1,表名2] 查询描述1
@[表名3] 查询描述2
...

示例输出：
@[employees,departments] 查找在IT部门工作超过5年的员工信息
@[products] 统计每个类别中价格最高的产品
"""

NL_TO_SQL_PROMPT = """
你是一个SQL专家，请基于以下信息生成SQL查询：

数据库表结构：
{schema_content}

知识点信息：
{point_name}: {point_description}
示例SQL: {example_sql}

自然语言查询：{query_text}
涉及表：{involved_tables}

请生成符合知识点要求的SQL语句，确保：
1. 语法正确且可执行
2. 合理使用该知识点相关的SQL特性
3. 查询逻辑完整准确
4. 代码风格清晰规范
"""

def generate_prompt(schema_info, points, version, report_content ):
    
    print("schema_info from generate_prompt",schema_info)
    print("points from generate_prompt",points)
    print("version from generate_prompt",version)
    print("report_content from generate_prompt",report_content)
    """生成提示词"""
    prompt = f"根据以下数据库模式，根据report_content从中筛选相应的知识点，sql答案以及需要的知识点数量生成实验报告：\n\n"
    prompt += f"数据库模式:\n{schema_info}\n\n"
    prompt += f"report_content:\n{report_content}\n\n"
    prompt += f"知识点以及对应的数量:\n"
    for point in points:
        point_id = point.get('id')
        generateCount = point.get('generateCount', 1)
        
        knowledge_point = KnowledgePoint.query.get(point_id)
     
        prompt += f"- {knowledge_point.point_name} -- {generateCount}\n"
    
    print("prompt from generate_prompt",prompt)
    
    if version == 'teacher':
        prompt += "请生成教师版实验报告。教师版实验报告需包含实验题目，题目最后说明涉及的知识点名字，每个题后有着相应题目的答案，较难的题目提供简要的解题思路以及简要答案讲解\n"
    else:
        prompt += "请生成学生版实验报告。学生版实验报告需包含实验题目，题目最后说明涉及的知识点名字，不包括相应题目的答案，每个题后面有着答题区空间\n"
    
    return prompt