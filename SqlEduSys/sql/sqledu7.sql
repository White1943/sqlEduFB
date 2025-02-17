/*
Navicat MySQL Data Transfer

Source Server         : localhost
Source Server Version : 80022
Source Host           : localhost:3306
Source Database       : sqledu

Target Server Type    : MYSQL
Target Server Version : 80022
File Encoding         : 65001

Date: 2025-02-17 22:22:17
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for alembic_version
-- ----------------------------
DROP TABLE IF EXISTS `alembic_version`;
CREATE TABLE `alembic_version` (
  `version_num` varchar(32) NOT NULL,
  PRIMARY KEY (`version_num`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of alembic_version
-- ----------------------------

-- ----------------------------
-- Table structure for chat_history
-- ----------------------------
DROP TABLE IF EXISTS `chat_history`;
CREATE TABLE `chat_history` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `model_type` varchar(50) NOT NULL,
  `role` varchar(20) NOT NULL,
  `content` text NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `chat_history_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of chat_history
-- ----------------------------
INSERT INTO `chat_history` VALUES ('2', '2', 'qwen-7b-chat', 'system', 'You are a helpful assistant.', '2025-02-11 11:04:03');
INSERT INTO `chat_history` VALUES ('3', '2', 'qwen-7b-chat', 'user', '你是什么大模型\n', '2025-02-11 11:04:03');
INSERT INTO `chat_history` VALUES ('4', '2', 'qwen-7b-chat', 'assistant', '我是阿里云开发的通义千问模型，是预训练语言模型。', '2025-02-11 11:04:03');
INSERT INTO `chat_history` VALUES ('5', '2', 'qwen-7b-chat', 'system', 'You are a helpful assistant.', '2025-02-11 11:04:54');
INSERT INTO `chat_history` VALUES ('6', '2', 'qwen-7b-chat', 'user', '你是什么大模型\n', '2025-02-11 11:04:54');
INSERT INTO `chat_history` VALUES ('7', '2', 'qwen-7b-chat', 'assistant', '我是来自阿里云的大规模语言模型，我叫通义千问。', '2025-02-11 11:04:54');
INSERT INTO `chat_history` VALUES ('8', '2', 'qwen-7b-chat', 'system', 'You are a helpful assistant.', '2025-02-11 11:06:45');
INSERT INTO `chat_history` VALUES ('9', '2', 'qwen-7b-chat', 'user', '对的', '2025-02-11 11:06:45');
INSERT INTO `chat_history` VALUES ('10', '2', 'qwen-7b-chat', 'assistant', '好的，很高兴能帮到您！如果您还有其他问题，请随时告诉我。', '2025-02-11 11:06:45');
INSERT INTO `chat_history` VALUES ('11', '2', 'qwen-7b-chat', 'system', 'You are a helpful assistant.', '2025-02-11 11:08:54');
INSERT INTO `chat_history` VALUES ('12', '2', 'qwen-7b-chat', 'user', '你是什么类型的大模型\n', '2025-02-11 11:08:54');
INSERT INTO `chat_history` VALUES ('13', '2', 'qwen-7b-chat', 'assistant', '我是一个基于Transformer架构的预训练语言模型，被称作通义千问。我能够回答问题、创作文字，还能表达观点、撰写代码。', '2025-02-11 11:08:54');
INSERT INTO `chat_history` VALUES ('14', '2', 'qwen-7b-chat', 'system', 'You are a helpful assistant.', '2025-02-11 11:11:19');
INSERT INTO `chat_history` VALUES ('15', '2', 'qwen-7b-chat', 'user', 'nih\n', '2025-02-11 11:11:19');
INSERT INTO `chat_history` VALUES ('16', '2', 'qwen-7b-chat', 'assistant', 'I\'m sorry, I didn\'t understand your question. Could you please provide more context or information?', '2025-02-11 11:11:19');
INSERT INTO `chat_history` VALUES ('17', '2', 'qwen-7b-chat', 'system', 'You are a helpful assistant.', '2025-02-11 11:13:19');
INSERT INTO `chat_history` VALUES ('18', '2', 'qwen-7b-chat', 'user', '你是千问7b么\n', '2025-02-11 11:13:19');
INSERT INTO `chat_history` VALUES ('19', '2', 'qwen-7b-chat', 'assistant', '我是阿里云开发的语言模型，我叫通义千问。', '2025-02-11 11:13:19');
INSERT INTO `chat_history` VALUES ('20', '2', 'qwen-7b-chat', 'system', 'You are a helpful assistant.', '2025-02-11 11:23:57');
INSERT INTO `chat_history` VALUES ('21', '2', 'qwen-7b-chat', 'user', '你好\n', '2025-02-11 11:23:57');
INSERT INTO `chat_history` VALUES ('22', '2', 'qwen-7b-chat', 'assistant', '你好！有什么我可以帮助你的吗？', '2025-02-11 11:23:57');
INSERT INTO `chat_history` VALUES ('23', '2', 'qwen-turbo', 'system', 'You are a helpful assistant.', '2025-02-11 11:24:42');
INSERT INTO `chat_history` VALUES ('24', '2', 'qwen-turbo', 'user', '1+1等于', '2025-02-11 11:24:42');
INSERT INTO `chat_history` VALUES ('25', '2', 'qwen-turbo', 'assistant', '1+1等于2。', '2025-02-11 11:24:42');
INSERT INTO `chat_history` VALUES ('26', '2', 'qwen-long', 'system', 'You are a helpful assistant.', '2025-02-11 11:53:50');
INSERT INTO `chat_history` VALUES ('27', '2', 'qwen-long', 'user', '1+1', '2025-02-11 11:53:50');
INSERT INTO `chat_history` VALUES ('28', '2', 'qwen-long', 'assistant', '1 + 1 equals 2.', '2025-02-11 11:53:50');

-- ----------------------------
-- Table structure for knowledge_category
-- ----------------------------
DROP TABLE IF EXISTS `knowledge_category`;
CREATE TABLE `knowledge_category` (
  `id` int NOT NULL AUTO_INCREMENT,
  `category_name` varchar(255) NOT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of knowledge_category
-- ----------------------------
INSERT INTO `knowledge_category` VALUES ('1', '基本查询', '主要涉及 SELECT 语句的基础使用，包括列选择、算术运算、空值处理、别名定义等', '2025-02-16 23:54:13', '2025-02-16 23:54:13');
INSERT INTO `knowledge_category` VALUES ('2', '约束与排序', '包括 WHERE 子句的条件查询和 ORDER BY 的排序功能', '2025-02-16 23:54:13', '2025-02-16 23:54:13');
INSERT INTO `knowledge_category` VALUES ('3', '函数使用', '涵盖字符函数、数字函数、日期函数、转换函数等各类函数的使用', '2025-02-16 23:54:13', '2025-02-16 23:54:13');
INSERT INTO `knowledge_category` VALUES ('4', '多表查询', '包括各种表连接查询方式，如等值连接、非等值连接、外连接、自连接等', '2025-02-16 23:54:13', '2025-02-16 23:54:13');
INSERT INTO `knowledge_category` VALUES ('5', '统计数据', '使用组函数进行数据统计和分组查询', '2025-02-16 23:54:13', '2025-02-16 23:54:13');
INSERT INTO `knowledge_category` VALUES ('6', '子查询', '在查询中嵌套使用子查询，包括单行和多行子查询', '2025-02-16 23:54:13', '2025-02-16 23:54:13');
INSERT INTO `knowledge_category` VALUES ('7', '表操作', '包括表的创建、修改、删除等 DDL 操作', '2025-02-16 23:54:13', '2025-02-16 23:54:13');
INSERT INTO `knowledge_category` VALUES ('8', '数据操纵', '包括数据的插入、更新、删除等 DML 操作', '2025-02-16 23:54:13', '2025-02-16 23:54:13');
INSERT INTO `knowledge_category` VALUES ('9', '索引与视图', '索引的创建和管理，以及视图的使用。编辑', '2025-02-16 23:54:13', '2025-02-17 05:13:22');
INSERT INTO `knowledge_category` VALUES ('10', '约束管理', '各类约束的定义和管理', '2025-02-16 23:54:13', '2025-02-16 23:54:13');
INSERT INTO `knowledge_category` VALUES ('11', '用户访问控制', '用户权限管理和访问控制', '2025-02-16 23:54:13', '2025-02-16 23:54:13');
INSERT INTO `knowledge_category` VALUES ('12', '待定', '待定', '2025-02-17 05:15:57', '2025-02-17 05:15:57');
INSERT INTO `knowledge_category` VALUES ('14', 'dd', '', '2025-02-17 07:07:04', '2025-02-17 07:07:04');

-- ----------------------------
-- Table structure for knowledge_point
-- ----------------------------
DROP TABLE IF EXISTS `knowledge_point`;
CREATE TABLE `knowledge_point` (
  `id` int NOT NULL AUTO_INCREMENT,
  `category_id` int NOT NULL,
  `point_name` varchar(255) NOT NULL,
  `description` text,
  `example_sql` text,
  `explanation` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `category_id` (`category_id`),
  CONSTRAINT `knowledge_point_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `knowledge_category` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of knowledge_point
-- ----------------------------
INSERT INTO `knowledge_point` VALUES ('1', '1', 'SELECT语句基础', '使用 SELECT 语句查询表中的数据，可以选择特定的列，并可以使用别名', 'SELECT last_name, job_id, salary AS monthly_salary \r\nFROM employees;', 'SELECT 语句用于从表中检索数据。可以选择特定的列，使用 AS 关键字为列指定别名，使结果更易读。', '2025-02-16 23:54:13', '2025-02-16 23:54:13');
INSERT INTO `knowledge_point` VALUES ('2', '1', '去除重复行', '使用 DISTINCT 关键字去除查询结果中的重复行', 'SELECT DISTINCT department_id \r\nFROM employees;', 'DISTINCT 关键字用于去除查询结果中的重复行，只显示唯一的值。这在需要了解某个字段所有可能值时很有用。', '2025-02-16 23:54:13', '2025-02-16 23:54:13');
INSERT INTO `knowledge_point` VALUES ('3', '2', 'WHERE子句使用', '使用 WHERE 子句进行条件过滤', 'SELECT last_name, salary \r\nFROM employees \r\nWHERE salary > 12000;', 'WHERE 子句用于指定查询条件，只返回满足条件的行。可以使用比较运算符（>、<、=等）和逻辑运算符（AND、OR等）。', '2025-02-16 23:54:13', '2025-02-16 23:54:13');
INSERT INTO `knowledge_point` VALUES ('4', '2', '复杂条件查询', '使用多个条件组合进行查询', 'SELECT last_name, salary, department_id \r\nFROM employees \r\nWHERE salary >= 10000 \r\nAND department_id IN (20, 30);', '可以使用AND、OR组合多个条件，IN操作符用于匹配一组值中的任何一个。', '2025-02-16 23:54:13', '2025-02-16 23:54:13');
INSERT INTO `knowledge_point` VALUES ('5', '3', '字符函数', '使用字符处理函数操作字符串数据', 'SELECT employee_id, \r\n       CONCAT(first_name, \' \', last_name) AS full_name,\r\n       UPPER(last_name) AS upper_name,\r\n       LENGTH(last_name) AS name_length\r\nFROM employees;', 'CONCAT函数用于连接字符串，UPPER函数将字符转换为大写，LENGTH函数返回字符串长度。', '2025-02-16 23:54:13', '2025-02-16 23:54:13');
INSERT INTO `knowledge_point` VALUES ('6', '3', '日期函数', '使用日期处理函数处理时间数据', 'SELECT employee_id, hire_date,\r\n       YEAR(hire_date) AS hire_year,\r\n       MONTH(hire_date) AS hire_month,\r\n       DATEDIFF(NOW(), hire_date) AS days_employed\r\nFROM employees;', '日期函数用于处理日期时间数据。YEAR提取年份，MONTH提取月份，DATEDIFF计算日期差。', '2025-02-16 23:54:13', '2025-02-16 23:54:13');
INSERT INTO `knowledge_point` VALUES ('7', '4', '内连接', '使用 INNER JOIN 进行表连接查询', 'SELECT e.last_name, d.department_name\r\nFROM employees e\r\nINNER JOIN departments d \r\nON e.department_id = d.department_id;', '内连接返回两个表中满足连接条件的行。使用表别名（e和d）可以使查询更简洁。', '2025-02-16 23:54:13', '2025-02-16 23:54:13');
INSERT INTO `knowledge_point` VALUES ('8', '4', '外连接', '使用 LEFT/RIGHT JOIN 进行外连接查询', 'SELECT e.last_name, d.department_name\r\nFROM employees e\r\nLEFT JOIN departments d \r\nON e.department_id = d.department_id;', '左外连接返回左表的所有行，即使右表中没有匹配的行。右外连接则相反。', '2025-02-16 23:54:13', '2025-02-16 23:54:13');
INSERT INTO `knowledge_point` VALUES ('9', '5', '聚合函数', '使用聚合函数进行数据统计', 'SELECT department_id,\r\n       COUNT(*) AS emp_count,\r\n       AVG(salary) AS avg_salary,\r\n       MAX(salary) AS max_salary,\r\n       MIN(salary) AS min_salary\r\nFROM employees\r\nGROUP BY department_id;', '聚合函数用于计算统计值。COUNT计数，AVG计算平均值，MAX/MIN找出最大/最小值。GROUP BY子句用于分组。', '2025-02-16 23:54:13', '2025-02-16 23:54:13');
INSERT INTO `knowledge_point` VALUES ('10', '6', '单行子查询 编辑', '使用返回单个值的子查询', 'SELECT last_name, job_id, salary\r\nFROM employees\r\nWHERE salary > (\r\n    SELECT AVG(salary)\r\n    FROM employees\r\n);', '子查询可以嵌套在主查询中。这个例子找出薪资高于平均薪资的员工。', '2025-02-16 23:54:13', '2025-02-17 05:15:25');
INSERT INTO `knowledge_point` VALUES ('11', '7', '创建表', '创建新的数据库表', 'CREATE TABLE projects (\r\n    project_id INT PRIMARY KEY,\r\n    project_name VARCHAR(100) NOT NULL,\r\n    start_date DATE,\r\n    end_date DATE,\r\n    budget DECIMAL(10,2),\r\n    manager_id INT,\r\n    FOREIGN KEY (manager_id) REFERENCES employees(employee_id)\r\n);', '创建表时需要指定列名、数据类型和约束。可以设置主键、外键等约束。', '2025-02-16 23:54:13', '2025-02-16 23:54:13');
INSERT INTO `knowledge_point` VALUES ('12', '8', '插入数据', '向表中插入新数据', 'INSERT INTO departments \r\n(department_id, department_name, location_id)\r\nVALUES \r\n(280, \'Business Analytics\', 1700);', 'INSERT语句用于添加新行。可以指定列名和对应的值，未指定的列将使用默认值。', '2025-02-16 23:54:13', '2025-02-16 23:54:13');
INSERT INTO `knowledge_point` VALUES ('13', '9', '创建索引', '创建表索引提高查询性能', 'CREATE INDEX emp_name_idx \r\nON employees(last_name, first_name);', '索引可以提高查询性能。可以创建单列索引或多列索引。要考虑索引的维护成本。', '2025-02-16 23:54:13', '2025-02-16 23:54:13');
INSERT INTO `knowledge_point` VALUES ('14', '10', '主键约束', '设置和管理主键约束', 'ALTER TABLE employees\r\nADD CONSTRAINT emp_pk PRIMARY KEY (employee_id);', '主键约束确保表中的每一行都有唯一标识。一个表只能有一个主键，可以是单列或多列。', '2025-02-16 23:54:13', '2025-02-16 23:54:13');
INSERT INTO `knowledge_point` VALUES ('15', '11', '创建用户', '创建数据库用户并授权', 'CREATE USER \'john\'@\'localhost\' \r\nIDENTIFIED BY \'password\';\r\nGRANT SELECT, INSERT ON employees TO \'john\'@\'localhost\';', '创建用户并授予适当的权限。可以限制用户可以执行的操作和访问的对象。', '2025-02-16 23:54:13', '2025-02-16 23:54:13');
INSERT INTO `knowledge_point` VALUES ('17', '14', '测试', '测试', 'select', '测试  待定', '2025-02-17 13:31:03', '2025-02-17 13:31:13');

-- ----------------------------
-- Table structure for llm_models
-- ----------------------------
DROP TABLE IF EXISTS `llm_models`;
CREATE TABLE `llm_models` (
  `id` int NOT NULL AUTO_INCREMENT,
  `model_name` varchar(50) NOT NULL,
  `model_identifier` varchar(100) NOT NULL,
  `description` text,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of llm_models
-- ----------------------------
INSERT INTO `llm_models` VALUES ('1', '通义千问7B', 'qwen-7b-chat', '基础对话模型', '1', '2025-02-11 17:44:49');
INSERT INTO `llm_models` VALUES ('2', '通义千问Plus', 'qwen-plus', '增强版对话模型', '1', '2025-02-11 17:44:49');
INSERT INTO `llm_models` VALUES ('3', '通义千问Turbo', 'qwen-turbo', '轻量快速版本', '1', '2025-02-11 17:44:49');
INSERT INTO `llm_models` VALUES ('4', '通义千问-Max', 'qwen-max', '旗舰模型，适合复杂任务，推理能力最强', '1', '2025-02-11 18:32:30');
INSERT INTO `llm_models` VALUES ('5', '通义千问-Plus', 'qwen-plus', '效果、速度、成本均衡', '1', '2025-02-11 18:32:30');
INSERT INTO `llm_models` VALUES ('6', '通义千问-Turbo', 'qwen-turbo', '适合简单任务，速度快、成本极低', '1', '2025-02-11 18:32:30');
INSERT INTO `llm_models` VALUES ('7', '通义千问-Long', 'qwen-long', '适合大规模文本分析，效果与速度均衡、成本较低', '1', '2025-02-11 18:32:30');

-- ----------------------------
-- Table structure for nl_queries
-- ----------------------------
DROP TABLE IF EXISTS `nl_queries`;
CREATE TABLE `nl_queries` (
  `id` int NOT NULL AUTO_INCREMENT,
  `query_text` text NOT NULL,
  `involved_tables` text NOT NULL,
  `schema_ids` text NOT NULL,
  `status` enum('pending','approved','rejected') DEFAULT 'pending',
  `generated_sql` text,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `knowledge_point_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_knowledge_point` (`knowledge_point_id`),
  CONSTRAINT `fk_knowledge_point` FOREIGN KEY (`knowledge_point_id`) REFERENCES `knowledge_point` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of nl_queries
-- ----------------------------
INSERT INTO `nl_queries` VALUES ('1', '查询所有管理员用户的信息，包括用户名、电子邮件和创建日期', 'sers', '4', 'pending', null, '2025-02-03 15:27:31', '2025-02-03 15:27:31', null);
INSERT INTO `nl_queries` VALUES ('2', '查找在过去一个月内登录过的所有活跃用户', 'sers', '4', 'pending', null, '2025-02-03 15:27:31', '2025-02-03 15:27:31', null);
INSERT INTO `nl_queries` VALUES ('3', '统计每个用户的最后一次登录时间，并按最后一次登录时间降序排列', 'sers', '4', 'pending', null, '2025-02-03 15:27:31', '2025-02-03 15:27:31', null);
INSERT INTO `nl_queries` VALUES ('4', '获取所有非管理员用户的用户名和电子邮件，并按用户名升序排列', 'sers', '4', 'pending', null, '2025-02-03 15:27:31', '2025-02-03 15:27:31', null);
INSERT INTO `nl_queries` VALUES ('5', '查找所有从未登录过的用户，并显示他们的用户名和注册日期', 'sers', '4', 'pending', null, '2025-02-03 15:27:31', '2025-02-03 15:27:31', null);
INSERT INTO `nl_queries` VALUES ('6', '统计每个注册月份的用户数量，并按月份排序', 'sers', '4', 'pending', null, '2025-02-03 15:27:31', '2025-02-03 15:27:31', null);
INSERT INTO `nl_queries` VALUES ('7', '查询所有在2025年1月19日之前创建的用户，并显示他们的用户名和创建日期', 'sers', '4', 'pending', null, '2025-02-03 15:27:31', '2025-02-03 15:27:31', null);
INSERT INTO `nl_queries` VALUES ('8', '更新所有非管理员用户的`is_active`状态为0，并返回受影响的行数', 'sers', '4', 'pending', null, '2025-02-03 15:27:31', '2025-02-03 15:27:31', null);
INSERT INTO `nl_queries` VALUES ('9', '查找所有电子邮件地址包含“qq.com”的用户，并显示他们的用户名和电子邮件', 'sers', '4', 'pending', null, '2025-02-03 15:27:31', '2025-02-03 15:27:31', null);
INSERT INTO `nl_queries` VALUES ('10', '统计所有用户的平均注册时长（从创建日期到当前日期），并以天为单位显示结果', 'sers', '4', 'pending', null, '2025-02-03 15:27:31', '2025-02-03 15:27:31', null);
INSERT INTO `nl_queries` VALUES ('21', '查询所有管理员用户的详细信息', 'users', '4,5', 'pending', null, '2025-02-04 01:58:33', '2025-02-04 01:58:33', null);
INSERT INTO `nl_queries` VALUES ('22', '统计每个用户自注册以来的登录次数，并按登录次数降序排列', 'users', '4,5', 'pending', null, '2025-02-04 01:58:33', '2025-02-04 01:58:33', null);
INSERT INTO `nl_queries` VALUES ('23', '查找最近一周内没有登录过的活跃用户', 'users', '4,5', 'pending', null, '2025-02-04 01:58:33', '2025-02-04 01:58:33', null);
INSERT INTO `nl_queries` VALUES ('24', '更新所有非管理员用户的 `is_active` 状态为0，因为他们长时间未登录', 'users', '4,5', 'pending', null, '2025-02-04 01:58:33', '2025-02-04 01:58:33', null);
INSERT INTO `nl_queries` VALUES ('25', '获取当前数据库版本号以及所有用户的数量', 'alembic_version,users', '4,5', 'pending', null, '2025-02-04 01:58:33', '2025-02-04 01:58:33', null);
INSERT INTO `nl_queries` VALUES ('26', '查找用户名中包含“test”的所有用户，并显示他们的注册日期', 'users', '4,5', 'approved', '根据提供的数据库Schema和自然语言查询需求，以下是生成的SQL语句：\n\n```sql\nSELECT username, date_created\nFROM users\nWHERE username LIKE \'%test%\';\n```\n\n这条SQL语句会查找 `users` 表中用户名 (`username`) 包含 \"test\" 的所有用户，并显示他们的注册日期 (`date_created`)。 `%test%` 是一个通配符表达式，表示任意位置包含 \"test\" 的字符串。', '2025-02-04 01:58:33', '2025-02-04 03:28:43', null);
INSERT INTO `nl_queries` VALUES ('27', '统计每个小时段内用户注册的数量，以分析一天中哪个时间段注册人数最多', 'users', '4,5', 'pending', null, '2025-02-04 01:58:33', '2025-02-04 01:58:33', null);
INSERT INTO `nl_queries` VALUES ('28', '查询所有在过去24小时内注册的用户，并按注册时间升序排列', 'users', '4,5', 'pending', null, '2025-02-04 01:58:33', '2025-02-04 01:58:33', null);
INSERT INTO `nl_queries` VALUES ('29', '找出所有从未登录过的用户，并标记他们为不活跃用户（更新 `is_active` 为0）', 'users', '4,5', 'pending', null, '2025-02-04 01:58:33', '2025-02-04 01:58:33', null);
INSERT INTO `nl_queries` VALUES ('30', '按月统计新注册用户的数量，并显示每个月的新用户增长趋势', 'users', '4,5', 'pending', null, '2025-02-04 01:58:33', '2025-02-04 01:58:33', null);
INSERT INTO `nl_queries` VALUES ('31', '查找在过去一个月内活跃的用户及其聊天记录数量', 'users,chat_history', '7', 'approved', '要查找在过去一个月内活跃的用户及其聊天记录数量，我们需要从 `users` 表和 `chat_history` 表中提取相关信息。具体来说，我们需要：\n\n1. 筛选出在过去一个月内有聊天记录的用户。\n2. 统计每个用户的聊天记录数量。\n\n以下是满足这些需求的 SQL 查询：\n\n```sql\nSELECT \n    u.id AS user_id,\n    u.username,\n    COUNT(ch.id) AS chat_count\nFROM \n    users u\nJOIN \n    chat_history ch ON u.id = ch.user_id\nWHERE \n    ch.created_at >= DATE_SUB(CURRENT_DATE, INTERVAL 1 MONTH)\nGROUP BY \n    u.id, u.username\nORDER BY \n    chat_count DESC;\n```\n\n### 解释：\n- **`JOIN`**: 我们使用 `JOIN` 将 `users` 表和 `chat_history` 表连接在一起，基于 `user_id` 字段。\n- **`WHERE`**: 使用 `DATE_SUB(CURRENT_DATE, INTERVAL 1 MONTH)` 来筛选出过去一个月内的聊天记录。\n- **`GROUP BY`**: 按照用户 ID 和用户名分组，以便统计每个用户的聊天记录数量。\n- **`COUNT(ch.id)`**: 统计每个用户的聊天记录数量。\n- **`ORDER BY chat_count DESC`**: 按照聊天记录数量降序排列结果。\n\n这个查询将返回在过去一个月内活跃的用户及其对应的聊天记录数量。', '2025-02-11 11:46:42', '2025-02-11 11:48:02', null);
INSERT INTO `nl_queries` VALUES ('32', '列出所有当前激活的语言模型及其描述', 'llm_models', '7', 'pending', null, '2025-02-11 11:46:42', '2025-02-11 11:46:42', null);
INSERT INTO `nl_queries` VALUES ('33', '统计每个状态（pending, approved, rejected）的自然语言查询数量', 'nl_queries', '7', 'pending', null, '2025-02-11 11:46:42', '2025-02-11 11:46:42', null);
INSERT INTO `nl_queries` VALUES ('34', '找出每个用户的最新一次聊天记录，并显示该记录的时间和内容', 'users,chat_history', '7', 'pending', null, '2025-02-11 11:46:42', '2025-02-11 11:46:42', null);
INSERT INTO `nl_queries` VALUES ('35', '查询在2025年1月创建的所有SQL文件及其内容', 'sqls', '7', 'pending', null, '2025-02-11 11:46:42', '2025-02-11 11:46:42', null);
INSERT INTO `nl_queries` VALUES ('36', '查找使用特定语言模型进行聊天的用户及其聊天内容', 'users,chat_history,llm_models', '7', 'pending', null, '2025-02-11 11:46:42', '2025-02-11 11:46:42', null);
INSERT INTO `nl_queries` VALUES ('37', '找出所有已批准的自然语言查询及其生成的SQL语句', 'nl_queries,sqls', '7', 'pending', null, '2025-02-11 11:46:42', '2025-02-11 11:46:42', null);
INSERT INTO `nl_queries` VALUES ('38', '列出所有管理员用户及其最后一次登录时间', 'users', '7', 'pending', null, '2025-02-11 11:46:42', '2025-02-11 11:46:42', null);
INSERT INTO `nl_queries` VALUES ('39', '统计每个语言模型在过去一周内的使用次数', 'chat_history,llm_models', '7', 'pending', null, '2025-02-11 11:46:42', '2025-02-11 11:46:42', null);
INSERT INTO `nl_queries` VALUES ('40', '获取数据库的最新版本号以及对应的更新时间', 'alembic_version', '7', 'pending', null, '2025-02-11 11:46:42', '2025-02-11 11:46:42', null);

-- ----------------------------
-- Table structure for sqls
-- ----------------------------
DROP TABLE IF EXISTS `sqls`;
CREATE TABLE `sqls` (
  `id` int NOT NULL AUTO_INCREMENT,
  `filename` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `file_content` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of sqls
-- ----------------------------
INSERT INTO `sqls` VALUES ('1', 'sqledu2.sql', '/*\r\nNavicat MySQL Data Transfer\r\n\r\nSource Server         : localhost\r\nSource Server Version : 80022\r\nSource Host           : localhost:3306\r\nSource Database       : sqledu\r\n\r\nTarget Server Type    : MYSQL\r\nTarget Server Version : 80022\r\nFile Encoding         : 65001\r\n\r\nDate: 2025-01-20 10:39:22\r\n*/\r\n\r\nSET FOREIGN_KEY_CHECKS=0;\r\n\r\n-- ----------------------------\r\n-- Table structure for alembic_version\r\n-- ----------------------------\r\nDROP TABLE IF EXISTS `alembic_version`;\r\nCREATE TABLE `alembic_version` (\r\n  `version_num` varchar(32) NOT NULL,\r\n  PRIMARY KEY (`version_num`)\r\n) ENGINE=InnoDB DEFAULT CHARSET=utf8;\r\n\r\n-- ----------------------------\r\n-- Records of alembic_version\r\n-- ----------------------------\r\n\r\n-- ----------------------------\r\n-- Table structure for users\r\n-- ----------------------------\r\nDROP TABLE IF EXISTS `users`;\r\nCREATE TABLE `users` (\r\n  `id` int NOT NULL AUTO_INCREMENT,\r\n  `username` varchar(150) NOT NULL,\r\n  `email` varchar(150) NOT NULL,\r\n  `password_hash` varchar(255) NOT NULL,\r\n  `date_created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,\r\n  `last_login` timestamp NULL DEFAULT NULL,\r\n  `is_active` tinyint(1) DEFAULT \'1\',\r\n  `is_admin` tinyint(1) DEFAULT \'0\',\r\n  PRIMARY KEY (`id`),\r\n  UNIQUE KEY `username` (`username`),\r\n  UNIQUE KEY `email` (`email`)\r\n) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;\r\n\r\n-- ----------------------------\r\n-- Records of users\r\n-- ----------------------------\r\nINSERT INTO `users` VALUES (\'1\', \'w\', \'w@qq.com\', \'1\', \'2025-01-18 22:10:58\', \'2025-01-19 22:11:03\', \'1\', \'1\');\r\nINSERT INTO `users` VALUES (\'2\', \'test\', \'33@qq.com\', \'scrypt:32768:8:1$JdnQ4UFsb6CKDdAu$5f24b24e2f32ce80318729cbc2c416f43eab572cc3b2c06e73d188b949a624d5bf468eb1ce3f0d97e488e7824bd1fec4aef96676562fb50611b4de6aba952aac\', \'2025-01-19 23:58:25\', null, \'1\', \'0\');\r\nINSERT INTO `users` VALUES (\'4\', \'test2\', \'22\', \'scrypt:32768:8:1$sF64rLqqVanrbwOp$7da6a60ce950e93e13f7de8cdb9f67225d4ac116476b1c73f05f37539f1267c4b9fc82dcdb10d7b2be71b6bc5f5f2877eee030c6a85ef64c799ce368e634d31d\', \'2025-01-20 00:02:05\', null, \'1\', \'0\');\r\nINSERT INTO `users` VALUES (\'5\', \'t\', \'t\', \'scrypt:32768:8:1$VRNKj6XHm7nvIzl6$a679f2ba0543edc4117b85947c54bec8ffb13c7ed30a663b87a753771c30ce86e412103d3c704b0c0fb201b776cdb1088a423a563419086b139fe0ed5981423d\', \'2025-01-20 00:09:55\', null, \'1\', \'0\');\r\nINSERT INTO `users` VALUES (\'6\', \'tt\', \'tt\', \'scrypt:32768:8:1$w1xWuIhTI4rzacve$e1277c93acdc5ab1ab34dbb9b56dd75ce633d259c155ca7490d174721c1b11f7614eb3a4f3092a290dd8bddc546ad17e8fef5d35efd8e6e30cfbe1302efc4c70\', \'2025-01-20 00:26:57\', null, \'1\', \'0\');\r\n', '2025-02-03 19:42:01');
INSERT INTO `sqls` VALUES ('3', 'sqledu.sql', '/*\r\nNavicat MySQL Data Transfer\r\n\r\nSource Server         : localhost\r\nSource Server Version : 80022\r\nSource Host           : localhost:3306\r\nSource Database       : sqledu\r\n\r\nTarget Server Type    : MYSQL\r\nTarget Server Version : 80022\r\nFile Encoding         : 65001\r\n\r\nDate: 2025-01-19 22:12:29\r\n*/\r\n\r\nSET FOREIGN_KEY_CHECKS=0;\r\n\r\n-- ----------------------------\r\n-- Table structure for alembic_version\r\n-- ----------------------------\r\nDROP TABLE IF EXISTS `alembic_version`;\r\nCREATE TABLE `alembic_version` (\r\n  `version_num` varchar(32) NOT NULL,\r\n  PRIMARY KEY (`version_num`)\r\n) ENGINE=InnoDB DEFAULT CHARSET=utf8;\r\n\r\n-- ----------------------------\r\n-- Records of alembic_version\r\n-- ----------------------------\r\n\r\n-- ----------------------------\r\n-- Table structure for users\r\n-- ----------------------------\r\nDROP TABLE IF EXISTS `users`;\r\nCREATE TABLE `users` (\r\n  `id` int NOT NULL AUTO_INCREMENT,\r\n  `username` varchar(150) NOT NULL,\r\n  `email` varchar(150) NOT NULL,\r\n  `password_hash` varchar(255) NOT NULL,\r\n  `date_created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,\r\n  `last_login` timestamp NULL DEFAULT NULL,\r\n  `is_active` tinyint(1) DEFAULT \'1\',\r\n  `is_admin` tinyint(1) DEFAULT \'0\',\r\n  PRIMARY KEY (`id`),\r\n  UNIQUE KEY `username` (`username`),\r\n  UNIQUE KEY `email` (`email`)\r\n) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;\r\n\r\n-- ----------------------------\r\n-- Records of users\r\n-- ----------------------------\r\nINSERT INTO `users` VALUES (\'1\', \'w\', \'w@qq.com\', \'1\', \'2025-01-18 22:10:58\', \'2025-01-19 22:11:03\', \'1\', \'1\');\r\n', '2025-02-03 19:47:53');
INSERT INTO `sqls` VALUES ('4', 'sqledu2.sql', '/*\r\nNavicat MySQL Data Transfer\r\n\r\nSource Server         : localhost\r\nSource Server Version : 80022\r\nSource Host           : localhost:3306\r\nSource Database       : sqledu\r\n\r\nTarget Server Type    : MYSQL\r\nTarget Server Version : 80022\r\nFile Encoding         : 65001\r\n\r\nDate: 2025-01-20 10:39:22\r\n*/\r\n\r\nSET FOREIGN_KEY_CHECKS=0;\r\n\r\n-- ----------------------------\r\n-- Table structure for alembic_version\r\n-- ----------------------------\r\nDROP TABLE IF EXISTS `alembic_version`;\r\nCREATE TABLE `alembic_version` (\r\n  `version_num` varchar(32) NOT NULL,\r\n  PRIMARY KEY (`version_num`)\r\n) ENGINE=InnoDB DEFAULT CHARSET=utf8;\r\n\r\n-- ----------------------------\r\n-- Records of alembic_version\r\n-- ----------------------------\r\n\r\n-- ----------------------------\r\n-- Table structure for users\r\n-- ----------------------------\r\nDROP TABLE IF EXISTS `users`;\r\nCREATE TABLE `users` (\r\n  `id` int NOT NULL AUTO_INCREMENT,\r\n  `username` varchar(150) NOT NULL,\r\n  `email` varchar(150) NOT NULL,\r\n  `password_hash` varchar(255) NOT NULL,\r\n  `date_created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,\r\n  `last_login` timestamp NULL DEFAULT NULL,\r\n  `is_active` tinyint(1) DEFAULT \'1\',\r\n  `is_admin` tinyint(1) DEFAULT \'0\',\r\n  PRIMARY KEY (`id`),\r\n  UNIQUE KEY `username` (`username`),\r\n  UNIQUE KEY `email` (`email`)\r\n) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;\r\n\r\n-- ----------------------------\r\n-- Records of users\r\n-- ----------------------------\r\nINSERT INTO `users` VALUES (\'1\', \'w\', \'w@qq.com\', \'1\', \'2025-01-18 22:10:58\', \'2025-01-19 22:11:03\', \'1\', \'1\');\r\nINSERT INTO `users` VALUES (\'2\', \'test\', \'33@qq.com\', \'scrypt:32768:8:1$JdnQ4UFsb6CKDdAu$5f24b24e2f32ce80318729cbc2c416f43eab572cc3b2c06e73d188b949a624d5bf468eb1ce3f0d97e488e7824bd1fec4aef96676562fb50611b4de6aba952aac\', \'2025-01-19 23:58:25\', null, \'1\', \'0\');\r\nINSERT INTO `users` VALUES (\'4\', \'test2\', \'22\', \'scrypt:32768:8:1$sF64rLqqVanrbwOp$7da6a60ce950e93e13f7de8cdb9f67225d4ac116476b1c73f05f37539f1267c4b9fc82dcdb10d7b2be71b6bc5f5f2877eee030c6a85ef64c799ce368e634d31d\', \'2025-01-20 00:02:05\', null, \'1\', \'0\');\r\nINSERT INTO `users` VALUES (\'5\', \'t\', \'t\', \'scrypt:32768:8:1$VRNKj6XHm7nvIzl6$a679f2ba0543edc4117b85947c54bec8ffb13c7ed30a663b87a753771c30ce86e412103d3c704b0c0fb201b776cdb1088a423a563419086b139fe0ed5981423d\', \'2025-01-20 00:09:55\', null, \'1\', \'0\');\r\nINSERT INTO `users` VALUES (\'6\', \'tt\', \'tt\', \'scrypt:32768:8:1$w1xWuIhTI4rzacve$e1277c93acdc5ab1ab34dbb9b56dd75ce633d259c155ca7490d174721c1b11f7614eb3a4f3092a290dd8bddc546ad17e8fef5d35efd8e6e30cfbe1302efc4c70\', \'2025-01-20 00:26:57\', null, \'1\', \'0\');\r\n', '2025-02-03 19:51:54');
INSERT INTO `sqls` VALUES ('5', 'sqledu前端更新.sql', '/*hhh\nNavicat MySQL Data Transfer\n\nSource Server         : localhost\nSource Server Version : 80022\nSource Host           : localhost:3306\nSource Database       : sqledu\n\nTarget Server Type    : MYSQL\nTarget Server Version : 80022\nFile Encoding         : 65001\n\nDate: 2025-01-19 22:12:29\n*/\n\nSET FOREIGN_KEY_CHECKS=0;\n\n-- ----------------------------\n-- Table structure for alembic_version\n-- ----------------------------\nDROP TABLE IF EXISTS `alembic_version`;\nCREATE TABLE `alembic_version` (\n  `version_num` varchar(32) NOT NULL,\n  PRIMARY KEY (`version_num`)\n) ENGINE=InnoDB DEFAULT CHARSET=utf8;\n\n-- ----------------------------\n-- Records of alembic_version\n-- ----------------------------\n\n-- ----------------------------\n-- Table structure for users\n-- ----------------------------\nDROP TABLE IF EXISTS `users`;\nCREATE TABLE `users` (\n  `id` int NOT NULL AUTO_INCREMENT,\n  `username` varchar(150) NOT NULL,\n  `email` varchar(150) NOT NULL,\n  `password_hash` varchar(255) NOT NULL,\n  `date_created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,\n  `last_login` timestamp NULL DEFAULT NULL,\n  `is_active` tinyint(1) DEFAULT \'1\',\n  `is_admin` tinyint(1) DEFAULT \'0\',\n  PRIMARY KEY (`id`),\n  UNIQUE KEY `username` (`username`),\n  UNIQUE KEY `email` (`email`)\n) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;\n\n-- ----------------------------\n-- Records of users\n-- ----------------------------\nINSERT INTO `users` VALUES (\'1\', \'w\', \'w@qq.com\', \'1\', \'2025-01-18 22:10:58\', \'2025-01-19 22:11:03\', \'1\', \'1\');\n', '2025-02-03 19:56:45');
INSERT INTO `sqls` VALUES ('7', 'sqledu4.sql', '/*\r\nNavicat MySQL Data Transfer\r\n\r\nSource Server         : localhost\r\nSource Server Version : 80022\r\nSource Host           : localhost:3306\r\nSource Database       : sqledu\r\n\r\nTarget Server Type    : MYSQL\r\nTarget Server Version : 80022\r\nFile Encoding         : 65001\r\n\r\nDate: 2025-02-11 18:44:45\r\n*/\r\n\r\nSET FOREIGN_KEY_CHECKS=0;\r\n\r\n-- ----------------------------\r\n-- Table structure for alembic_version\r\n-- ----------------------------\r\nDROP TABLE IF EXISTS `alembic_version`;\r\nCREATE TABLE `alembic_version` (\r\n  `version_num` varchar(32) NOT NULL,\r\n  PRIMARY KEY (`version_num`)\r\n) ENGINE=InnoDB DEFAULT CHARSET=utf8;\r\n\r\n-- ----------------------------\r\n-- Table structure for chat_history\r\n-- ----------------------------\r\nDROP TABLE IF EXISTS `chat_history`;\r\nCREATE TABLE `chat_history` (\r\n  `id` int NOT NULL AUTO_INCREMENT,\r\n  `user_id` int NOT NULL,\r\n  `model_type` varchar(50) NOT NULL,\r\n  `role` varchar(20) NOT NULL,\r\n  `content` text NOT NULL,\r\n  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,\r\n  PRIMARY KEY (`id`),\r\n  KEY `user_id` (`user_id`),\r\n  CONSTRAINT `chat_history_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)\r\n) ENGINE=InnoDB DEFAULT CHARSET=utf8;\r\n\r\n-- ----------------------------\r\n-- Table structure for llm_models\r\n-- ----------------------------\r\nDROP TABLE IF EXISTS `llm_models`;\r\nCREATE TABLE `llm_models` (\r\n  `id` int NOT NULL AUTO_INCREMENT,\r\n  `model_name` varchar(50) NOT NULL,\r\n  `model_identifier` varchar(100) NOT NULL,\r\n  `description` text,\r\n  `is_active` tinyint(1) DEFAULT \'1\',\r\n  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,\r\n  PRIMARY KEY (`id`)\r\n) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;\r\n\r\n-- ----------------------------\r\n-- Table structure for nl_queries\r\n-- ----------------------------\r\nDROP TABLE IF EXISTS `nl_queries`;\r\nCREATE TABLE `nl_queries` (\r\n  `id` int NOT NULL AUTO_INCREMENT,\r\n  `query_text` text NOT NULL,\r\n  `involved_tables` text NOT NULL,\r\n  `schema_ids` text NOT NULL,\r\n  `status` enum(\'pending\',\'approved\',\'rejected\') DEFAULT \'pending\',\r\n  `generated_sql` text,\r\n  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,\r\n  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,\r\n  PRIMARY KEY (`id`)\r\n) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8;\r\n\r\n-- ----------------------------\r\n-- Table structure for sqls\r\n-- ----------------------------\r\nDROP TABLE IF EXISTS `sqls`;\r\nCREATE TABLE `sqls` (\r\n  `id` int NOT NULL AUTO_INCREMENT,\r\n  `filename` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,\r\n  `file_content` text COLLATE utf8mb4_unicode_ci NOT NULL,\r\n  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,\r\n  PRIMARY KEY (`id`)\r\n) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;\r\n\r\n-- ----------------------------\r\n-- Table structure for users\r\n-- ----------------------------\r\nDROP TABLE IF EXISTS `users`;\r\nCREATE TABLE `users` (\r\n  `id` int NOT NULL AUTO_INCREMENT,\r\n  `username` varchar(150) NOT NULL,\r\n  `email` varchar(150) NOT NULL,\r\n  `password_hash` varchar(255) NOT NULL,\r\n  `date_created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,\r\n  `last_login` timestamp NULL DEFAULT NULL,\r\n  `is_active` tinyint(1) DEFAULT \'1\',\r\n  `is_admin` tinyint(1) DEFAULT \'0\',\r\n  PRIMARY KEY (`id`),\r\n  UNIQUE KEY `username` (`username`),\r\n  UNIQUE KEY `email` (`email`)\r\n) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;\r\n', '2025-02-11 19:26:19');

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(150) NOT NULL,
  `email` varchar(150) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `date_created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_login` timestamp NULL DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `is_admin` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES ('1', 'w', 'w@qq.com', '1', '2025-01-18 22:10:58', '2025-01-19 22:11:03', '1', '1');
INSERT INTO `users` VALUES ('2', 'test', '33@qq.com', 'scrypt:32768:8:1$JdnQ4UFsb6CKDdAu$5f24b24e2f32ce80318729cbc2c416f43eab572cc3b2c06e73d188b949a624d5bf468eb1ce3f0d97e488e7824bd1fec4aef96676562fb50611b4de6aba952aac', '2025-01-19 23:58:25', null, '1', '0');
INSERT INTO `users` VALUES ('4', 'test2', '22', 'scrypt:32768:8:1$sF64rLqqVanrbwOp$7da6a60ce950e93e13f7de8cdb9f67225d4ac116476b1c73f05f37539f1267c4b9fc82dcdb10d7b2be71b6bc5f5f2877eee030c6a85ef64c799ce368e634d31d', '2025-01-20 00:02:05', null, '1', '0');
INSERT INTO `users` VALUES ('5', 't', 't', 'scrypt:32768:8:1$VRNKj6XHm7nvIzl6$a679f2ba0543edc4117b85947c54bec8ffb13c7ed30a663b87a753771c30ce86e412103d3c704b0c0fb201b776cdb1088a423a563419086b139fe0ed5981423d', '2025-01-20 00:09:55', null, '1', '0');
INSERT INTO `users` VALUES ('6', 'tt', 'tt', 'scrypt:32768:8:1$w1xWuIhTI4rzacve$e1277c93acdc5ab1ab34dbb9b56dd75ce633d259c155ca7490d174721c1b11f7614eb3a4f3092a290dd8bddc546ad17e8fef5d35efd8e6e30cfbe1302efc4c70', '2025-01-20 00:26:57', null, '1', '1');
INSERT INTO `users` VALUES ('7', 'admin', 'admin@qq.com', 'scrypt:32768:8:1$iIBCwd0zd4Br6AM5$f512fd459c65c203f8501f7e7973c6f02e04d766e51be584c16c13ae9e1a3e8e00cff49e3bd6ed867c8095cba1263a79cf2b308a357d7edc219408b5988f63c2', '2025-01-20 10:46:06', null, '1', '1');
