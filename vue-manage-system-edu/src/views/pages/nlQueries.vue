<template>
    <div class="nl-queries">
        <div class="header">
            <h2>自然语言查询管理</h2>
            <div class="header-right">
                <!-- 添加多选的 schema 选择器 -->
                <el-select
                    v-model="selectedSchemaIds"
                    multiple
                    collapse-tags
                    collapse-tags-tooltip
                    placeholder="请选择数据库模式"
                    style="margin-right: 15px; min-width: 240px;"
                >
                    <el-option
                        v-for="schema in schemas"
                        :key="schema.id"
                        :label="schema.filename"
                        :value="schema.id"
                    >
                        <span style="float: left">{{ schema.filename }}</span>
                        <el-button
                            link
                            type="primary"
                            size="small"
                            @click.stop="viewSchema(schema)"
                        >
                            查看
                        </el-button>
                    </el-option>
                </el-select>
                <el-button 
                    type="primary" 
                    @click="handleGenerateQueries"
                    :disabled="!selectedSchemaIds.length"
                >
                    生成查询
                </el-button>
            </div>
        </div>

        <el-table :data="queries" style="width: 100%">
            <el-table-column prop="id" label="ID" width="80" />
            <!-- <el-table-column prop="query_text" label="查询描述" /> -->
            <el-table-column prop="query_text" label="查询描述">
                <template #default="scope">
                    <div v-if="!scope.row.isEditing">
                        {{ scope.row.query_text }}
                    </div>
                    <el-input
                        v-else
                        v-model="scope.row.query_text"
                        type="textarea"
                    />
                </template>
            </el-table-column>

            <el-table-column prop="involved_tables" label="涉及表" />
            <el-table-column prop="schema_ids" label="Schema IDs" />
            <el-table-column prop="status" label="状态" width="100">
                <template #default="scope">
                    <el-tag :type="getStatusType(scope.row.status)">
                        {{ scope.row.status }}
                    </el-tag>
                </template>
            </el-table-column>
            <el-table-column label="操作" width="250">
                <template #default="scope">
                    <el-button
                        v-if="!scope.row.generated_sql"
                        type="primary"
                        size="small"
                        @click="handleGenerateSQL(scope.row)"
                    >
                        生成SQL
                    </el-button>
                    <el-button
                        type="success"
                        size="small"
                        @click="handleViewSQL(scope.row)"
                        v-if="scope.row.generated_sql"
                    >
                        查看SQL
                    </el-button>
                    <el-button
                        type="warning"
                        size="small"
                        @click="handleEdit(scope.row)"
                    >
                        编辑
                    </el-button>
                    <el-button
                        type="danger"
                        size="small"
                        @click="handleDelete(scope.row)"
                    >
                        删除
                    </el-button>
                </template>
            </el-table-column>
        </el-table>

        <!-- SQL预览对话框 -->
        <el-dialog
            v-model="dialogVisible"
            :title="dialogTitle"
            width="50%"
        >
            <pre v-if="dialogType === 'sql'">{{ currentSQL }}</pre>
            <div v-else-if="dialogType === 'schema'" v-html="currentSchema"></div>
        </el-dialog>
    </div>
</template>

<script setup lang="ts">
import { ref, onMounted, watch } from 'vue';
import { ElMessage } from 'element-plus';
import { generateNLQueries, getNLQueries, generateNLToSQL, getSqlFiles } from '@/api/index';

const queries = ref([]);
const dialogVisible = ref(false);
const dialogTitle = ref('');
const dialogType = ref('sql');
const currentSQL = ref('');
const currentSchema = ref('');
const selectedSchemaIds = ref([]);
const schemas = ref([]);

// 获取所有schema
const fetchSchemas = async () => {
    try {
        const response = await getSqlFiles();
        if (response.data.status === 'success') {
            schemas.value = response.data.data;
        }
    } catch (error) {
        ElMessage.error('获取数据库模式列表失败');
    }
};

// 查看schema内容
const viewSchema = (schema) => {
    dialogType.value = 'schema';
    dialogTitle.value = `Schema: ${schema.filename}`;
    currentSchema.value = schema.file_content.replace(/\n/g, '<br>');
    dialogVisible.value = true;
};

// 获取查询列表
const fetchQueries = async () => {
    if (!selectedSchemaIds.value.length) {
        queries.value = [];
        return;
    }
    
    try {
        // 获取所有选中schema的查询列表
        const allQueries = [];
        for (const schemaId of selectedSchemaIds.value) {
            const response = await getNLQueries(schemaId);
            if (response.data.status === 'success') {
                allQueries.push(...response.data.data);
            }
        }
        // 按创建时间排序
        queries.value = allQueries.sort((a, b) => 
            new Date(b.created_at) - new Date(a.created_at)
        );
    } catch (error) {
        ElMessage.error('获取查询列表失败');
    }
};

// 生成查询
const handleGenerateQueries = async () => {
    if (!selectedSchemaIds.value.length) {
        ElMessage.warning('请先选择数据库模式');
        return;
    }

    try {
        // 发送所有选中的schema id，让后端基于这些schema生成查询
        const response = await generateNLQueries(selectedSchemaIds.value);
        if (response.data.status === 'success') {
            ElMessage.success('生成查询成功');
            fetchQueries();  // 刷新查询列表
        }
    } catch (error) {
        ElMessage.error('生成查询失败');
    }
};

// 查看SQL
const handleViewSQL = (row) => {
    dialogType.value = 'sql';
    dialogTitle.value = 'SQL预览';
    currentSQL.value = row.generated_sql;
    dialogVisible.value = true;
};

// 获取状态类型
const getStatusType = (status) => {
    const statusMap = {
        pending: '',
        approved: 'success',
        rejected: 'danger'
    };
    return statusMap[status] || '';
};

// 生成SQL
const handleGenerateSQL = async (row) => {
    try {
        // 构造请求数据
        const requestData = {
            query_id: row.id,
            query_text: row.query_text,
            involved_tables: row.involved_tables,
            schema_ids: row.schema_ids
        };
        
        const response = await generateNLToSQL(requestData);
        if (response.data.status === 'success') {
            ElMessage.success('SQL生成成功');
            fetchQueries();
        }
    } catch (error) {
        ElMessage.error('SQL生成失败');
    }
};

onMounted(() => {
    fetchSchemas();
});

// 监听选中的schema变化
watch(selectedSchemaIds, (newVal) => {
    if (newVal.length) {
        fetchQueries();
    } else {
        queries.value = [];
    }
});
</script>

<style scoped>
.nl-queries {
    padding: 20px;
}
.header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
}
.header-right {
    display: flex;
    align-items: center;
}
pre {
    white-space: pre-wrap;
    word-wrap: break-word;
}
</style>