<template>
    <div class="knowledge-manage">
        <div class="header">
            <h2>知识点管理</h2>
            <div class="header-right">
                <el-button type="primary" @click="handleAddCategory">
                    新增分类
                </el-button>
                <el-button type="primary" @click="handleAddPoint">
                    新增知识点
                </el-button>
            </div>
        </div>

        <!-- 知识点分类表格 -->
        <el-table :data="categories" style="width: 100%; margin-bottom: 20px">
            <el-table-column prop="id" label="ID" width="80" />
            <el-table-column prop="category_name" label="分类名称" />
            <el-table-column prop="description" label="描述" />
            <el-table-column label="操作" width="200">
                <template #default="scope">
                    <el-button type="warning" size="small" @click="handleEditCategory(scope.row)">
                        编辑
                    </el-button>
                    <el-button type="danger" size="small" @click="handleDeleteCategory(scope.row)">
                        删除
                    </el-button>
                </template>
            </el-table-column>
        </el-table>

        <!-- 知识点表格 -->
        <el-table :data="points" style="width: 100%">
            <el-table-column prop="id" label="ID" width="80" />
            <el-table-column prop="category_name" label="所属分类" />
            <el-table-column prop="point_name" label="知识点名称" />
            <el-table-column prop="description" label="描述" show-overflow-tooltip />
            <el-table-column label="操作" width="250">
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

        <!-- 分类对话框 -->
        <el-dialog
            v-model="categoryDialog.visible"
            :title="categoryDialog.isEdit ? '编辑分类' : '新增分类'"
            width="50%"
        >
            <el-form :model="categoryForm" :rules="categoryRules" ref="categoryFormRef" label-width="100px">
                <el-form-item label="分类名称" prop="category_name">
                    <el-input v-model="categoryForm.category_name" />
                </el-form-item>
                <el-form-item label="描述" prop="description">
                    <el-input type="textarea" v-model="categoryForm.description" />
                </el-form-item>
            </el-form>
            <template #footer>
                <el-button @click="categoryDialog.visible = false">取消</el-button>
                <el-button type="primary" @click="saveCategoryForm">确定</el-button>
            </template>
        </el-dialog>

        <!-- 知识点对话框 -->
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
import {
    getKnowledgeCategories,
    getKnowledgePoints,
    addKnowledgeCategory,
    updateKnowledgeCategory,
    deleteKnowledgeCategory,
    addKnowledgePoint,
    updateKnowledgePoint,
    deleteKnowledgePoint
} from '@/api/index';

// 数据定义
const categories = ref([]);
const points = ref([]);
const categoryFormRef = ref<FormInstance>();
const pointFormRef = ref<FormInstance>();

// 对话框状态
const categoryDialog = ref({
    visible: false,
    isEdit: false
});

const pointDialog = ref({
    visible: false,
    isEdit: false
});

const viewDialog = ref({
    visible: false
});

// 表单数据
const categoryForm = ref({
    id: null,
    category_name: '',
    description: ''
});

const pointForm = ref({
    id: null,
    category_id: null,
    point_name: '',
    description: '',
    example_sql: '',
    explanation: ''
});

const currentPoint = ref({});

// 表单验证规则
const categoryRules: FormRules = {
    category_name: [
        { required: true, message: '请输入分类名称', trigger: 'blur' }
    ]
};

const pointRules: FormRules = {
    category_id: [
        { required: true, message: '请选择所属分类', trigger: 'change' }
    ],
    point_name: [
        { required: true, message: '请输入知识点名称', trigger: 'blur' }
    ]
};

// 获取数据
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

const fetchPoints = async () => {
    try {
        const res = await getKnowledgePoints();
        if (res.data.status === 'success') {   
            points.value = res.data.data;      
        }
    } catch (error) {
        ElMessage.error('获取知识点列表失败');
    }
};

// 分类操作
const handleAddCategory = () => {
    categoryDialog.value.isEdit = false;
    categoryDialog.value.visible = true;
    categoryForm.value = {
        id: null,
        category_name: '',
        description: ''
    };
};

const handleEditCategory = (row) => {
    categoryDialog.value.isEdit = true;
    categoryDialog.value.visible = true;
    categoryForm.value = { ...row };
};

const handleDeleteCategory = async (row) => {
    try {
        await ElMessageBox.confirm('确定要删除该分类吗？', '提示', {
            type: 'warning'
        });
        await deleteKnowledgeCategory(row.id);
        ElMessage.success('删除成功');
        fetchCategories();
    } catch (error) {
        if (error !== 'cancel') {
            ElMessage.error('删除失败');
        }
    }
};

const saveCategoryForm = async () => {
    if (!categoryFormRef.value) return;
    
    await categoryFormRef.value.validate(async (valid) => {
        if (valid) {
            try {
                if (categoryDialog.value.isEdit) {
                    await updateKnowledgeCategory(categoryForm.value.id, categoryForm.value);
                } else {
                    await addKnowledgeCategory(categoryForm.value);
                }
                ElMessage.success(categoryDialog.value.isEdit ? '更新成功' : '添加成功');
                categoryDialog.value.visible = false;
                fetchCategories();
            } catch (error) {
                ElMessage.error(categoryDialog.value.isEdit ? '更新失败' : '添加失败');
            }
        }
    });
};

// 知识点操作
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

const handleEditPoint = (row) => {
    pointDialog.value.isEdit = true;
    pointDialog.value.visible = true;
    pointForm.value = { ...row };
};

const handleViewPoint = (row) => {
    currentPoint.value = row;
    viewDialog.value.visible = true;
};

const handleDeletePoint = async (row) => {
    try {
        await ElMessageBox.confirm('确定要删除该知识点吗？', '提示', {
            type: 'warning'
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
.knowledge-manage {
    padding: 20px;
}

.header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
}

.view-content {
    padding: 20px;
}

.view-item {
    margin-bottom: 20px;
}

.view-item h4 {
    margin-bottom: 8px;
    color: #606266;
}

.view-item pre {
    background: #f5f7fa;
    padding: 12px;
    border-radius: 4px;
    margin: 0;
    white-space: pre-wrap;
    word-wrap: break-word;
}

.el-table {
    margin-bottom: 20px;
}
</style>