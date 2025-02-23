<template>
    <div class="nl-queries">
        <div class="header">
            <h2>自然语言查询管理</h2>
            <div class="header-right">
                <!-- Schema选择器和查看按钮 -->
                <div class="schema-selector">
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
                            <div class="schema-option">
                                <span>{{ schema.filename }}</span>
                                <el-button 
                                    type="primary" 
                                    link
                                    @click.stop="viewSchema(schema)"
                                >
                                    查看
                                </el-button>
                            </div>
                        </el-option>
                    </el-select>
                </div>
                
                <!-- 知识点选择按钮 -->
                <el-button 
                    type="primary" 
                    @click="showKnowledgeDialog"
                    style="margin-right: 15px;"
                    :disabled="isKnowledgeDialogDisabled"
                >
                    选择知识点
                </el-button>

                <!-- 知识点大类选择按钮 -->
                <el-button 
                    type="primary" 
                    @click="showCategoryDialog"
                    style="margin-right: 15px;"
                    :disabled="isCategoryDialogDisabled"
                >
                    选择知识点大类
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

        <div class="usage-tip">
            <el-alert 
                title="提示：选择知识点和知识点大类只能选择其中一个，请先确认选择方式。选择后需要清空当前选择才能切换到另一种选择方式。
                知识点大类对应的数量是，该大类下每个知识点生成的数量" 
                type="info" 
                :closable="false"
            />
        </div>

        <!-- 已选知识点和知识点大类展示 -->
        <div class="selected-points" v-if="selectedPoints.length || selectedCategories.length">
            <div class="selected-points-header">
                <h3>已选{{ selectedPoints.length ? '知识点' : '知识点大类' }}</h3>
                <el-button type="danger" link @click="clearSelected">清空所有</el-button>
            </div>
            <el-row :gutter="20">
                <!-- 显示已选知识点 -->
                <template v-if="selectedPoints.length">
                    <el-col :span="8" v-for="point in selectedPoints" :key="point.id">
                        <el-card class="point-card">
                            <template #header>
                                <div class="point-header">
                                    <span>{{ point.point_name }} (所属大类: {{ point.category_name }})</span>
                                    <el-input-number 
                                        v-model="point.generateCount" 
                                        :min="1" 
                                        :max="20"
                                        size="small"
                                        @change="updatePointCount(point)"
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
                </template>

                <!-- 显示已选知识点大类 -->
                <template v-if="selectedCategories.length">
                    <el-col :span="8" v-for="category in selectedCategories" :key="category.id">
                        <el-card class="point-card">
                            <template #header>
                                <div class="point-header">
                                    <span>{{ category.category_name }}</span>
                                    <el-input-number 
                                        v-model="category.generateCount" 
                                        :min="1" 
                                        :max="20"
                                        size="small"
                                        @change="updateCategoryCount(category)"
                                    />
                                </div>
                            </template>
                            <div class="point-content">
                                <p>{{ category.description }}</p>
                                <el-button 
                                    type="danger" 
                                    link
                                    @click="removeCategory(category)"
                                >
                                    移除
                                </el-button>
                            </div>
                        </el-card>
                    </el-col>
                </template>
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
        <el-dialog
            v-model="editDialogVisible"
            title="编辑查询"
            width="50%"
        >
            <el-form :model="editForm" label-width="120px">
                <el-form-item label="查询描述">
                    <el-input
                        v-model="editForm.query_text"
                        type="textarea"
                        rows="4"
                    />
                </el-form-item>
                <el-form-item label="涉及的表">
                    <el-input v-model="editForm.involved_tables" />
                </el-form-item>
            </el-form>
            <template #footer>
                <span class="dialog-footer">
                    <el-button @click="editDialogVisible = false">取消</el-button>
                    <el-button type="primary" @click="confirmEdit">
                        确认
                    </el-button>
                </span>
            </template>
        </el-dialog>
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
        <el-dialog v-model="knowledgeDialog.visible" title="选择知识点" width="70%">
            <el-table :data="knowledgeDialog.points" @selection-change="handleSelectionChange" style="width: 100%">
                <el-table-column type="selection" width="55" />
                <el-table-column prop="point_name" label="知识点名称" />
                <el-table-column prop="description" label="描述" show-overflow-tooltip />
                <el-table-column label="生成数量" width="150">
                    <template #default="{ row }">
                        <el-input-number
                            v-model="row.generateCount"
                            :min="1"
                            :max="50"
                            size="small"
                        />
                    </template>
                </el-table-column>
            </el-table>

            <template #footer>
                <span class="dialog-footer">
                    <el-button @click="knowledgeDialog.visible = false">取消</el-button>
                    <el-button type="primary" @click="confirmSelection">确定</el-button>
                </span>
            </template>
        </el-dialog>

        <!-- 知识点大类选择对话框 -->
        <el-dialog v-model="categoryDialog.visible" title="选择知识点大类" width="70%">
            <el-table :data="categoryDialog.categories" @selection-change="handleCategorySelectionChange" style="width: 100%">
                <el-table-column type="selection" width="55" />
                <el-table-column prop="category_name" label="大类名称" />
                <el-table-column prop="description" label="描述" show-overflow-tooltip />
                <el-table-column label="生成数量" width="150">
                    <template #default="{ row }">
                        <el-input-number
                            v-model="row.generateCount"
                            :min="1"
                            :max="50"
                            size="small"
                        />
                    </template>
                </el-table-column>
            </el-table>

            <template #footer>
                <span class="dialog-footer">
                    <el-button @click="categoryDialog.visible = false">取消</el-button>
                    <el-button type="primary" @click="confirmCategorySelection">确定</el-button>
                </span>
            </template>
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
import { ref, computed, onMounted, watch, reactive } from 'vue';
import { ElMessage, ElMessageBox, ElLoading } from 'element-plus';
import { 
    getNLQueries, 
    generateNLToSQL, 
    getSqlFiles,
    getKnowledgeCategories,
    getKnowledgePointsPaginated,
    generateQueries,
    updateNLQuery,
    deleteNLQuery,
    getKnowledgePointsByCategory
} from '@/api/index';

// 基础数据
const queries = ref([]);
const selectedSchemaIds = ref([]);
const schemas = ref([]);
const currentPage = ref(1);
const pageSize = ref(10);
const total = ref(0);
const selectedPoints = ref([]);
const selectedCategories = ref([]);
const categories = ref([]);

// 对话框状态
const dialogVisible = ref(false);
const dialogTitle = ref('');
const dialogType = ref('sql');
const currentSQL = ref('');
const currentSchema = ref('');
const editDialogVisible = ref(false);

// 知识点对话框
const knowledgeDialog = ref({
    visible: false,
    categoryId: null,
    points: [],
    selectedPoints: []
});

// 知识点大类对话框状态
const categoryDialog = reactive({
    visible: false,
    categories: [], // 存储知识点大类数据
    selectedCategories: []
});

// 编辑表单
const editForm = reactive({
    id: 0,
    query_text: '',
    involved_tables: '',
    schema_ids: '',
    knowledge_point_id: 0
});

// 计算属性
const canGenerate = computed(() => {
    return selectedSchemaIds.value.length > 0 && (selectedPoints.value.length > 0 || selectedCategories.value.length > 0);
});

// 控制选择状态
const isCategoryDialogDisabled = computed(() => {
    return selectedPoints.value.length > 0; // 如果已选择知识点，则禁用选择大类按钮
});

const isKnowledgeDialogDisabled = computed(() => {
    return selectedCategories.value.length > 0; // 如果已选择知识点大类，则禁用选择知识点按钮
});

// 获取数据的方法
const fetchSchemas = async () => {  //获取数据库模式列表
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

const fetchQueries = async () => {
    if (!selectedSchemaIds.value.length) {
        queries.value = [];
        total.value = 0;
        return;
    }
    
    try {
        const response = await getNLQueries({
            schema_ids: selectedSchemaIds.value,
            page: currentPage.value,
            page_size: pageSize.value
        });
        
        if (response.data.status === 'success') {
            queries.value = response.data.data.items;
            total.value = response.data.data.total;
        }
    } catch (error) {
        console.error('获取查询列表失败:', error);
        ElMessage.error('获取查询列表失败');
    }
};

// 获取知识点大类数据
const fetchCategories = async () => {
    try {
        const res = await getKnowledgeCategories();
        if (res.data.status === 'success') {
            // 直接将数据赋值给 categoryDialog.categories
            categoryDialog.categories = res.data.data.map(category => ({
                ...category,
                generateCount: 1
            }));
        }
    } catch (error) {
        ElMessage.error('获取知识点分类列表失败');
    }
};

const fetchDialogPoints = async () => {
    try {
        const res = await getKnowledgePointsPaginated({
            page: 1,
            pageSize: 1000,
            category_id: knowledgeDialog.value.categoryId
        });
        if (res.data.status === 'success') {
            knowledgeDialog.value.points = res.data.data.items.map(point => ({
                ...point,
                generateCount: 1
            }));
        }
    } catch (error) {
        ElMessage.error('获取知识点列表失败');
    }
};

// 对话框相关方法
const showKnowledgeDialog = async () => {
    if (selectedCategories.value.length > 0) {
        ElMessage.warning('请先清空已选择的知识点大类');
        return;
    }
    knowledgeDialog.value.visible = true;
    await fetchCategories();
    await fetchDialogPoints();
};

// 显示知识点大类选择对话框
const showCategoryDialog = async () => {
    if (selectedPoints.value.length > 0) {
        ElMessage.warning('请先清空已选择的知识点');
        return;
    }
    await fetchCategories(); // 先获取数据
    categoryDialog.visible = true; // 再显示对话框
};

// 选择处理方法
const handleSelectionChange = (selection) => {
    knowledgeDialog.value.selectedPoints = selection;
};

// 处理知识点大类选择变化
const handleCategorySelectionChange = (selection) => {
    categoryDialog.selectedCategories = selection;
};

// 确认选择方法
const confirmSelection = () => {
    const newPoints = knowledgeDialog.value.selectedPoints.map(point => ({
        ...point,
        generateCount: point.generateCount || 1
    }));
    
    const existingIds = selectedPoints.value.map(p => p.id);
    const pointsToAdd = newPoints.filter(p => !existingIds.includes(p.id));
    selectedPoints.value.push(...pointsToAdd);
    
    knowledgeDialog.value.visible = false;
};

// 确认知识点大类选择
const confirmCategorySelection = () => {
    const newCategories = categoryDialog.selectedCategories.map(category => ({
        ...category,
        generateCount: category.generateCount || 1
    }));
    
    // 更新已选择的知识点大类
    selectedCategories.value = newCategories;
    
    categoryDialog.visible = false;
    ElMessage.success('已选择知识点大类');
};

// 其他方法
const updatePointCount = (point) => {
    const index = selectedPoints.value.findIndex(p => p.id === point.id);
    if (index !== -1) {
        selectedPoints.value[index].generateCount = point.generateCount;
    }
};

const updateCategoryCount = (category) => {
    const index = selectedCategories.value.findIndex(c => c.id === category.id);
    if (index !== -1) {
        selectedCategories.value[index].generateCount = category.generateCount;
    }
};

const removePoint = (point) => {
    selectedPoints.value = selectedPoints.value.filter(p => p.id !== point.id);
    if (selectedPoints.value.length === 0) {
        ElMessage.info('已清空所有知识点，现在可以选择知识点大类了');
    }
};

const removeCategory = (category) => {
    selectedCategories.value = selectedCategories.value.filter(c => c.id !== category.id);
    if (selectedCategories.value.length === 0) {
        ElMessage.info('已清空所有知识点大类，现在可以选择知识点了');
    }
};

const clearSelected = () => {
    selectedPoints.value = [];
    selectedCategories.value = [];
    ElMessage.success('已清空所有选择');
};

// 监听器
watch(selectedSchemaIds, (newVal) => {
    if (newVal.length) {
        fetchQueries();
    } else {
        queries.value = [];
    }
});

// 生命周期钩子
onMounted(() => {
    fetchSchemas();
});

 
// 处理生成查询
const handleGenerateQueries = async () => {
    // 检查是否选择了数据库模式
    if (!selectedSchemaIds.value.length) {
        ElMessage.warning('请选择数据库模式');
        return;
    }

    // 检查是否选择了知识点或知识点大类
    if (!selectedPoints.value.length && !selectedCategories.value.length) {
        ElMessage.warning('请选择知识点或知识点大类');
        return;
    }

    try {
        const loading = ElLoading.service({
            lock: true,
            text: '正在生成查询...',
            background: 'rgba(0, 0, 0, 0.7)'
        });

        // 确保数据格式正确
        const requestData = {
            schema_ids: selectedSchemaIds.value,
            points: []
        };

        // 如果选择了知识点，则将其添加到请求数据中
        if (selectedPoints.value.length) {
            requestData.points = selectedPoints.value.map(point => ({
                id: point.id,
                generateCount: parseInt(point.generateCount) || 1  // 确保是数字
            }));
        }

        // 如果选择了知识点大类，则将该大类下的所有知识点信息添加到请求数据中
        if (selectedCategories.value.length) {
            for (const category of selectedCategories.value) {
                try {
                    const response = await getKnowledgePointsByCategory(category.id);
                    console.log('API Response:', response); // 用于调试
                    
                    // 确保我们访问的是 response.data.data，这是后端 ApiResponse.success(data=points_data) 返回的结构
                    const categoryPoints = response.data.data;
                    
                    // 将该分类下所有知识点的 ID 和生成数量添加到请求数据中
                    requestData.points.push(...categoryPoints.map(point => ({
                        id: point.id,
                        generateCount: category.generateCount // 使用分类的生成数量
                    })));
                } catch (error) {
                    console.error('获取知识点失败:', error);
                    ElMessage.error('获取知识点失败，请重试');
                }
            }
        }

        const response = await generateQueries(requestData);
        loading.close();

        if (response.data.status === 'success') {
            ElMessage.success(response.data.message);
            await fetchQueries(); // 等待查询列表刷新完成
            clearSelected(); // 清空已选知识点和大类
        } else {
            ElMessage.error(response.data.message || '生成查询失败');
        }
    } catch (error: any) {
        loading?.close();
        console.error('生成查询失败:', error);
        ElMessage.error(error.response?.data?.message || '生成查询失败');
    }
};

const handleEdit = (row) => {
    editForm.id = row.id;
    editForm.query_text = row.query_text;
    editForm.involved_tables = row.involved_tables;
    editForm.schema_ids = row.schema_ids;
    editForm.knowledge_point_id = row.knowledge_point_id;
    editDialogVisible.value = true;
};

const confirmEdit = async () => {
    try {
        const response = await updateNLQuery(editForm);
        if (response.data.status === 'success') {
            ElMessage.success('更新成功');
            editDialogVisible.value = false;
            // 刷新查询列表
            fetchQueries();
        } else {
            ElMessage.error('更新失败');
        }
    } catch (error) {
        ElMessage.error('更新失败');
    }
};

const handleDelete = (row) => {
    ElMessageBox.confirm(
        '确定要删除这条查询吗？',
        '警告',
        {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            type: 'warning',
        }
    )
        .then(async () => {
            try {
                const response = await deleteNLQuery(row.id);
                if (response.data.status === 'success') {
                    ElMessage.success('删除成功');
                    // 刷新查询列表
                    fetchQueries();
                } else {
                    ElMessage.error('删除失败');
                }
            } catch (error) {
                ElMessage.error('删除失败');
            }
        })
        .catch(() => {
            ElMessage.info('已取消删除');
        });
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
.selected-points-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 15px;
}
.dialog-footer {
    display: flex;
    justify-content: flex-end;
    margin-top: 20px;
}
.usage-tip {
    margin: 20px 0;
}
.schema-option {
    display: flex;
    justify-content: space-between;
    align-items: center;
    width: 100%;
}
.schema-selector {
    display: flex;
    align-items: center;
}
</style>