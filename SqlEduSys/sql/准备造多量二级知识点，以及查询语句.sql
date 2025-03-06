/*
Navicat MySQL Data Transfer

Source Server         : localhost
Source Server Version : 80022
Source Host           : localhost:3306
Source Database       : sqledu

Target Server Type    : MYSQL
Target Server Version : 80022
File Encoding         : 65001

Date: 2025-03-03 21:28:47
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
-- Table structure for experiments
-- ----------------------------
DROP TABLE IF EXISTS `experiments`;
CREATE TABLE `experiments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL COMMENT '实验标题',
  `description` text COMMENT '实验描述',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `status` varchar(20) DEFAULT 'draft' COMMENT '状态：draft-草稿，published-已发布',
  `content` json DEFAULT NULL COMMENT '实验内容，包含查询等信息',
  `knowledge_points` json DEFAULT NULL COMMENT '关联的知识点信息',
  `report_content` text COMMENT '实验报告内容，支持富文本格式',
  `objectives` text COMMENT '实验目标',
  `requirements` text COMMENT '实验要求',
  `steps` text COMMENT '实验步骤',
  `notes` text COMMENT '实验注意事项',
  PRIMARY KEY (`id`),
  KEY `idx_status` (`status`),
  KEY `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实验报告表';

-- ----------------------------
-- Records of experiments
-- ----------------------------

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
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8;

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
  `generated_sql` text,
  `involved_tables` text NOT NULL,
  `schema_ids` text NOT NULL,
  `knowledge_point_id` int DEFAULT NULL,
  `status` enum('pending','approved','rejected') DEFAULT 'pending',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_knowledge_point` (`knowledge_point_id`),
  CONSTRAINT `fk_knowledge_point` FOREIGN KEY (`knowledge_point_id`) REFERENCES `knowledge_point` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=106 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of nl_queries
-- ----------------------------
INSERT INTO `nl_queries` VALUES ('1', '查询所有管理员用户的详细信息', null, 'users', '4', null, 'pending', '2025-02-03 15:27:31', '2025-02-03 15:27:31');
INSERT INTO `nl_queries` VALUES ('2', '统计每个用户的登录次数，并按登录次数降序排列', null, 'users', '4', null, 'pending', '2025-02-03 15:27:31', '2025-02-03 15:27:31');
INSERT INTO `nl_queries` VALUES ('3', '统计每个用户的最后一次登录时间，并按最后一次登录时间降序排列', null, 'users', '4', null, 'pending', '2025-02-03 15:27:31', '2025-02-03 15:27:31');
INSERT INTO `nl_queries` VALUES ('4', '获取所有非管理员用户的用户名和电子邮件，并按用户名升序排列', null, 'users', '4', null, 'pending', '2025-02-03 15:27:31', '2025-02-03 15:27:31');
INSERT INTO `nl_queries` VALUES ('5', '查找所有从未登录过的用户，并显示他们的用户名和注册日期', null, 'users', '4', null, 'pending', '2025-02-03 15:27:31', '2025-02-03 15:27:31');
INSERT INTO `nl_queries` VALUES ('6', '统计每个注册月份的用户数量，并按月份排序', null, 'users', '4', null, 'pending', '2025-02-03 15:27:31', '2025-02-03 15:27:31');
INSERT INTO `nl_queries` VALUES ('7', '查询所有在2025年1月19日之前创建的用户，并显示他们的用户名和创建日期', null, 'users', '4', null, 'pending', '2025-02-03 15:27:31', '2025-02-03 15:27:31');
INSERT INTO `nl_queries` VALUES ('8', '更新所有非管理员用户的`is_active`状态为0，并返回受影响的行数', null, 'users', '4', null, 'pending', '2025-02-03 15:27:31', '2025-02-03 15:27:31');
INSERT INTO `nl_queries` VALUES ('9', '查找所有电子邮件地址包含\"qq.com\"的用户，并显示他们的用户名和电子邮件', null, 'users', '4', null, 'pending', '2025-02-03 15:27:31', '2025-02-03 15:27:31');
INSERT INTO `nl_queries` VALUES ('10', '统计所有用户的平均注册时长（从创建日期到当前日期），并以天为单位显示结果', null, 'users', '4', null, 'pending', '2025-02-03 15:27:31', '2025-02-03 15:27:31');
INSERT INTO `nl_queries` VALUES ('21', '查询所有管理员用户的详细信息', null, 'users', '4,5', null, 'pending', '2025-02-04 01:58:33', '2025-02-04 01:58:33');
INSERT INTO `nl_queries` VALUES ('22', '统计每个用户自注册以来的登录次数，并按登录次数降序排列', null, 'users', '4,5', null, 'pending', '2025-02-04 01:58:33', '2025-02-04 01:58:33');
INSERT INTO `nl_queries` VALUES ('23', '查找最近一周内没有登录过的活跃用户', null, 'users', '4,5', null, 'pending', '2025-02-04 01:58:33', '2025-02-04 01:58:33');
INSERT INTO `nl_queries` VALUES ('24', '更新所有非管理员用户的 `is_active` 状态为0，因为他们长时间未登录', null, 'users', '4,5', null, 'pending', '2025-02-04 01:58:33', '2025-02-04 01:58:33');
INSERT INTO `nl_queries` VALUES ('25', '获取当前数据库版本号以及所有用户的数量', null, 'alembic_version,users', '4,5', null, 'pending', '2025-02-04 01:58:33', '2025-02-04 01:58:33');
INSERT INTO `nl_queries` VALUES ('26', '查找用户名中包含\"test\"的所有用户，并显示他们的注册日期', '根据提供的数据库Schema和自然语言查询需求，以下是生成的SQL语句：\n\n```sql\nSELECT username, date_created\nFROM users\nWHERE username LIKE \'%test%\';\n```\n\n这条SQL语句会查找 `users` 表中用户名 (`username`) 包含 \"test\" 的所有用户，并显示他们的注册日期 (`date_created`)。 `%test%` 是一个通配符表达式，表示任意位置包含 \"test\" 的字符串。', 'users', '4,5', null, 'approved', '2025-02-04 01:58:33', '2025-02-04 03:28:43');
INSERT INTO `nl_queries` VALUES ('27', '统计每个小时段内用户注册的数量，以分析一天中哪个时间段注册人数最多', '要统计每个小时段内用户注册的数量，可以使用 `DATE_FORMAT` 函数来提取 `date_created` 字段中的小时部分，并按小时进行分组统计。以下是满足需求的 SQL 查询：\n\n```sql\nSELECT \n    DATE_FORMAT(date_created, \'%H\') AS hour_of_day,\n    COUNT(*) AS registration_count\nFROM \n    users\nWHERE \n    DATE(date_created) = CURDATE()  -- 只统计今天的注册数据，如果需要统计所有历史数据可以去掉这行\nGROUP BY \n    hour_of_day\nORDER BY \n    registration_count DESC;\n```\n\n如果你想要统计所有历史数据而不仅仅是今天的数据，可以去掉 `WHERE` 子句中的日期过滤条件：\n\n```sql\nSELECT \n    DATE_FORMAT(date_created, \'%H\') AS hour_of_day,\n    COUNT(*) AS registration_count\nFROM \n    users\nGROUP BY \n    hour_of_day\nORDER BY \n    registration_count DESC;\n```\n\n这个查询会返回每个小时内用户注册的数量，并按照注册数量从多到少排序。这样你可以分析一天中哪个时间段注册人数最多。', 'users', '4,5', null, 'approved', '2025-02-04 01:58:33', '2025-02-17 22:56:18');
INSERT INTO `nl_queries` VALUES ('28', '查询所有在过去24小时内注册的用户，并按注册时间升序排列', '根据提供的数据库Schema和自然语言查询需求，以下是生成的SQL语句：\n\n```sql\nSELECT id, username, email, date_created\nFROM users\nWHERE date_created >= NOW() - INTERVAL 1 DAY\nORDER BY date_created ASC;\n```\n\n解释：\n1. `SELECT id, username, email, date_created`：选择用户表中的相关字段。\n2. `FROM users`：指定查询的表为`users`。\n3. `WHERE date_created >= NOW() - INTERVAL 1 DAY`：筛选出在过去24小时内注册的用户。`NOW()`函数返回当前时间，`INTERVAL 1 DAY`表示过去24小时。\n4. `ORDER BY date_created ASC`：按注册时间升序排列结果。\n\n这条SQL语句将满足查询所有在过去24小时内注册的用户，并按注册时间升序排列的需求。', 'users', '4,5', null, 'approved', '2025-02-04 01:58:33', '2025-02-17 23:50:56');
INSERT INTO `nl_queries` VALUES ('29', '找出所有从未登录过的用户，并标记他们为不活跃用户（更新 `is_active` 为0）', null, 'users', '4,5', null, 'pending', '2025-02-04 01:58:33', '2025-02-04 01:58:33');
INSERT INTO `nl_queries` VALUES ('30', '按月统计新注册用户的数量，并显示每个月的新用户增长趋势', null, 'users', '4,5', null, 'pending', '2025-02-04 01:58:33', '2025-02-04 01:58:33');
INSERT INTO `nl_queries` VALUES ('31', '查找在过去一个月内活跃的用户及其聊天记录数量', '要查找在过去一个月内活跃的用户及其聊天记录数量，我们需要从 `users` 表和 `chat_history` 表中提取相关信息。具体来说，我们需要：\n\n1. 筛选出在过去一个月内有聊天记录的用户。\n2. 统计每个用户的聊天记录数量。\n\n以下是满足这些需求的 SQL 查询：\n\n```sql\nSELECT \n    u.id AS user_id,\n    u.username,\n    COUNT(ch.id) AS chat_count\nFROM \n    users u\nJOIN \n    chat_history ch ON u.id = ch.user_id\nWHERE \n    ch.created_at >= DATE_SUB(CURRENT_DATE, INTERVAL 1 MONTH)\nGROUP BY \n    u.id, u.username\nORDER BY \n    chat_count DESC;\n```\n\n### 解释：\n- **`JOIN`**: 我们使用 `JOIN` 将 `users` 表和 `chat_history` 表连接在一起，基于 `user_id` 字段。\n- **`WHERE`**: 使用 `DATE_SUB(CURRENT_DATE, INTERVAL 1 MONTH)` 来筛选出过去一个月内的聊天记录。\n- **`GROUP BY`**: 按照用户 ID 和用户名分组，以便统计每个用户的聊天记录数量。\n- **`COUNT(ch.id)`**: 统计每个用户的聊天记录数量。\n- **`ORDER BY chat_count DESC`**: 按照聊天记录数量降序排列结果。\n\n这个查询将返回在过去一个月内活跃的用户及其对应的聊天记录数量。', 'users,chat_history', '7', null, 'approved', '2025-02-11 11:46:42', '2025-02-11 11:48:02');
INSERT INTO `nl_queries` VALUES ('32', '列出所有当前激活的语言模型及其描述', null, 'llm_models', '7', null, 'pending', '2025-02-11 11:46:42', '2025-02-11 11:46:42');
INSERT INTO `nl_queries` VALUES ('33', '统计每个状态（pending, approved, rejected）的自然语言查询数量', null, 'nl_queries', '7', null, 'pending', '2025-02-11 11:46:42', '2025-02-11 11:46:42');
INSERT INTO `nl_queries` VALUES ('34', '找出每个用户的最新一次聊天记录，并显示该记录的时间和内容', null, 'users,chat_history', '7', null, 'pending', '2025-02-11 11:46:42', '2025-02-11 11:46:42');
INSERT INTO `nl_queries` VALUES ('35', '查询在2025年1月创建的所有SQL文件及其内容', null, 'sqls', '7', null, 'pending', '2025-02-11 11:46:42', '2025-02-11 11:46:42');
INSERT INTO `nl_queries` VALUES ('36', '查找使用特定语言模型进行聊天的用户及其聊天内容', null, 'users,chat_history,llm_models', '7', null, 'pending', '2025-02-11 11:46:42', '2025-02-11 11:46:42');
INSERT INTO `nl_queries` VALUES ('37', '找出所有已批准的自然语言查询及其生成的SQL语句', null, 'nl_queries,sqls', '7', null, 'pending', '2025-02-11 11:46:42', '2025-02-11 11:46:42');
INSERT INTO `nl_queries` VALUES ('38', '列出所有管理员用户及其最后一次登录时间', null, 'users', '7', null, 'pending', '2025-02-11 11:46:42', '2025-02-11 11:46:42');
INSERT INTO `nl_queries` VALUES ('39', '统计每个语言模型在过去一周内的使用次数', null, 'chat_history,llm_models', '7', null, 'pending', '2025-02-11 11:46:42', '2025-02-11 11:46:42');
INSERT INTO `nl_queries` VALUES ('40', '获取数据库的最新版本号以及对应的更新时间', '根据提供的数据库Schema，`alembic_version`表中只包含一个字段`version_num`，并且该表没有记录更新时间的字段。因此，我们无法直接从`alembic_version`表中获取更新时间。\n\n但是，如果假设每次版本更新时会插入或更新一条记录，并且我们可以使用`created_at`字段来近似表示更新时间（尽管这在实际的`alembic_version`表结构中并不存在），我们可以创建一个类似的查询来获取最新版本号及其创建时间。\n\n由于`alembic_version`表中没有时间字段，我们只能返回最新的`version_num`。如果你确实需要更新时间，可能需要修改表结构以包含时间字段。\n\n以下是基于现有表结构的SQL查询：\n\n```sql\nSELECT version_num, created_at AS update_time\nFROM alembic_version\nORDER BY version_num DESC\nLIMIT 1;\n```\n\n请注意，这个查询假设`alembic_version`表有一个`created_at`字段，但实际上该表并没有这个字段。为了准确实现你的需求，建议在`alembic_version`表中添加一个时间字段（如`created_at`或`updated_at`），以便能够记录版本更新的时间。\n\n如果你可以确认`alembic_version`表确实有时间字段，请提供更多信息，我可以调整查询以更好地满足需求。', 'alembic_version', '7', null, 'approved', '2025-02-11 11:46:42', '2025-02-18 00:14:03');
INSERT INTO `nl_queries` VALUES ('50', '创建索引以提高查询用户信息的性能，特别是根据用户名和邮箱进行查询时', '为了提高根据用户名和邮箱查询用户信息的性能，可以在 `users` 表的 `username` 和 `email` 字段上创建索引。由于这两个字段已经分别有唯一的约束（UNIQUE KEY），实际上这些唯一约束已经隐式地创建了索引。但是，如果你仍然希望显式地创建索引以确保性能优化，可以使用以下 SQL 语句：\n\n```sql\n-- 创建用户名上的索引\nCREATE INDEX idx_username ON users (username);\n\n-- 创建邮箱上的索引\nCREATE INDEX idx_email ON users (email);\n```\n\n然而，考虑到 `username` 和 `email` 字段已经有唯一约束，MySQL 会自动为这些字段创建唯一索引。因此，通常不需要再为这些字段创建额外的普通索引。你可以通过以下命令来确认现有的索引情况：\n\n```sql\nSHOW INDEX FROM users;\n```\n\n如果你确实需要进一步优化查询性能，并且希望确保索引存在，可以使用 `CREATE INDEX IF NOT EXISTS`（如果 MySQL 版本支持）或者先检查索引是否存在再创建：\n\n```sql\n-- 检查并创建用户名上的索引\nSET @idx_username_exists = (\n    SELECT COUNT(*) \n    FROM information_schema.statistics \n    WHERE table_schema = DATABASE() \n    AND table_name = \'users\' \n    AND index_name = \'idx_username\'\n);\n\nSET @create_idx_username = IF(\n    @idx_username_exists = 0,\n    \'CREATE INDEX idx_username ON users (username);\',\n    \'SELECT \"Index idx_username already exists\";\'\n);\n\nPREPARE stmt FROM @create_idx_username;\nEXECUTE stmt;\nDEALLOCATE PREPARE stmt;\n\n-- 检查并创建邮箱上的索引\nSET @idx_email_exists = (\n    SELECT COUNT(*) \n    FROM information_schema.statistics \n    WHERE table_schema = DATABASE() \n    AND table_name = \'users\' \n    AND index_name = \'idx_email\'\n);\n\nSET @create_idx_email = IF(\n    @idx_email_exists = 0,\n    \'CREATE INDEX idx_email ON users (email);\',\n    \'SELECT \"Index idx_email already exists\";\'\n);\n\nPREPARE stmt FROM @create_idx_email;\nEXECUTE stmt;\nDEALLOCATE PREPARE stmt;\n```\n\n这段代码会检查索引是否已经存在，如果不存在则创建索引。这样可以避免重复创建索引的问题。', 'users', '8', '13', 'approved', '2025-02-18 01:08:37', '2025-02-18 01:09:16');
INSERT INTO `nl_queries` VALUES ('51', '为用户表和聊天记录表创建组合索引以提高查询性能，特别是针对常用查询条件如用户名和创建时间的查询', null, 'users,chat_history', '8', '13', 'pending', '2025-02-18 01:08:37', '2025-02-18 01:08:37');
INSERT INTO `nl_queries` VALUES ('52', '向用户表中插入一个新用户，包含用户名、电子邮件、密码哈希，并设置为活跃状态', null, 'users', '8', '12', 'pending', '2025-02-21 10:41:33', '2025-02-21 10:41:33');
INSERT INTO `nl_queries` VALUES ('53', '向用户表中插入一个新的管理员用户，设置用户名为 \"admin_user\"，邮箱为 \"admin@example.com\"，并激活该用户账号', null, 'users', '8', '12', 'pending', '2025-02-21 10:41:33', '2025-02-21 10:41:33');
INSERT INTO `nl_queries` VALUES ('54', '向用户表中插入一个新用户，包含用户名、电子邮件、密码哈希，并设置为活跃状态', null, 'users', '8', '12', 'pending', '2025-02-21 10:41:33', '2025-02-21 10:41:33');
INSERT INTO `nl_queries` VALUES ('55', '查找所有活跃用户中，最后一次登录时间晚于平均最后一次登录时间的用户信息', null, 'users', '8', '10', 'pending', '2025-02-21 10:41:48', '2025-02-21 10:41:48');
INSERT INTO `nl_queries` VALUES ('56', '查找所有用户中，最后一次登录时间晚于平均注册时间的用户信息', '要查找所有用户中，最后一次登录时间晚于平均注册时间的用户信息，可以使用以下SQL查询：\n\n```sql\nSELECT u.*\nFROM users u\nWHERE u.last_login > (SELECT AVG(date_created) FROM users);\n```\n\n这个查询的工作原理如下：\n1. 子查询 `(SELECT AVG(date_created) FROM users)` 计算所有用户的平均注册时间。\n2. 主查询选择 `users` 表中的所有列 (`u.*`)，并过滤出那些 `last_login` 时间晚于平均注册时间的用户。\n\n确保查询结果满足自然语言描述的需求，即只返回最后一次登录时间晚于平均注册时间的用户信息。', 'users', '8', '10', 'approved', '2025-02-21 10:41:48', '2025-02-21 10:42:28');
INSERT INTO `nl_queries` VALUES ('57', '查找每个用户最近一个月内与特定模型类型（如“gpt-3.5”）的聊天记录数量，仅包括活跃用户', null, 'users,chat_history', '8', '7', 'pending', '2025-02-23 14:27:45', '2025-02-23 14:27:45');
INSERT INTO `nl_queries` VALUES ('58', '统计每个用户在过去一个月内的聊天记录数量，并按周展示聊天频率', null, 'chat_history', '8', '6', 'pending', '2025-02-23 14:27:53', '2025-02-23 14:27:53');
INSERT INTO `nl_queries` VALUES ('59', '使用LEFT JOIN查询每个用户及其对应的聊天记录数量，包括没有聊天记录的用户', null, 'users,chat_history', '8', '8', 'pending', '2025-02-23 14:29:42', '2025-02-23 14:29:42');
INSERT INTO `nl_queries` VALUES ('60', '使用内连接查询每个用户最近一次的聊天记录，包括用户ID、用户名和聊天内容', null, 'users,chat_history', '8', '7', 'pending', '2025-02-23 14:29:57', '2025-02-23 14:29:57');
INSERT INTO `nl_queries` VALUES ('61', '查找每个用户最近一次聊天记录的模型类型和角色，仅包含有聊天记录的用户', null, 'users,chat_history', '8', '7', 'pending', '2025-02-23 14:29:57', '2025-02-23 14:29:57');
INSERT INTO `nl_queries` VALUES ('62', '统计每个用户在过去一个月内每天的聊天记录数量，并按日期和用户ID排序', null, 'chat_history', '8', '6', 'pending', '2025-02-23 14:30:04', '2025-02-23 14:30:04');
INSERT INTO `nl_queries` VALUES ('63', '使用字符函数生成用户信息摘要，包括用户名、邮箱域名大写以及用户名长度', null, 'users', '8', '5', 'pending', '2025-02-23 14:30:08', '2025-02-23 14:30:08');
INSERT INTO `nl_queries` VALUES ('64', '查找在过去7天内使用过特定模型（model_type为\'gpt-3.5\'）进行聊天的活跃用户信息，包括用户名、邮箱和最后一次聊天的时间', null, 'users,chat_history', '8', '4', 'pending', '2025-02-23 14:30:41', '2025-02-23 14:30:41');
INSERT INTO `nl_queries` VALUES ('65', '查找在过去7天内使用过特定模型（例如：model_type为\'gpt-3.5\'）进行对话且对话次数超过5次的活跃用户信息', null, 'users,chat_history', '8', '4', 'pending', '2025-02-23 14:30:41', '2025-02-23 14:30:41');
INSERT INTO `nl_queries` VALUES ('66', '查找在过去7天内使用过特定模型类型（例如：\'gpt-3.5\'）进行聊天的活跃用户信息，并且这些用户的最后登录时间在30天之内', null, 'users,chat_history', '8', '4', 'pending', '2025-02-23 14:30:41', '2025-02-23 14:30:41');
INSERT INTO `nl_queries` VALUES ('67', '查找在过去7天内使用过特定模型（model_type=\'gpt-3.5\'）进行对话且对话次数超过5次的活跃用户信息', null, 'users,chat_history', '8', '4', 'pending', '2025-02-23 14:30:41', '2025-02-23 14:30:41');
INSERT INTO `nl_queries` VALUES ('68', '获取所有唯一的用户名', null, 'users', '8', '2', 'pending', '2025-02-23 15:01:43', '2025-02-23 15:01:43');
INSERT INTO `nl_queries` VALUES ('69', '查询所有活跃用户的用户名和邮箱，并将邮箱列命名为 contact_email', null, 'users', '8', '1', 'pending', '2025-02-23 15:01:50', '2025-02-23 15:01:50');
INSERT INTO `nl_queries` VALUES ('70', '使用字符函数处理用户信息，生成用户名的全大写版本和计算用户名长度', null, 'users', '8', '5', 'pending', '2025-02-23 15:02:03', '2025-02-23 15:02:03');
INSERT INTO `nl_queries` VALUES ('71', '使用字符处理函数获取所有用户的用户名和邮箱的长度，并将用户名转换为大写', null, 'users', '8', '5', 'pending', '2025-02-23 15:02:03', '2025-02-23 15:02:03');
INSERT INTO `nl_queries` VALUES ('72', '查询所有用户的用户名和邮箱，并将邮箱列命名为 contact_email', null, 'users', '8', '1', 'pending', '2025-02-23 15:16:40', '2025-02-23 15:16:40');
INSERT INTO `nl_queries` VALUES ('73', '查询所有用户的用户名和邮箱，并将邮箱列命名为 contact_email', null, 'users', '8', '1', 'pending', '2025-02-23 15:16:40', '2025-02-23 15:16:40');
INSERT INTO `nl_queries` VALUES ('74', '查询所有活跃用户的用户名和邮箱，并将邮箱列命名为 contact_email', null, 'users', '8', '1', 'pending', '2025-02-23 15:16:40', '2025-02-23 15:16:40');
INSERT INTO `nl_queries` VALUES ('75', '查询所有用户的用户名、电子邮件，并将电子邮件列别名为 contact_email', null, 'users', '8', '1', 'pending', '2025-02-23 15:16:40', '2025-02-23 15:16:40');
INSERT INTO `nl_queries` VALUES ('76', '查询所有活跃用户的用户名和电子邮件，并将电子邮件列别名为 contact_email', null, 'users', '8', '1', 'pending', '2025-02-23 15:16:40', '2025-02-23 15:16:40');
INSERT INTO `nl_queries` VALUES ('77', '获取所有唯一的用户名', null, 'users', '8', '2', 'pending', '2025-02-23 15:17:07', '2025-02-23 15:17:07');
INSERT INTO `nl_queries` VALUES ('78', '获取所有唯一的用户名', null, 'users', '8', '2', 'pending', '2025-02-23 15:17:07', '2025-02-23 15:17:07');
INSERT INTO `nl_queries` VALUES ('79', '获取所有唯一的用户名，去除重复的用户名记录', null, 'users', '8', '2', 'pending', '2025-02-23 15:17:07', '2025-02-23 15:17:07');
INSERT INTO `nl_queries` VALUES ('80', '获取所有唯一的用户名', null, 'users', '8', '2', 'pending', '2025-02-23 15:17:07', '2025-02-23 15:17:07');
INSERT INTO `nl_queries` VALUES ('81', '获取所有唯一的用户名', null, 'users', '8', '2', 'pending', '2025-02-23 15:17:07', '2025-02-23 15:17:07');
INSERT INTO `nl_queries` VALUES ('82', '查询所有用户的用户名和邮箱，并将邮箱列别名为 contact_email', null, 'users', '8', '1', 'pending', '2025-02-23 15:18:50', '2025-02-23 15:18:50');
INSERT INTO `nl_queries` VALUES ('83', '查询所有活跃用户的用户名和邮箱，并将邮箱列命名为 contact_email', null, 'users', '8', '1', 'pending', '2025-02-23 15:18:50', '2025-02-23 15:18:50');
INSERT INTO `nl_queries` VALUES ('84', '查询所有用户的用户名和邮箱，并将邮箱列别名为 contact_email', null, 'users', '8', '1', 'pending', '2025-02-23 15:18:50', '2025-02-23 15:18:50');
INSERT INTO `nl_queries` VALUES ('85', '获取所有唯一用户名，去除重复项', null, 'users', '8', '2', 'pending', '2025-02-23 15:19:02', '2025-02-23 15:19:02');
INSERT INTO `nl_queries` VALUES ('86', '获取所有唯一的用户名', null, 'users', '8', '2', 'pending', '2025-02-23 15:19:02', '2025-02-23 15:19:02');
INSERT INTO `nl_queries` VALUES ('87', '获取所有唯一用户名，去除重复的用户名记录', null, 'users', '8', '2', 'pending', '2025-02-23 15:19:02', '2025-02-23 15:19:02');
INSERT INTO `nl_queries` VALUES ('88', '创建一个新表以记录用户的学习进度，包括用户ID、课程ID、学习进度百分比和最后更新时间\n@[users] 创建一个新表 `user_progress` 来记录用户的学习进度，包含字段：用户ID（外键关联users.id）、课程ID、学习进度百分比（0-100）、最后更新时间。通过此表可以跟踪每个用户在不同课程中的学习进展。', null, 'users', '8', '11', 'pending', '2025-02-23 15:19:21', '2025-02-23 15:19:21');
INSERT INTO `nl_queries` VALUES ('89', '统计每个用户在过去一个月内与不同模型类型的聊天记录数量，并按用户ID排序', null, 'users,chat_history', '8', '11', 'pending', '2025-02-23 15:19:21', '2025-02-23 15:19:21');
INSERT INTO `nl_queries` VALUES ('90', '统计所有用户的活跃状态，包括活跃用户数量、非活跃用户数量以及每个状态的平均创建时间间隔', null, 'users', '8', '9', 'pending', '2025-02-23 15:19:45', '2025-02-23 15:19:45');
INSERT INTO `nl_queries` VALUES ('91', '统计所有用户的活跃状态，包括总用户数、活跃用户数和非活跃用户数，并计算平均、最大和最小的创建时间间隔', null, 'users', '8', '9', 'pending', '2025-02-23 15:19:45', '2025-02-23 15:19:45');
INSERT INTO `nl_queries` VALUES ('92', '统计所有用户的活跃状态，包括总用户数、活跃用户数和非活跃用户数，并计算平均注册时长', 'SELECT \n    COUNT(*) AS total_users,\n    SUM(CASE WHEN is_active = 1 THEN 1 ELSE 0 END) AS active_users,\n    SUM(CASE WHEN is_active = 0 THEN 1 ELSE 0 END) AS inactive_users,\n    AVG(TIMESTAMPDIFF(DAY, date_created, NOW())) AS avg_registration_duration\nFROM users;\n```', 'users', '8', '9', 'approved', '2025-02-23 15:19:45', '2025-02-27 23:45:27');
INSERT INTO `nl_queries` VALUES ('93', '向用户表中插入一条新用户记录，包括用户名、邮箱、密码哈希、创建时间和是否为管理员的信息', 'INSERT INTO users (username, email, password_hash, date_created, is_admin) VALUES (\'newuser\', \'newuser@example.com\', \'passwordhash123\', NOW(), 0);', 'users', '4', '12', 'pending', '2025-02-27 23:47:10', '2025-02-27 23:54:46');
INSERT INTO `nl_queries` VALUES ('94', '向用户表中插入一条新用户记录，包含用户名、电子邮件、密码哈希等必要信息\n@[users] 向用户表中插入一条新用户记录，用户名为\'newuser\'，电子邮件为\'newuser@example.com\'，并设置初始密码和创建时间', 'INSERT INTO users (username, email, password_hash, date_created) \nVALUES (\'newuser\', \'newuser@example.com\', \'initial_password_hash\', NOW());', 'users', '4', '12', 'pending', '2025-02-27 23:47:10', '2025-02-27 23:57:09');
INSERT INTO `nl_queries` VALUES ('95', '查询所有用户的用户名、邮箱以及注册时间，并将注册时间列命名为\"注册日期\"', 'SELECT username, email, date_created AS 注册日期\nFROM users', 'users', '4', '1', 'pending', '2025-02-27 23:59:00', '2025-02-28 00:08:07');
INSERT INTO `nl_queries` VALUES ('96', '查询所有用户的用户名、邮箱以及创建日期，并将创建日期列命名为注册时间', null, 'users', '4', '1', 'pending', '2025-02-27 23:59:00', '2025-02-27 23:59:00');
INSERT INTO `nl_queries` VALUES ('97', '查询所有用户的用户名、邮箱以及创建日期，并将创建日期列命名为注册时间', 'SELECT username, email, date_created AS 注册时间 \nFROM users', 'users', '4', '1', 'pending', '2025-02-27 23:59:00', '2025-02-27 23:59:07');
INSERT INTO `nl_queries` VALUES ('98', '查询所有活跃用户的用户名和邮箱，并将邮箱列别名为 contact_email', null, 'users', '8', '1', 'pending', '2025-02-28 12:15:10', '2025-02-28 12:15:10');
INSERT INTO `nl_queries` VALUES ('99', '查询所有活跃用户的用户名和邮箱，并将邮箱列命名为 contact_email', null, 'users', '8', '1', 'pending', '2025-02-28 12:15:10', '2025-02-28 12:15:10');
INSERT INTO `nl_queries` VALUES ('100', '查询所有活跃用户的用户名和邮箱，并将邮箱列命名为 contact_email', null, 'users', '8', '1', 'pending', '2025-02-28 12:15:10', '2025-02-28 12:15:10');
INSERT INTO `nl_queries` VALUES ('101', '获取所有唯一的用户名', null, 'users', '8', '2', 'pending', '2025-02-28 12:15:24', '2025-02-28 12:15:24');
INSERT INTO `nl_queries` VALUES ('102', '获取所有唯一的用户名', '', 'users', '8', '2', 'pending', '2025-02-28 12:15:24', '2025-02-28 12:16:29');
INSERT INTO `nl_queries` VALUES ('103', '获取所有唯一用户名，去除重复的用户名记录', 'SELECT DISTINCT username \nFROM users;', 'users', '8', '2', 'pending', '2025-02-28 12:15:24', '2025-03-01 19:48:01');
INSERT INTO `nl_queries` VALUES ('104', '创建一个新用户并授予其对users表的SELECT和INSERT权限', 'CREATE USER \'newuser\'@\'localhost\' IDENTIFIED BY \'password\';\nGRANT SELECT, INSERT ON sqledu.users TO \'newuser\'@\'localhost\';', 'users', '8', '15', 'pending', '2025-03-01 19:48:49', '2025-03-01 19:49:24');
INSERT INTO `nl_queries` VALUES ('105', '创建一个新用户并授权访问特定表的权限\n@[users] 创建一个新用户并授予对`users`表的SELECT和INSERT权限', null, 'users', '8', '15', 'pending', '2025-03-01 19:48:49', '2025-03-01 19:48:49');

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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of sqls
-- ----------------------------
INSERT INTO `sqls` VALUES ('1', 'sqledu2.sql', '/*\r\nNavicat MySQL Data Transfer\r\n\r\nSource Server         : localhost\r\nSource Server Version : 80022\r\nSource Host           : localhost:3306\r\nSource Database       : sqledu\r\n\r\nTarget Server Type    : MYSQL\r\nTarget Server Version : 80022\r\nFile Encoding         : 65001\r\n\r\nDate: 2025-01-20 10:39:22\r\n*/\r\n\r\nSET FOREIGN_KEY_CHECKS=0;\r\n\r\n-- ----------------------------\r\n-- Table structure for alembic_version\r\n-- ----------------------------\r\nDROP TABLE IF EXISTS `alembic_version`;\r\nCREATE TABLE `alembic_version` (\r\n  `version_num` varchar(32) NOT NULL,\r\n  PRIMARY KEY (`version_num`)\r\n) ENGINE=InnoDB DEFAULT CHARSET=utf8;\r\n\r\n-- ----------------------------\r\n-- Records of alembic_version\r\n-- ----------------------------\r\n\r\n-- ----------------------------\r\n-- Table structure for users\r\n-- ----------------------------\r\nDROP TABLE IF EXISTS `users`;\r\nCREATE TABLE `users` (\r\n  `id` int NOT NULL AUTO_INCREMENT,\r\n  `username` varchar(150) NOT NULL,\r\n  `email` varchar(150) NOT NULL,\r\n  `password_hash` varchar(255) NOT NULL,\r\n  `date_created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,\r\n  `last_login` timestamp NULL DEFAULT NULL,\r\n  `is_active` tinyint(1) DEFAULT \'1\',\r\n  `is_admin` tinyint(1) DEFAULT \'0\',\r\n  PRIMARY KEY (`id`),\r\n  UNIQUE KEY `username` (`username`),\r\n  UNIQUE KEY `email` (`email`)\r\n) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;\r\n\r\n-- ----------------------------\r\n-- Records of users\r\n-- ----------------------------\r\nINSERT INTO `users` VALUES (\'1\', \'w\', \'w@qq.com\', \'1\', \'2025-01-18 22:10:58\', \'2025-01-19 22:11:03\', \'1\', \'1\');\r\nINSERT INTO `users` VALUES (\'2\', \'test\', \'33@qq.com\', \'scrypt:32768:8:1$JdnQ4UFsb6CKDdAu$5f24b24e2f32ce80318729cbc2c416f43eab572cc3b2c06e73d188b949a624d5bf468eb1ce3f0d97e488e7824bd1fec4aef96676562fb50611b4de6aba952aac\', \'2025-01-19 23:58:25\', null, \'1\', \'0\');\r\nINSERT INTO `users` VALUES (\'4\', \'test2\', \'22\', \'scrypt:32768:8:1$sF64rLqqVanrbwOp$7da6a60ce950e93e13f7de8cdb9f67225d4ac116476b1c73f05f37539f1267c4b9fc82dcdb10d7b2be71b6bc5f5f2877eee030c6a85ef64c799ce368e634d31d\', \'2025-01-20 00:02:05\', null, \'1\', \'0\');\r\nINSERT INTO `users` VALUES (\'5\', \'t\', \'t\', \'scrypt:32768:8:1$VRNKj6XHm7nvIzl6$a679f2ba0543edc4117b85947c54bec8ffb13c7ed30a663b87a753771c30ce86e412103d3c704b0c0fb201b776cdb1088a423a563419086b139fe0ed5981423d\', \'2025-01-20 00:09:55\', null, \'1\', \'0\');\r\nINSERT INTO `users` VALUES (\'6\', \'tt\', \'tt\', \'scrypt:32768:8:1$w1xWuIhTI4rzacve$e1277c93acdc5ab1ab34dbb9b56dd75ce633d259c155ca7490d174721c1b11f7614eb3a4f3092a290dd8bddc546ad17e8fef5d35efd8e6e30cfbe1302efc4c70\', \'2025-01-20 00:26:57\', null, \'1\', \'0\');\r\n', '2025-02-03 19:42:01');
INSERT INTO `sqls` VALUES ('3', 'sqledu.sql', '/*\r\nNavicat MySQL Data Transfer\r\n\r\nSource Server         : localhost\r\nSource Server Version : 80022\r\nSource Host           : localhost:3306\r\nSource Database       : sqledu\r\n\r\nTarget Server Type    : MYSQL\r\nTarget Server Version : 80022\r\nFile Encoding         : 65001\r\n\r\nDate: 2025-01-19 22:12:29\r\n*/\r\n\r\nSET FOREIGN_KEY_CHECKS=0;\r\n\r\n-- ----------------------------\r\n-- Table structure for alembic_version\r\n-- ----------------------------\r\nDROP TABLE IF EXISTS `alembic_version`;\r\nCREATE TABLE `alembic_version` (\r\n  `version_num` varchar(32) NOT NULL,\r\n  PRIMARY KEY (`version_num`)\r\n) ENGINE=InnoDB DEFAULT CHARSET=utf8;\r\n\r\n-- ----------------------------\r\n-- Records of alembic_version\r\n-- ----------------------------\r\n\r\n-- ----------------------------\r\n-- Table structure for users\r\n-- ----------------------------\r\nDROP TABLE IF EXISTS `users`;\r\nCREATE TABLE `users` (\r\n  `id` int NOT NULL AUTO_INCREMENT,\r\n  `username` varchar(150) NOT NULL,\r\n  `email` varchar(150) NOT NULL,\r\n  `password_hash` varchar(255) NOT NULL,\r\n  `date_created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,\r\n  `last_login` timestamp NULL DEFAULT NULL,\r\n  `is_active` tinyint(1) DEFAULT \'1\',\r\n  `is_admin` tinyint(1) DEFAULT \'0\',\r\n  PRIMARY KEY (`id`),\r\n  UNIQUE KEY `username` (`username`),\r\n  UNIQUE KEY `email` (`email`)\r\n) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;\r\n\r\n-- ----------------------------\r\n-- Records of users\r\n-- ----------------------------\r\nINSERT INTO `users` VALUES (\'1\', \'w\', \'w@qq.com\', \'1\', \'2025-01-18 22:10:58\', \'2025-01-19 22:11:03\', \'1\', \'1\');\r\n', '2025-02-03 19:47:53');
INSERT INTO `sqls` VALUES ('4', 'sqledu2.sql', '/*\r\nNavicat MySQL Data Transfer\r\n\r\nSource Server         : localhost\r\nSource Server Version : 80022\r\nSource Host           : localhost:3306\r\nSource Database       : sqledu\r\n\r\nTarget Server Type    : MYSQL\r\nTarget Server Version : 80022\r\nFile Encoding         : 65001\r\n\r\nDate: 2025-01-20 10:39:22\r\n*/\r\n\r\nSET FOREIGN_KEY_CHECKS=0;\r\n\r\n-- ----------------------------\r\n-- Table structure for alembic_version\r\n-- ----------------------------\r\nDROP TABLE IF EXISTS `alembic_version`;\r\nCREATE TABLE `alembic_version` (\r\n  `version_num` varchar(32) NOT NULL,\r\n  PRIMARY KEY (`version_num`)\r\n) ENGINE=InnoDB DEFAULT CHARSET=utf8;\r\n\r\n-- ----------------------------\r\n-- Records of alembic_version\r\n-- ----------------------------\r\n\r\n-- ----------------------------\r\n-- Table structure for users\r\n-- ----------------------------\r\nDROP TABLE IF EXISTS `users`;\r\nCREATE TABLE `users` (\r\n  `id` int NOT NULL AUTO_INCREMENT,\r\n  `username` varchar(150) NOT NULL,\r\n  `email` varchar(150) NOT NULL,\r\n  `password_hash` varchar(255) NOT NULL,\r\n  `date_created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,\r\n  `last_login` timestamp NULL DEFAULT NULL,\r\n  `is_active` tinyint(1) DEFAULT \'1\',\r\n  `is_admin` tinyint(1) DEFAULT \'0\',\r\n  PRIMARY KEY (`id`),\r\n  UNIQUE KEY `username` (`username`),\r\n  UNIQUE KEY `email` (`email`)\r\n) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;\r\n\r\n-- ----------------------------\r\n-- Records of users\r\n-- ----------------------------\r\nINSERT INTO `users` VALUES (\'1\', \'w\', \'w@qq.com\', \'1\', \'2025-01-18 22:10:58\', \'2025-01-19 22:11:03\', \'1\', \'1\');\r\nINSERT INTO `users` VALUES (\'2\', \'test\', \'33@qq.com\', \'scrypt:32768:8:1$JdnQ4UFsb6CKDdAu$5f24b24e2f32ce80318729cbc2c416f43eab572cc3b2c06e73d188b949a624d5bf468eb1ce3f0d97e488e7824bd1fec4aef96676562fb50611b4de6aba952aac\', \'2025-01-19 23:58:25\', null, \'1\', \'0\');\r\nINSERT INTO `users` VALUES (\'4\', \'test2\', \'22\', \'scrypt:32768:8:1$sF64rLqqVanrbwOp$7da6a60ce950e93e13f7de8cdb9f67225d4ac116476b1c73f05f37539f1267c4b9fc82dcdb10d7b2be71b6bc5f5f2877eee030c6a85ef64c799ce368e634d31d\', \'2025-01-20 00:02:05\', null, \'1\', \'0\');\r\nINSERT INTO `users` VALUES (\'5\', \'t\', \'t\', \'scrypt:32768:8:1$VRNKj6XHm7nvIzl6$a679f2ba0543edc4117b85947c54bec8ffb13c7ed30a663b87a753771c30ce86e412103d3c704b0c0fb201b776cdb1088a423a563419086b139fe0ed5981423d\', \'2025-01-20 00:09:55\', null, \'1\', \'0\');\r\nINSERT INTO `users` VALUES (\'6\', \'tt\', \'tt\', \'scrypt:32768:8:1$w1xWuIhTI4rzacve$e1277c93acdc5ab1ab34dbb9b56dd75ce633d259c155ca7490d174721c1b11f7614eb3a4f3092a290dd8bddc546ad17e8fef5d35efd8e6e30cfbe1302efc4c70\', \'2025-01-20 00:26:57\', null, \'1\', \'0\');\r\n', '2025-02-03 19:51:54');
INSERT INTO `sqls` VALUES ('5', 'sqledu前端更新.sql', '/*hhh\nNavicat MySQL Data Transfer\n\nSource Server         : localhost\nSource Server Version : 80022\nSource Host           : localhost:3306\nSource Database       : sqledu\n\nTarget Server Type    : MYSQL\nTarget Server Version : 80022\nFile Encoding         : 65001\n\nDate: 2025-01-19 22:12:29\n*/\n\nSET FOREIGN_KEY_CHECKS=0;\n\n-- ----------------------------\n-- Table structure for alembic_version\n-- ----------------------------\nDROP TABLE IF EXISTS `alembic_version`;\nCREATE TABLE `alembic_version` (\n  `version_num` varchar(32) NOT NULL,\n  PRIMARY KEY (`version_num`)\n) ENGINE=InnoDB DEFAULT CHARSET=utf8;\n\n-- ----------------------------\n-- Records of alembic_version\n-- ----------------------------\n\n-- ----------------------------\n-- Table structure for users\n-- ----------------------------\nDROP TABLE IF EXISTS `users`;\nCREATE TABLE `users` (\n  `id` int NOT NULL AUTO_INCREMENT,\n  `username` varchar(150) NOT NULL,\n  `email` varchar(150) NOT NULL,\n  `password_hash` varchar(255) NOT NULL,\n  `date_created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,\n  `last_login` timestamp NULL DEFAULT NULL,\n  `is_active` tinyint(1) DEFAULT \'1\',\n  `is_admin` tinyint(1) DEFAULT \'0\',\n  PRIMARY KEY (`id`),\n  UNIQUE KEY `username` (`username`),\n  UNIQUE KEY `email` (`email`)\n) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;\n\n-- ----------------------------\n-- Records of users\n-- ----------------------------\nINSERT INTO `users` VALUES (\'1\', \'w\', \'w@qq.com\', \'1\', \'2025-01-18 22:10:58\', \'2025-01-19 22:11:03\', \'1\', \'1\');\n', '2025-02-03 19:56:45');
INSERT INTO `sqls` VALUES ('7', 'sqledu4.sql', '/*\r\nNavicat MySQL Data Transfer\r\n\r\nSource Server         : localhost\r\nSource Server Version : 80022\r\nSource Host           : localhost:3306\r\nSource Database       : sqledu\r\n\r\nTarget Server Type    : MYSQL\r\nTarget Server Version : 80022\r\nFile Encoding         : 65001\r\n\r\nDate: 2025-02-11 18:44:45\r\n*/\r\n\r\nSET FOREIGN_KEY_CHECKS=0;\r\n\r\n-- ----------------------------\r\n-- Table structure for alembic_version\r\n-- ----------------------------\r\nDROP TABLE IF EXISTS `alembic_version`;\r\nCREATE TABLE `alembic_version` (\r\n  `version_num` varchar(32) NOT NULL,\r\n  PRIMARY KEY (`version_num`)\r\n) ENGINE=InnoDB DEFAULT CHARSET=utf8;\r\n\r\n-- ----------------------------\r\n-- Table structure for chat_history\r\n-- ----------------------------\r\nDROP TABLE IF EXISTS `chat_history`;\r\nCREATE TABLE `chat_history` (\r\n  `id` int NOT NULL AUTO_INCREMENT,\r\n  `user_id` int NOT NULL,\r\n  `model_type` varchar(50) NOT NULL,\r\n  `role` varchar(20) NOT NULL,\r\n  `content` text NOT NULL,\r\n  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,\r\n  PRIMARY KEY (`id`),\r\n  KEY `user_id` (`user_id`),\r\n  CONSTRAINT `chat_history_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)\r\n) ENGINE=InnoDB DEFAULT CHARSET=utf8;\r\n\r\n-- ----------------------------\r\n-- Table structure for llm_models\r\n-- ----------------------------\r\nDROP TABLE IF EXISTS `llm_models`;\r\nCREATE TABLE `llm_models` (\r\n  `id` int NOT NULL AUTO_INCREMENT,\r\n  `model_name` varchar(50) NOT NULL,\r\n  `model_identifier` varchar(100) NOT NULL,\r\n  `description` text,\r\n  `is_active` tinyint(1) DEFAULT \'1\',\r\n  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,\r\n  PRIMARY KEY (`id`)\r\n) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;\r\n\r\n-- ----------------------------\r\n-- Table structure for nl_queries\r\n-- ----------------------------\r\nDROP TABLE IF EXISTS `nl_queries`;\r\nCREATE TABLE `nl_queries` (\r\n  `id` int NOT NULL AUTO_INCREMENT,\r\n  `query_text` text NOT NULL,\r\n  `involved_tables` text NOT NULL,\r\n  `schema_ids` text NOT NULL,\r\n  `status` enum(\'pending\',\'approved\',\'rejected\') DEFAULT \'pending\',\r\n  `generated_sql` text,\r\n  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,\r\n  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,\r\n  PRIMARY KEY (`id`)\r\n) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8;\r\n\r\n-- ----------------------------\r\n-- Table structure for sqls\r\n-- ----------------------------\r\nDROP TABLE IF EXISTS `sqls`;\r\nCREATE TABLE `sqls` (\r\n  `id` int NOT NULL AUTO_INCREMENT,\r\n  `filename` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,\r\n  `file_content` text COLLATE utf8mb4_unicode_ci NOT NULL,\r\n  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,\r\n  PRIMARY KEY (`id`)\r\n) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;\r\n\r\n-- ----------------------------\r\n-- Table structure for users\r\n-- ----------------------------\r\nDROP TABLE IF EXISTS `users`;\r\nCREATE TABLE `users` (\r\n  `id` int NOT NULL AUTO_INCREMENT,\r\n  `username` varchar(150) NOT NULL,\r\n  `email` varchar(150) NOT NULL,\r\n  `password_hash` varchar(255) NOT NULL,\r\n  `date_created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,\r\n  `last_login` timestamp NULL DEFAULT NULL,\r\n  `is_active` tinyint(1) DEFAULT \'1\',\r\n  `is_admin` tinyint(1) DEFAULT \'0\',\r\n  PRIMARY KEY (`id`),\r\n  UNIQUE KEY `username` (`username`),\r\n  UNIQUE KEY `email` (`email`)\r\n) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;\r\n', '2025-02-11 19:26:19');
INSERT INTO `sqls` VALUES ('8', 'sqledu8_.sql', '/*\r\nNavicat MySQL Data Transfer\r\n\r\nSource Server         : localhost\r\nSource Server Version : 80022\r\nSource Host           : localhost:3306\r\nSource Database       : sqledu\r\n\r\nTarget Server Type    : MYSQL\r\nTarget Server Version : 80022\r\nFile Encoding         : 65001\r\n\r\nDate: 2025-02-17 22:57:11\r\n*/\r\n\r\nSET FOREIGN_KEY_CHECKS=0;\r\n\r\n-- ----------------------------\r\n-- Table structure for alembic_version\r\n-- ----------------------------\r\nDROP TABLE IF EXISTS `alembic_version`;\r\nCREATE TABLE `alembic_version` (\r\n  `version_num` varchar(32) NOT NULL,\r\n  PRIMARY KEY (`version_num`)\r\n) ENGINE=InnoDB DEFAULT CHARSET=utf8;\r\n\r\n-- ----------------------------\r\n-- Table structure for chat_history\r\n-- ----------------------------\r\nDROP TABLE IF EXISTS `chat_history`;\r\nCREATE TABLE `chat_history` (\r\n  `id` int NOT NULL AUTO_INCREMENT,\r\n  `user_id` int NOT NULL,\r\n  `model_type` varchar(50) NOT NULL,\r\n  `role` varchar(20) NOT NULL,\r\n  `content` text NOT NULL,\r\n  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,\r\n  PRIMARY KEY (`id`),\r\n  KEY `user_id` (`user_id`),\r\n  CONSTRAINT `chat_history_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)\r\n) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8;\r\n\r\n-- ----------------------------\r\n-- Table structure for knowledge_category\r\n-- ----------------------------\r\nDROP TABLE IF EXISTS `knowledge_category`;\r\nCREATE TABLE `knowledge_category` (\r\n  `id` int NOT NULL AUTO_INCREMENT,\r\n  `category_name` varchar(255) NOT NULL,\r\n  `description` text,\r\n  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,\r\n  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,\r\n  PRIMARY KEY (`id`)\r\n) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8;\r\n\r\n-- ----------------------------\r\n-- Table structure for knowledge_point\r\n-- ----------------------------\r\nDROP TABLE IF EXISTS `knowledge_point`;\r\nCREATE TABLE `knowledge_point` (\r\n  `id` int NOT NULL AUTO_INCREMENT,\r\n  `category_id` int NOT NULL,\r\n  `point_name` varchar(255) NOT NULL,\r\n  `description` text,\r\n  `example_sql` text,\r\n  `explanation` text,\r\n  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,\r\n  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,\r\n  PRIMARY KEY (`id`),\r\n  KEY `category_id` (`category_id`),\r\n  CONSTRAINT `knowledge_point_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `knowledge_category` (`id`)\r\n) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;\r\n\r\n-- ----------------------------\r\n-- Table structure for llm_models\r\n-- ----------------------------\r\nDROP TABLE IF EXISTS `llm_models`;\r\nCREATE TABLE `llm_models` (\r\n  `id` int NOT NULL AUTO_INCREMENT,\r\n  `model_name` varchar(50) NOT NULL,\r\n  `model_identifier` varchar(100) NOT NULL,\r\n  `description` text,\r\n  `is_active` tinyint(1) DEFAULT \'1\',\r\n  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,\r\n  PRIMARY KEY (`id`)\r\n) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;\r\n\r\n-- ----------------------------\r\n-- Table structure for nl_queries\r\n-- ----------------------------\r\nDROP TABLE IF EXISTS `nl_queries`;\r\nCREATE TABLE `nl_queries` (\r\n  `id` int NOT NULL AUTO_INCREMENT,\r\n  `query_text` text NOT NULL,\r\n  `generated_sql` text,\r\n  `involved_tables` text NOT NULL,\r\n  `schema_ids` text NOT NULL,\r\n  `knowledge_point_id` int DEFAULT NULL,\r\n  `status` enum(\'pending\',\'approved\',\'rejected\') DEFAULT \'pending\',\r\n  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,\r\n  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,\r\n  PRIMARY KEY (`id`),\r\n  KEY `fk_knowledge_point` (`knowledge_point_id`),\r\n  CONSTRAINT `fk_knowledge_point` FOREIGN KEY (`knowledge_point_id`) REFERENCES `knowledge_point` (`id`) ON DELETE SET NULL ON UPDATE CASCADE\r\n) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8;\r\n\r\n-- ----------------------------\r\n-- Table structure for sqls\r\n-- ----------------------------\r\nDROP TABLE IF EXISTS `sqls`;\r\nCREATE TABLE `sqls` (\r\n  `id` int NOT NULL AUTO_INCREMENT,\r\n  `filename` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,\r\n  `file_content` text COLLATE utf8mb4_unicode_ci NOT NULL,\r\n  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,\r\n  PRIMARY KEY (`id`)\r\n) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;\r\n\r\n-- ----------------------------\r\n-- Table structure for users\r\n-- ----------------------------\r\nDROP TABLE IF EXISTS `users`;\r\nCREATE TABLE `users` (\r\n  `id` int NOT NULL AUTO_INCREMENT,\r\n  `username` varchar(150) NOT NULL,\r\n  `email` varchar(150) NOT NULL,\r\n  `password_hash` varchar(255) NOT NULL,\r\n  `date_created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,\r\n  `last_login` timestamp NULL DEFAULT NULL,\r\n  `is_active` tinyint(1) DEFAULT \'1\',\r\n  `is_admin` tinyint(1) DEFAULT \'0\',\r\n  PRIMARY KEY (`id`),\r\n  UNIQUE KEY `username` (`username`),\r\n  UNIQUE KEY `email` (`email`)\r\n) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;\r\n', '2025-02-17 22:57:34');
INSERT INTO `sqls` VALUES ('9', 'world.sql', '/*\r\nNavicat MySQL Data Transfer\r\n\r\nSource Server         : localhost\r\nSource Server Version : 80022\r\nSource Host           : localhost:3306\r\nSource Database       : world\r\n\r\nTarget Server Type    : MYSQL\r\nTarget Server Version : 80022\r\nFile Encoding         : 65001\r\n\r\nDate: 2025-03-03 14:13:53\r\n*/\r\n\r\nSET FOREIGN_KEY_CHECKS=0;\r\n\r\n-- ----------------------------\r\n-- Table structure for city\r\n-- ----------------------------\r\nDROP TABLE IF EXISTS `city`;\r\nCREATE TABLE `city` (\r\n  `ID` int NOT NULL AUTO_INCREMENT,\r\n  `Name` char(35) NOT NULL DEFAULT \'\',\r\n  `CountryCode` char(3) NOT NULL DEFAULT \'\',\r\n  `District` char(20) NOT NULL DEFAULT \'\',\r\n  `Population` int NOT NULL DEFAULT \'0\',\r\n  PRIMARY KEY (`ID`),\r\n  KEY `CountryCode` (`CountryCode`),\r\n  CONSTRAINT `city_ibfk_1` FOREIGN KEY (`CountryCode`) REFERENCES `country` (`Code`)\r\n) ENGINE=InnoDB AUTO_INCREMENT=4080 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;\r\n\r\n-- ----------------------------\r\n-- Table structure for country\r\n-- ----------------------------\r\nDROP TABLE IF EXISTS `country`;\r\nCREATE TABLE `country` (\r\n  `Code` char(3) NOT NULL DEFAULT \'\',\r\n  `Name` char(52) NOT NULL DEFAULT \'\',\r\n  `Continent` enum(\'Asia\',\'Europe\',\'North America\',\'Africa\',\'Oceania\',\'Antarctica\',\'South America\') NOT NULL DEFAULT \'Asia\',\r\n  `Region` char(26) NOT NULL DEFAULT \'\',\r\n  `SurfaceArea` decimal(10,2) NOT NULL DEFAULT \'0.00\',\r\n  `IndepYear` smallint DEFAULT NULL,\r\n  `Population` int NOT NULL DEFAULT \'0\',\r\n  `LifeExpectancy` decimal(3,1) DEFAULT NULL,\r\n  `GNP` decimal(10,2) DEFAULT NULL,\r\n  `GNPOld` decimal(10,2) DEFAULT NULL,\r\n  `LocalName` char(45) NOT NULL DEFAULT \'\',\r\n  `GovernmentForm` char(45) NOT NULL DEFAULT \'\',\r\n  `HeadOfState` char(60) DEFAULT NULL,\r\n  `Capital` int DEFAULT NULL,\r\n  `Code2` char(2) NOT NULL DEFAULT \'\',\r\n  PRIMARY KEY (`Code`)\r\n) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;\r\n\r\n-- ----------------------------\r\n-- Table structure for countrylanguage\r\n-- ----------------------------\r\nDROP TABLE IF EXISTS `countrylanguage`;\r\nCREATE TABLE `countrylanguage` (\r\n  `CountryCode` char(3) NOT NULL DEFAULT \'\',\r\n  `Language` char(30) NOT NULL DEFAULT \'\',\r\n  `IsOfficial` enum(\'T\',\'F\') NOT NULL DEFAULT \'F\',\r\n  `Percentage` decimal(4,1) NOT NULL DEFAULT \'0.0\',\r\n  PRIMARY KEY (`CountryCode`,`Language`),\r\n  KEY `CountryCode` (`CountryCode`),\r\n  CONSTRAINT `countryLanguage_ibfk_1` FOREIGN KEY (`CountryCode`) REFERENCES `country` (`Code`)\r\n) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;\r\n', '2025-03-03 20:34:41');
INSERT INTO `sqls` VALUES ('10', 'tpcd.sql', '/*\r\nNavicat MySQL Data Transfer\r\n\r\nSource Server         : localhost\r\nSource Server Version : 80022\r\nSource Host           : localhost:3306\r\nSource Database       : tpcd\r\n\r\nTarget Server Type    : MYSQL\r\nTarget Server Version : 80022\r\nFile Encoding         : 65001\r\n\r\nDate: 2025-03-03 14:13:32\r\n*/\r\n\r\nSET FOREIGN_KEY_CHECKS=0;\r\n\r\n-- ----------------------------\r\n-- Table structure for customer\r\n-- ----------------------------\r\nDROP TABLE IF EXISTS `customer`;\r\nCREATE TABLE `customer` (\r\n  `C_CUSTKEY` int NOT NULL,\r\n  `C_NAME` varchar(25) NOT NULL,\r\n  `C_ADDRESS` varchar(40) NOT NULL,\r\n  `C_NATIONKEY` int NOT NULL,\r\n  `C_PHONE` char(15) NOT NULL,\r\n  `C_ACCTBAL` decimal(15,2) NOT NULL,\r\n  `C_MKTSEGMENT` char(10) NOT NULL,\r\n  `C_COMMENT` varchar(117) NOT NULL,\r\n  PRIMARY KEY (`C_CUSTKEY`),\r\n  KEY `CUSTOMER_FK1` (`C_NATIONKEY`),\r\n  CONSTRAINT `customer_ibfk_1` FOREIGN KEY (`C_NATIONKEY`) REFERENCES `nation` (`N_NATIONKEY`)\r\n) ENGINE=InnoDB DEFAULT CHARSET=utf8;\r\n\r\n-- ----------------------------\r\n-- Table structure for lineitem\r\n-- ----------------------------\r\nDROP TABLE IF EXISTS `lineitem`;\r\nCREATE TABLE `lineitem` (\r\n  `L_ORDERKEY` int NOT NULL,\r\n  `L_PARTKEY` int NOT NULL,\r\n  `L_SUPPKEY` int NOT NULL,\r\n  `L_LINENUMBER` int NOT NULL,\r\n  `L_QUANTITY` decimal(15,2) NOT NULL,\r\n  `L_EXTENDEDPRICE` decimal(15,2) NOT NULL,\r\n  `L_DISCOUNT` decimal(15,2) NOT NULL,\r\n  `L_TAX` decimal(15,2) NOT NULL,\r\n  `L_RETURNFLAG` char(1) NOT NULL,\r\n  `L_LINESTATUS` char(1) NOT NULL,\r\n  `L_SHIPDATE` date NOT NULL,\r\n  `L_COMMITDATE` date NOT NULL,\r\n  `L_RECEIPTDATE` date NOT NULL,\r\n  `L_SHIPINSTRUCT` char(25) NOT NULL,\r\n  `L_SHIPMODE` char(10) NOT NULL,\r\n  `L_COMMENT` varchar(44) NOT NULL,\r\n  PRIMARY KEY (`L_ORDERKEY`,`L_LINENUMBER`),\r\n  KEY `LINEITEM_FK2` (`L_PARTKEY`,`L_SUPPKEY`),\r\n  CONSTRAINT `lineitem_ibfk_1` FOREIGN KEY (`L_ORDERKEY`) REFERENCES `orders` (`O_ORDERKEY`),\r\n  CONSTRAINT `lineitem_ibfk_2` FOREIGN KEY (`L_PARTKEY`, `L_SUPPKEY`) REFERENCES `partsupp` (`PS_PARTKEY`, `PS_SUPPKEY`)\r\n) ENGINE=InnoDB DEFAULT CHARSET=utf8;\r\n\r\n-- ----------------------------\r\n-- Table structure for nation\r\n-- ----------------------------\r\nDROP TABLE IF EXISTS `nation`;\r\nCREATE TABLE `nation` (\r\n  `N_NATIONKEY` int NOT NULL,\r\n  `N_NAME` char(25) NOT NULL,\r\n  `N_REGIONKEY` int NOT NULL,\r\n  `N_COMMENT` varchar(152) DEFAULT NULL,\r\n  PRIMARY KEY (`N_NATIONKEY`),\r\n  KEY `NATION_FK1` (`N_REGIONKEY`),\r\n  CONSTRAINT `nation_ibfk_1` FOREIGN KEY (`N_REGIONKEY`) REFERENCES `region` (`R_REGIONKEY`)\r\n) ENGINE=InnoDB DEFAULT CHARSET=utf8;\r\n\r\n-- ----------------------------\r\n-- Table structure for orders\r\n-- ----------------------------\r\nDROP TABLE IF EXISTS `orders`;\r\nCREATE TABLE `orders` (\r\n  `O_ORDERKEY` int NOT NULL,\r\n  `O_CUSTKEY` int NOT NULL,\r\n  `O_ORDERSTATUS` char(1) NOT NULL,\r\n  `O_TOTALPRICE` decimal(15,2) NOT NULL,\r\n  `O_ORDERDATE` date NOT NULL,\r\n  `O_ORDERPRIORITY` char(15) NOT NULL,\r\n  `O_CLERK` char(15) NOT NULL,\r\n  `O_SHIPPRIORITY` int NOT NULL,\r\n  `O_COMMENT` varchar(79) NOT NULL,\r\n  PRIMARY KEY (`O_ORDERKEY`),\r\n  KEY `ORDERS_FK1` (`O_CUSTKEY`),\r\n  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`O_CUSTKEY`) REFERENCES `customer` (`C_CUSTKEY`)\r\n) ENGINE=InnoDB DEFAULT CHARSET=utf8;\r\n\r\n-- ----------------------------\r\n-- Table structure for part\r\n-- ----------------------------\r\nDROP TABLE IF EXISTS `part`;\r\nCREATE TABLE `part` (\r\n  `P_PARTKEY` int NOT NULL,\r\n  `P_NAME` varchar(55) NOT NULL,\r\n  `P_MFGR` char(25) NOT NULL,\r\n  `P_BRAND` char(10) NOT NULL,\r\n  `P_TYPE` varchar(25) NOT NULL,\r\n  `P_SIZE` int NOT NULL,\r\n  `P_CONTAINER` char(10) NOT NULL,\r\n  `P_RETAILPRICE` decimal(15,2) NOT NULL,\r\n  `P_COMMENT` varchar(23) NOT NULL,\r\n  PRIMARY KEY (`P_PARTKEY`)\r\n) ENGINE=InnoDB DEFAULT CHARSET=utf8;\r\n\r\n-- ----------------------------\r\n-- Table structure for partsupp\r\n-- ----------------------------\r\nDROP TABLE IF EXISTS `partsupp`;\r\nCREATE TABLE `partsupp` (\r\n  `PS_PARTKEY` int NOT NULL,\r\n  `PS_SUPPKEY` int NOT NULL,\r\n  `PS_AVAILQTY` int NOT NULL,\r\n  `PS_SUPPLYCOST` decimal(15,2) NOT NULL,\r\n  `PS_COMMENT` varchar(199) NOT NULL,\r\n  PRIMARY KEY (`PS_PARTKEY`,`PS_SUPPKEY`),\r\n  KEY `PARTSUPP_FK1` (`PS_SUPPKEY`),\r\n  CONSTRAINT `partsupp_ibfk_1` FOREIGN KEY (`PS_SUPPKEY`) REFERENCES `supplier` (`S_SUPPKEY`),\r\n  CONSTRAINT `partsupp_ibfk_2` FOREIGN KEY (`PS_PARTKEY`) REFERENCES `part` (`P_PARTKEY`)\r\n) ENGINE=InnoDB DEFAULT CHARSET=utf8;\r\n\r\n-- ----------------------------\r\n-- Table structure for region\r\n-- ----------------------------\r\nDROP TABLE IF EXISTS `region`;\r\nCREATE TABLE `region` (\r\n  `R_REGIONKEY` int NOT NULL,\r\n  `R_NAME` char(25) NOT NULL,\r\n  `R_COMMENT` varchar(152) DEFAULT NULL,\r\n  PRIMARY KEY (`R_REGIONKEY`)\r\n) ENGINE=InnoDB DEFAULT CHARSET=utf8;\r\n\r\n-- ----------------------------\r\n-- Table structure for supplier\r\n-- ----------------------------\r\nDROP TABLE IF EXISTS `supplier`;\r\nCREATE TABLE `supplier` (\r\n  `S_SUPPKEY` int NOT NULL,\r\n  `S_NAME` char(25) NOT NULL,\r\n  `S_ADDRESS` varchar(40) NOT NULL,\r\n  `S_NATIONKEY` int NOT NULL,\r\n  `S_PHONE` char(15) NOT NULL,\r\n  `S_ACCTBAL` decimal(15,2) NOT NULL,\r\n  `S_COMMENT` varchar(101) NOT NULL,\r\n  PRIMARY KEY (`S_SUPPKEY`),\r\n  KEY `SUPPLIER_FK1` (`S_NATIONKEY`),\r\n  CONSTRAINT `supplier_ibfk_1` FOREIGN KEY (`S_NATIONKEY`) REFERENCES `nation` (`N_NATIONKEY`)\r\n) ENGINE=InnoDB DEFAULT CHARSET=utf8;\r\n', '2025-03-03 20:34:54');

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
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES ('1', 'w', 'w@qq.com', '1', '2025-01-18 22:10:58', '2025-01-19 22:11:03', '1', '1');
INSERT INTO `users` VALUES ('2', 'test', '33@qq.com', 'scrypt:32768:8:1$JdnQ4UFsb6CKDdAu$5f24b24e2f32ce80318729cbc2c416f43eab572cc3b2c06e73d188b949a624d5bf468eb1ce3f0d97e488e7824bd1fec4aef96676562fb50611b4de6aba952aac', '2025-01-19 23:58:25', null, '1', '0');
INSERT INTO `users` VALUES ('4', 'test2', '22', 'scrypt:32768:8:1$sF64rLqqVanrbwOp$7da6a60ce950e93e13f7de8cdb9f67225d4ac116476b1c73f05f37539f1267c4b9fc82dcdb10d7b2be71b6bc5f5f2877eee030c6a85ef64c799ce368e634d31d', '2025-01-20 00:02:05', null, '1', '0');
INSERT INTO `users` VALUES ('5', 't', 't', 'scrypt:32768:8:1$VRNKj6XHm7nvIzl6$a679f2ba0543edc4117b85947c54bec8ffb13c7ed30a663b87a753771c30ce86e412103d3c704b0c0fb201b776cdb1088a423a563419086b139fe0ed5981423d', '2025-01-20 00:09:55', null, '1', '0');
INSERT INTO `users` VALUES ('6', 'tt', 'tt', 'scrypt:32768:8:1$w1xWuIhTI4rzacve$e1277c93acdc5ab1ab34dbb9b56dd75ce633d259c155ca7490d174721c1b11f7614eb3a4f3092a290dd8bddc546ad17e8fef5d35efd8e6e30cfbe1302efc4c70', '2025-01-20 00:26:57', null, '1', '1');
INSERT INTO `users` VALUES ('7', 'admin', 'admin@qq.com', 'scrypt:32768:8:1$iIBCwd0zd4Br6AM5$f512fd459c65c203f8501f7e7973c6f02e04d766e51be584c16c13ae9e1a3e8e00cff49e3bd6ed867c8095cba1263a79cf2b308a357d7edc219408b5988f63c2', '2025-01-20 10:46:06', null, '1', '1');
INSERT INTO `users` VALUES ('8', 'q', 'q', 'scrypt:32768:8:1$XDqUurFy2ZejHG63$b936077b9c70aa7e2b01cf0884de2f18a8db5090b91dae3276cf9a5aea6c94be08eeba56508250d5a5d0392e227ada99d4a60c1a936b9fa92b4e4b0824818e59', '2025-02-23 11:44:45', null, '1', '0');
