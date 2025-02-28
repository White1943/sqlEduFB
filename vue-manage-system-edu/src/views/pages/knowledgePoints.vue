<template>
    <div class="points-manage">
        <div class="header">
            <h2>知识点管理</h2>
            <div class="search-area">
                <el-select
                    v-model="searchForm.category_id"
                    placeholder="选择分类"
                    clearable
                    @change="handleSearch"
                    style="width: 200px; margin-right: 15px;"
                >
                    <el-option
                        v-for="category in categories"
                        :key="category.id"
                        :label="category.category_name"
                        :value="category.id"
                    />
                </el-select>
                <el-input
                    v-model="searchForm.keyword"
                    placeholder="搜索知识点名称"
                    style="width: 200px; margin-right: 15px;"
                    clearable
                    @keyup.enter="handleSearch"
                >
                    <template #prefix>
                        <el-icon><Search /></el-icon>
                    </template>
                </el-input>
                <el-button type="primary" @click="handleAddPoint">
                    新增知识点
                </el-button>
            </div>
        </div>

        <el-table :data="points" style="width: 100%" v-loading="loading">
            <el-table-column prop="id" label="ID" width="80" />
            <el-table-column prop="category_name" label="所属分类" width="120" />
            <el-table-column prop="point_name" label="知识点名称" width="180" />
            <el-table-column prop="description" label="描述" show-overflow-tooltip />
            <el-table-column label="操作" width="250" fixed="right">
                <template #default="scope">
                    <el-button type="primary" size="small" @click="handleViewPoint(scope.row)">
                        查看
                    </el-button>
                    <el-button type="warning" size="small" @click="handleEditPoint(scope.row)">
                        编辑
                    </el-button>
                    <el-button type="danger" size="small" @click="handleDeletePoint(scope.row)">
                        删除
                    </el-button>
                </template>
            </el-table-column>
        </el-table>

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

        <!-- 知识点表单对话框 -->
        <el-dialog
            v-model="pointDialog.visible"
            :title="pointDialog.isEdit ? '编辑知识点' : '新增知识点'"
            width="60%"
        >
            <el-form :model="pointForm" :rules="pointRules" ref="pointFormRef" label-width="100px">
                <el-form-item label="所属分类" prop="category_id">
                    <el-select v-model="pointForm.category_id" placeholder="请选择分类">
                        <el-option
                            v-for="category in categories"
                            :key="category.id"
                            :label="category.category_name"
                            :value="category.id"
                        />
                    </el-select>
                </el-form-item>
                <el-form-item label="知识点名称" prop="point_name">
                    <el-input v-model="pointForm.point_name" />
                </el-form-item>
                <el-form-item label="描述" prop="description">
                    <el-input type="textarea" v-model="pointForm.description" rows="3" />
                </el-form-item>
                <el-form-item label="SQL样例" prop="example_sql">
                    <el-input type="textarea" v-model="pointForm.example_sql" rows="4" />
                </el-form-item>
                <el-form-item label="样例讲解" prop="explanation">
                    <el-input type="textarea" v-model="pointForm.explanation" rows="4" />
                </el-form-item>
            </el-form>
            <template #footer>
                <el-button @click="pointDialog.visible = false">取消</el-button>
                <el-button type="primary" @click="savePointForm">确定</el-button>
            </template>
        </el-dialog>

        <!-- 知识点查看对话框 -->
        <el-dialog
            v-model="viewDialog.visible"
            title="知识点详情"
            width="60%"
        >
            <div class="view-content">
                <h3>{{ currentPoint.point_name }}</h3>
                <div class="view-item">
                    <h4>所属分类：</h4>
                    <p>{{ currentPoint.category_name }}</p>
                </div>
                <div class="view-item">
                    <h4>描述：</h4>
                    <p>{{ currentPoint.description }}</p>
                </div>
                <div class="view-item">
                    <h4>SQL样例：</h4>
                    <pre>{{ currentPoint.example_sql }}</pre>
                </div>
                <div class="view-item">
                    <h4>样例讲解：</h4>
                    <p>{{ currentPoint.explanation }}</p>
                </div>
            </div>
        </el-dialog>
    </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { ElMessage, ElMessageBox } from 'element-plus';
import type { FormInstance, FormRules } from 'element-plus';
import { Search } from '@element-plus/icons-vue';
import {
    getKnowledgeCategories,
    getKnowledgePointsPaginated,
    addKnowledgePoint,
    updateKnowledgePoint,
    deleteKnowledgePoint
} from '@/api/index';

const loading = ref(false);
const categories = ref([]);
const points = ref([]);
const total = ref(0);
const currentPage = ref(1);
const pageSize = ref(10);

const searchForm = ref({
    category_id: null as number | null,
    keyword: ''
});

const pointDialog = ref({
    visible: false,
    isEdit: false
});

const viewDialog = ref({
    visible: false
});

const currentPoint = ref({});
const pointFormRef = ref<FormInstance>();

const pointForm = ref({
    id: null,
    category_id: null,
    point_name: '',
    description: '',
    example_sql: '',
    explanation: ''
});

const pointRules = ref<FormRules>({
    category_id: [{ required: true, message: '请选择所属分类', trigger: 'change' }],
    point_name: [{ required: true, message: '请输入知识点名称', trigger: 'blur' }],
    description: [{ required: true, message: '请输入描述', trigger: 'blur' }],
    example_sql: [{ required: true, message: '请输入SQL样例', trigger: 'blur' }]
});

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
const fetchPoints = async () => {
    loading.value = true;
    try {
        const res = await getKnowledgePointsPaginated({
            page: currentPage.value,
            pageSize: pageSize.value,
            category_id: searchForm.value.category_id || undefined,
            keyword: searchForm.value.keyword || undefined
        });
        if (res.data.status === 'success') {
            points.value = res.data.data.items;
            total.value = res.data.data.total;
        }
    } catch (error) {
        ElMessage.error('获取知识点列表失败');
    } finally {
        loading.value = false;
    }
};

// 处理搜索
const handleSearch = () => {
    currentPage.value = 1;
    fetchPoints();
};

// 处理分页大小变化
const handleSizeChange = (val: number) => {
    pageSize.value = val;
    fetchPoints();
};

// 处理页码变化
const handleCurrentChange = (val: number) => {
    currentPage.value = val;
    fetchPoints();
};

// 处理新增知识点
const handleAddPoint = () => {
    pointDialog.value.isEdit = false;
    pointDialog.value.visible = true;
    pointForm.value = {
        id: null,
        category_id: null,
        point_name: '',
        description: '',
        example_sql: '',
        explanation: ''
    };
};

// 处理编辑知识点
const handleEditPoint = (row) => {
    pointDialog.value.isEdit = true;
    pointDialog.value.visible = true;
    pointForm.value = { ...row };
};

// 处理查看知识点
const handleViewPoint = (row) => {
    currentPoint.value = row;
    viewDialog.value.visible = true;
};

// 处理删除知识点
const handleDeletePoint = async (row) => {
    try {
        await ElMessageBox.confirm('确定要删除该知识点吗？', '警告', {
            type: 'warning',
            confirmButtonText: '确定',
            cancelButtonText: '取消'
        });
        await deleteKnowledgePoint(row.id);
        ElMessage.success('删除成功');
        fetchPoints();
    } catch (error) {
        if (error !== 'cancel') {
            ElMessage.error('删除失败');
        }
    }
};

// 保存知识点表单
const savePointForm = async () => {
    if (!pointFormRef.value) return;
    
    await pointFormRef.value.validate(async (valid) => {
        if (valid) {
            try {
                if (pointDialog.value.isEdit) {
                    await updateKnowledgePoint(pointForm.value.id, pointForm.value);
                } else {
                    await addKnowledgePoint(pointForm.value);
                }
                ElMessage.success(pointDialog.value.isEdit ? '更新成功' : '添加成功');
                pointDialog.value.visible = false;
                fetchPoints();
            } catch (error) {
                ElMessage.error(pointDialog.value.isEdit ? '更新失败' : '添加失败');
            }
        }
    });
};

onMounted(() => {
    fetchCategories();
    fetchPoints();
});
</script>

<style scoped>
.points-manage {
    padding: 20px;
}

.header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
}

.search-area {
    display: flex;
    align-items: center;
}

.pagination {
    margin-top: 20px;
    display: flex;
    justify-content: flex-end;
}

.view-content {
    padding: 20px;
}

.view-item {
    margin-bottom: 20px;
}

.view-item h4 {
    margin-bottom: 8px;
    color: #9b9da1;
}

.view-item pre {
    background: #aeafb0;
    padding: 12px;
    border-radius: 10px;
    margin: 0;
    white-space: pre-wrap;
    word-wrap: break-word;
}

:deep(.el-table) {
    margin-bottom: 20px;
}
</style> 