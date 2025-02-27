<template>
    <div class="experiment-generate">
        <div class="header">
            <h2>实验作业生成</h2>
            <div class="header-right">
                <!-- 知识点大类选择按钮 -->
                <el-button 
                    type="primary" 
                    @click="showCategoryDialog"
                    style="margin-right: 15px;"
                    :disabled="isCategoryDialogDisabled"
                >
                    选择知识点大类
                </el-button>
                <!-- 知识点选择按钮 -->
                <el-button 
                    type="primary" 
                    @click="showKnowledgeDialog"
                    style="margin-right: 15px;"
                    :disabled="isKnowledgeDialogDisabled"
                >
                    选择知识点
                </el-button>

                <el-button 
                    type="primary" 
                    @click="handleGenerateExperiment"
                    :disabled="!canGenerate"
                >
                    生成实验
                </el-button>
            </div>
        </div>

        <div class="usage-tip">
            <el-alert 
                title="提示：选择知识点和知识点大类只能选择其中一个。系统将根据选择的内容，从已审核通过的自然语言查询中生成实验作业。" 
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
                                    <span>{{ point.point_name }}</span>
                                    <el-input-number 
                                        v-model="point.queryCount" 
                                        :min="1" 
                                        :max="10"
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
                                        v-model="category.queryCount" 
                                        :min="1" 
                                        :max="10"
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

        <!-- 知识点选择对话框 -->
        <el-dialog v-model="knowledgeDialog.visible" title="选择知识点" width="70%">
            <el-table :data="knowledgeDialog.points" @selection-change="handleSelectionChange">
                <el-table-column type="selection" width="55" />
                <el-table-column prop="point_name" label="知识点名称" />
                <el-table-column prop="description" label="描述" show-overflow-tooltip />
                <el-table-column label="查询数量" width="150">
                    <template #default="{ row }">
                        <el-input-number
                            v-model="row.queryCount"
                            :min="1"
                            :max="10"
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
            <el-table :data="categoryDialog.categories" @selection-change="handleCategorySelectionChange">
                <el-table-column type="selection" width="55" />
                <el-table-column prop="category_name" label="大类名称" />
                <el-table-column prop="description" label="描述" show-overflow-tooltip />
                <el-table-column label="查询数量" width="150">
                    <template #default="{ row }">
                        <el-input-number
                            v-model="row.queryCount"
                            :min="1"
                            :max="10"
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
    </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue';
import { ElMessage, ElMessageBox } from 'element-plus';
import { getKnowledgePoints, getKnowledgeCategories, generateExperiment } from '@/api/index';

// 状态管理
const selectedPoints = ref([]);
const selectedCategories = ref([]);
const knowledgeDialog = ref({
    visible: false,
    points: []
});
const categoryDialog = ref({
    visible: false,
    categories: []
});

// 计算属性
const isCategoryDialogDisabled = computed(() => selectedPoints.value.length > 0);
const isKnowledgeDialogDisabled = computed(() => selectedCategories.value.length > 0);
const canGenerate = computed(() => selectedPoints.value.length > 0 || selectedCategories.value.length > 0);

// 方法
const showKnowledgeDialog = async () => {
    try {
        const response = await getKnowledgePoints();
        if (response.data.status === 'success') {
            knowledgeDialog.value.points = response.data.data.map(point => ({
                ...point,
                queryCount: 1
            }));
            knowledgeDialog.value.visible = true;
        }
    } catch (error) {
        ElMessage.error('获取知识点失败');
    }
};

const showCategoryDialog = async () => {
    try {
        const response = await getKnowledgeCategories();
        if (response.data.status === 'success') {
            categoryDialog.value.categories = response.data.data.map(category => ({
                ...category,
                queryCount: 1
            }));
            categoryDialog.value.visible = true;
        }
    } catch (error) {
        ElMessage.error('获取知识点大类失败');
    }
};

// ... 其他方法实现（handleSelectionChange, confirmSelection等）

const handleGenerateExperiment = async () => {
    try {
        const loading = ElMessageBox.loading('正在生成实验...');
        
        const requestData = {
            points: selectedPoints.value.map(point => ({
                id: point.id,
                queryCount: point.queryCount
            })),
            categories: selectedCategories.value.map(category => ({
                id: category.id,
                queryCount: category.queryCount
            }))
        };

        const response = await generateExperiment(requestData);
        loading.close();

        if (response.data.status === 'success') {
            ElMessage.success('实验生成成功');
            clearSelected();
        } else {
            ElMessage.error(response.data.message || '生成实验失败');
        }
    } catch (error) {
        ElMessage.error('生成实验失败');
    }
};

// ... 其他辅助方法
</script>

<style scoped>
.experiment-generate {
    padding: 20px;
}

.header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
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

.usage-tip {
    margin: 20px 0;
}
</style> 