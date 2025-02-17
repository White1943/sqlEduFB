<template>
    <div class="nl-queries">
        <div class="header">
            <h2>自然语言查询管理</h2>
            <div class="header-right">
                <!-- Schema选择器 -->
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

                <!-- 知识点选择按钮 -->
                <el-button 
                    type="primary" 
                    @click="showKnowledgeDialog"
                    style="margin-right: 15px;"
                >
                    选择知识点
                </el-button>

                <el-button 
                    type="primary" 
                    @click="handleGenerateQueries"
                    :disabled="!canGenerate"
                >
                    生成查询
                </el-button>
            </div>
        </div>

        <!-- 已选知识点展示 -->
        <div class="selected-points" v-if="selectedPoints.length">
            <h3>已选知识点：</h3>
            <el-row :gutter="20">
                <el-col :span="8" v-for="point in selectedPoints" :key="point.id">
                    <el-card class="point-card">
                        <template #header>
                            <div class="point-header">
                                <span>{{ point.point_name }}</span>
                                <el-input-number 
                                    v-model="point.generateCount" 
                                    :min="1" 
                                    :max="10"
                                    size="small"
                                />
                            </div>
                        </template>
                        <div class="point-content">
                            <p>{{ point.description }}</p>
                            <el-button 
                                type="danger" 
                                link 
                                @click="removePoint(point)"
                            >
                                移除
                            </el-button>
                        </div>
                    </el-card>
                </el-col>
            </el-row>
        </div>

        <!-- 查询列表 -->
        <el-table :data="queries" style="width: 100%; margin-top: 20px">
            <el-table-column prop="id" label="ID" width="80" />
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
            <el-table-column prop="knowledge_point" label="知识点" />
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

        <!-- 分页器 -->
        <div class="pagination">
            <el-pagination
                v-model:current-page="currentPage"
                v-model:page-size="pageSize"
                :page-sizes="[10, 20, 50, 100]"
                :total="total"
                layout="total, sizes, prev, pager, next, jumper"
                @size-change="handleSizeChange"
                @current-change="handleCurrentChange"
            />
        </div>

        <!-- 知识点选择对话框 -->
        <el-dialog
            v-model="knowledgeDialog.visible"
            title="选择知识点"
            width="70%"
        >
            <div class="knowledge-filter">
                <el-select
                    v-model="knowledgeDialog.categoryId"
                    placeholder="选择分类"
                    clearable
                    @change="fetchDialogPoints"
                >
                    <el-option
                        v-for="category in categories"
                        :key="category.id"
                        :label="category.category_name"
                        :value="category.id"
                    />
                </el-select>
            </div>
            <el-table
                :data="knowledgeDialog.points"
                @selection-change="handleSelectionChange"
            >
                <el-table-column type="selection" width="55" />
                <el-table-column prop="category_name" label="分类" />
                <el-table-column prop="point_name" label="知识点" />
                <el-table-column prop="description" label="描述" show-overflow-tooltip />
            </el-table>
        </el-dialog>

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
import { ref, computed, onMounted, watch } from 'vue';
import { ElMessage } from 'element-plus';
import { 
    generateNLQueries, 
    getNLQueries, 
    generateNLToSQL, 
    getSqlFiles,
    getKnowledgeCategories,
    getKnowledgePointsPaginated 
} from '@/api/index';

const queries = ref([]);
const dialogVisible = ref(false);
const dialogTitle = ref('');
const dialogType = ref('sql');
const currentSQL = ref('');
const currentSchema = ref('');
const selectedSchemaIds = ref([]);
const schemas = ref([]);
const currentPage = ref(1);
const pageSize = ref(10);
const total = ref(0);
const selectedPoints = ref([]);
const categories = ref([]);

const knowledgeDialog = ref({
    visible: false,
    categoryId: null,
    points: [],
    selectedPoints: []
});

// 计算是否可以生成查询
const canGenerate = computed(() => {
    return selectedSchemaIds.value.length > 0 || selectedPoints.value.length > 0;
});

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

// 获取分类列表
const fetchCategories = async () => {
    try {
        const res = await getKnowledgeCategories();
        if (res.data.status === 'success') {
            categories.value = res.data.data;
        }
    } catch (error) {
        ElMessage.error('获取分类列表失败');
    }
};

// 获取知识点列表
const fetchDialogPoints = async () => {
    try {
        const res = await getKnowledgePointsPaginated({
            page: 1,
            pageSize: 1000,  // 暂时获取所有知识点
            category_id: knowledgeDialog.value.categoryId
        });
        if (res.data.status === 'success') {
            knowledgeDialog.value.points = res.data.data.items;
        }
    } catch (error) {
        ElMessage.error('获取知识点列表失败');
    }
};

// 处理知识点选择变化
const handleSelectionChange = (selection) => {
    knowledgeDialog.value.selectedPoints = selection;
};

// 确认选择知识点
const confirmSelection = () => {
    const newPoints = knowledgeDialog.value.selectedPoints.map(point => ({
        ...point,
        generateCount: 1  // 默认生成1条
    }));
    
    // 合并已选和新选的知识点，避免重复
    const existingIds = selectedPoints.value.map(p => p.id);
    const pointsToAdd = newPoints.filter(p => !existingIds.includes(p.id));
    selectedPoints.value.push(...pointsToAdd);
    
    knowledgeDialog.value.visible = false;
};

// 移除知识点
const removePoint = (point) => {
    selectedPoints.value = selectedPoints.value.filter(p => p.id !== point.id);
};

// 显示知识点选择对话框
const showKnowledgeDialog = async () => {
    knowledgeDialog.value.visible = true;
    await fetchCategories();
    await fetchDialogPoints();
};

// 生成查询
const handleGenerateQueries = async () => {
    if (!selectedSchemaIds.value.length && !selectedPoints.value.length) {
        ElMessage.warning('请选择数据库模式或知识点');
        return;
    }

    try {
        const response = await generateNLQueries({
            schema_ids: selectedSchemaIds.value,
            knowledge_points: selectedPoints.value.map(point => ({
                id: point.id,
                count: point.generateCount
            }))
        });
        
        if (response.data.status === 'success') {
            ElMessage.success('生成查询成功');
            fetchQueries();
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

// 分页处理
const handleSizeChange = (val: number) => {
    pageSize.value = val;
    fetchQueries();
};

const handleCurrentChange = (val: number) => {
    currentPage.value = val;
    fetchQueries();
};

// 修改获取查询列表的方法
const fetchQueries = async () => {
    if (!selectedSchemaIds.value.length) {
        queries.value = [];
        return;
    }
    
    try {
        const allQueries = [];
        for (const schemaId of selectedSchemaIds.value) {
            const response = await getNLQueries(schemaId, {
                page: currentPage.value,
                pageSize: pageSize.value
            });
            if (response.data.status === 'success') {
                allQueries.push(...response.data.data.items);
                total.value = response.data.data.total;
            }
        }
        queries.value = allQueries;
    } catch (error) {
        ElMessage.error('获取查询列表失败');
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
.selected-points {
    margin: 20px 0;
}
.point-card {
    margin-bottom: 15px;
}
.point-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
}
.point-content {
    display: flex;
    flex-direction: column;
    gap: 10px;
}
.knowledge-filter {
    margin-bottom: 20px;
}
.pagination {
    margin-top: 20px;
    display: flex;
    justify-content: flex-end;
}
pre {
    white-space: pre-wrap;
    word-wrap: break-word;
}
</style>