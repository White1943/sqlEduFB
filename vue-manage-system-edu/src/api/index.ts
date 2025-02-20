import request from '../utils/request';

export const fetchData = () => {
    return request({
        url: 'http://localhost:5173/mock/table.json',
        method: 'get'
    });
};

export const fetchUserData = () => {
    return request({
        url: 'http://localhost:5173/mock/user.json',
        method: 'get'
    });
};

export const fetchRoleData = () => {
    return request({
        url: 'http://localhost:5173/mock/role.json',
        method: 'get'
    });
};


export const loginUser = (data: { username: string; password: string }) => {
    return request({
        url: '/auth/login',  
        method: 'post',
        data: data  
    });
};

export const registerUser = (data: { username: string; email: string; password: string }) => {
    return request({
        url: '/auth/register',   
        method: 'post',
        data: data,
    });
};
export const generateSQL = (query: string) => {
    return request({
        url: '/stu/generator',  // 后端接口
        method: 'post',
        data: { query }   
    });
};
export const validateSQL = (data: { query_description: string; generated_sql: string }) => {
    return request({
        url: '/stu/validator',  // 后端接口
        method: 'post',
        data: { data }   
    });
};
// export const uploadSchema = (data: FormData) => {
//     return request({
//         url: '/schema/upload',  
//         data: data,
//         headers: {
                
//             'Content-Type': 'multipart/form-data'
//         }
//     });
// };
// export const tableSchema = () => {
//     return request({
//         url: '/schema/table',
//         method: 'get'

//     });

// };

// 上传 SQL 文件
export const uploadSqlFile = (data: FormData) => {
    return request({
        url: '/schema/upload',
        method: 'post',
        data: data,
        headers: {
            'Content-Type': 'multipart/form-data'
        }
    });
};
 
export const getSqlFiles = () => {
    return request({
        url: '/schema/files',
        method: 'get'
    });
};
 
export const deleteSqlFile = (sqlId: number) => {
    return request({
        url: `/schema/sql/${sqlId}`,
        method: 'delete'
    });
};
 
export const updateSqlFile = (sqlId: number, data: { filename?: string; file_content?: string }) => {
    return request({
        url: `/schema/sql/${sqlId}`,
        method: 'put',
        data: data
    });
};

// // 生成自然语言查询
// export const generateNLQueries = (schemaIds: number[]) => {
//     return request({
//         url: `/llm/generate_nl_queries`,
//         method: 'post',
//         data: { schema_ids: schemaIds }
//     });
// };
export const generateQueries = (data: {
    schema_ids: number[];
    points: Array<{
        id: number;
        generateCount: number;
    }>;
}) => {
    return request({
        url: '/llm/generate_nl_queries',
        method: 'post',
        data: {
            schema_ids: data.schema_ids,
            points: data.points.map(point => ({
                id: point.id,
                generateCount: point.generateCount || 1
            }))
        }
    });
};
// 获取查询列表
export const getNLQueries = (params: {
    schema_ids: number[];
    page: number;
    page_size: number;
}) => {
    return request({
        url: '/llm/nl_queries',
        method: 'get',
        params: {
            ...params,
            schema_ids: params.schema_ids.join(',')  // 转换为逗号分隔的字符串
        }
    });
};

// 生成SQL
export const generateNLToSQL = (data) => {
    return request({
        url: '/llm/generate_sql',
        method: 'post',
        data
    });
};

// 获取dashboard统计数据
export const getStats = () => {
    return request({
        url: '/dashboard/stats',
        method: 'get'
    });
};

// 获取最近的查询记录
export const getRecentQueries = () => {
    return request({
        url: '/dashboard/recent-queries',
        method: 'get'
    });
};
// 获取模型列表
export const getModels = () => {
    return request({
        url: '/chat/models',
        method: 'get'
    });
};

// 获取聊天历史
export const getChatHistory = () => {
    return request({
        url: '/chat/messages',
        method: 'get'
    });
};

// 发送聊天消息
export const sendChatMessage = (data: {
    model: string;
    messages: Array<{
        role: string;
        content: string;
    }>;
}) => {
    return request({
        url: '/chat/chat',
        method: 'post',
        data
    });
};
export const getKnowledgeCategories = () => {
    return request({
        url: '/knowledge/categories',
        method: 'get'
    });
};
 

// 获取分页的知识点列表
export const getKnowledgePointsPaginated = (params: {
    page: number;
    pageSize: number;
    category_id?: number;
    keyword?: string;
}) => {
    return request({
        url: '/knowledge/points/page',
        method: 'get',
        params
    });
};
export const addKnowledgeCategory = (data: {
    category_name: string;
    description: string;
}) => {
    return request({
        url: '/knowledge/categories',
        method: 'post',
        data
    });
};
export const updateKnowledgeCategory = (id: number, data: {
    category_name: string;
    description: string;
}) => {
    return request({
        url: `/knowledge/categories/${id}`,
        method: 'put',
        data
    });
};

export const deleteKnowledgeCategory = (id: number) => {
    return request({
        url: `/knowledge/categories/${id}`,
        method: 'delete'
    });
};



export const getKnowledgePoints = () => {
    return request({
        url: '/knowledge/points',
        method: 'get'
    });
};

export const addKnowledgePoint = (data: {
    category_id: number;
    point_name: string;
    description: string;
    example_sql: string;
    explanation: string;
}) => {
    return request({
        url: '/knowledge/points',
        method: 'post',
        data
    });
};

export const updateKnowledgePoint = (id: number, data: {
    category_id: number;
    point_name: string;
    description: string;
    example_sql: string;
    explanation: string;
}) => {
    return request({
        url: `/knowledge/points/${id}`,
        method: 'put',
        data
    });
};

export const deleteKnowledgePoint = (id: number) => {
    return request({
        url: `/knowledge/points/${id}`,
        method: 'delete'
    });
};
 


//额，这个是src/api/index.ts,在这里进行接口管理，方便复用，以前每个页面都写请求函数，是有点重用率低
