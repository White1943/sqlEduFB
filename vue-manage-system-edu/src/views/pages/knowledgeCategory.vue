<template>
    <div class="category-manage">
        <div class="header">
            <h2>知识点分类</h2>
            <el-button type="primary" @click="handleAddCategory">
                新增分类
            </el-button>
        </div>

        <div class="category-grid">
            <el-row :gutter="20">
                <el-col :span="8" v-for="category in categories" :key="category.id">
                    <el-card class="category-card" shadow="hover">
                        <template #header>
                            <div class="card-header">
                                <span class="title">{{ category.category_name }}</span>
                                <div class="operations">
                                    <el-button type="warning" link @click="handleEditCategory(category)">
                                        <el-icon><Edit /></el-icon>
                                    </el-button>
                                    <el-button type="danger" link @click="handleDeleteCategory(category)">
                                        <el-icon><Delete /></el-icon>
                                    </el-button>
                                </div>
                            </div>
                        </template>
                        <div class="card-content">
                            <div class="description">{{ category.description }}</div>
                            <div class="statistics">
                                <el-tag size="small" type="info">知识点数量: {{ category.point_count || 0 }}</el-tag>
                            </div>
                        </div>
                    </el-card>
                </el-col>
            </el-row>
        </div>

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
                    <el-input type="textarea" v-model="categoryForm.description" rows="3" />
                </el-form-item>
            </el-form>
            <template #footer>
                <el-button @click="categoryDialog.visible = false">取消</el-button>
                <el-button type="primary" @click="saveCategoryForm">确定</el-button>
            </template>
        </el-dialog>
    </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { ElMessage, ElMessageBox } from 'element-plus';
import type { FormInstance, FormRules } from 'element-plus';
import { Edit, Delete } from '@element-plus/icons-vue';
import {
    getKnowledgeCategories,
    addKnowledgeCategory,
    updateKnowledgeCategory,
    deleteKnowledgeCategory
} from '@/api/index';

const categories = ref([]);
const categoryFormRef = ref<FormInstance>();

const categoryDialog = ref({
    visible: false,
    isEdit: false
});

const categoryForm = ref({
    id: null,
    category_name: '',
    description: ''
});

const categoryRules = ref<FormRules>({
    category_name: [
        { required: true, message: '请输入分类名称', trigger: 'blur' }
    ]
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

// 处理新增分类
const handleAddCategory = () => {
    categoryDialog.value.isEdit = false;
    categoryDialog.value.visible = true;
    categoryForm.value = {
        id: null,
        category_name: '',
        description: ''
    };
};

// 处理编辑分类
const handleEditCategory = (row) => {
    categoryDialog.value.isEdit = true;
    categoryDialog.value.visible = true;
    categoryForm.value = { ...row };
};

// 处理删除分类
const handleDeleteCategory = async (row) => {
    try {
        await ElMessageBox.confirm('确定要删除该分类吗？删除后该分类下的所有知识点也将被删除。', '警告', {
            type: 'warning',
            confirmButtonText: '确定',
            cancelButtonText: '取消'
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

// 保存分类表单
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

onMounted(() => {
    fetchCategories();
});
</script>

<style scoped>
.category-manage {
    padding: 20px;
}

.header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
}

.category-grid {
    margin-top: 20px;
}

.category-card {
    margin-bottom: 20px;
    transition: all 0.3s;
}

.category-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.card-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.title {
    font-size: 16px;
    font-weight: bold;
}

.card-content {
    min-height: 100px;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
}

.description {
    margin-bottom: 15px;
    color: #606266;
    line-height: 1.5;
}

.statistics {
    margin-top: auto;
}

.operations {
    display: flex;
    gap: 8px;
}
</style> 