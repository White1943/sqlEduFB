<template>
    <div class="experiment-generate">
        <div class="header">
            <h2>实验报告生成</h2>
            <div class="header-right">
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
                    @click="showKnowledgeDialog"
                    style="margin-right: 15px;"
                    :disabled="isKnowledgeDialogDisabled"
                >
                    选择知识点
                </el-button>
                <!-- 选择生成实验报告数量 -->
                <el-input-number v-model="experimentCount" :min="1" :max="100" />
                <el-dropdown style="margin-left: 15px;">
                    <el-button type="primary" :disabled="!canGenerate">
                        生成实验报告 <el-icon class="el-icon--right"><arrow-down /></el-icon>
                    </el-button>
                    <template #dropdown>
                        <el-dropdown-menu>
                            <el-dropdown-item @click="handleGenerateExperiment">
                                <el-icon><ChatRound /></el-icon> 使用AI生成
                            </el-dropdown-item>
                            <el-dropdown-item @click="handleGenerateExperiment2nd">
                                <el-icon><Document /></el-icon> 使用本地生成
                            </el-dropdown-item>
                        </el-dropdown-menu>
                    </template>
                </el-dropdown>
            </div>
        </div>

        <div class="usage-tip">
            <el-alert 
                title="提示：选择知识点和知识点大类只能选择其中一个，请先确认选择方式。" 
                type="info" 
                :closable="false"
            />
        </div>

        <div class="selected-points" v-if="selectedPoints.length || selectedCategories.length">
            <div class="selected-points-header">
                <h3>已选{{ selectedPoints.length ? '知识点' : '知识点大类' }}</h3>
                <el-button type="danger" link @click="clearSelected">清空所有</el-button>
            </div>
            <el-row :gutter="20">
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
            <el-table :data="knowledgeDialog.points" @selection-change="handlePointSelectionChange" style="width: 100%">
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

        <!-- 添加实验报告列表部分 -->
        <div class="experiment-list">
            <h3>实验报告列表</h3>
            <el-tabs v-model="activeTab" @tab-click="handleTabClick">
                <el-tab-pane label="教师版" name="teacher"></el-tab-pane>
                <el-tab-pane label="学生版" name="student"></el-tab-pane>
            </el-tabs>
            
            <el-table :data="experimentList" style="width: 100%">
                <el-table-column prop="title" label="标题" width="280" />
                <el-table-column prop="created_at" label="创建时间" width="180" />
                <el-table-column prop="description" label="描述" />
                <el-table-column label="操作" width="200">
                    <template #default="{ row }">
                        <el-button type="primary" size="small" @click="viewExperiment(row)">查看</el-button>
                        <el-dropdown>
                            <el-button type="success" size="small">
                                下载 <el-icon class="el-icon--right"><arrow-down /></el-icon>
                            </el-button>
                            <template #dropdown>
                                <el-dropdown-menu>
                                    <el-dropdown-item @click="downloadExperiment(row.id)">Word格式</el-dropdown-item>
                                    <el-dropdown-item @click="downloadExperimentAsHTML(row.id)">HTML格式</el-dropdown-item>
                                    <el-dropdown-item @click="openInNewWindow(row)">在新窗口查看</el-dropdown-item>
                                </el-dropdown-menu>
                            </template>
                        </el-dropdown>
                    </template>
                </el-table-column>
            </el-table>
            
            <!-- 分页 -->
            <div class="pagination">
                <el-pagination
                    v-model:current-page="expListPage"
                    v-model:page-size="expListPageSize"
                    :page-sizes="[10, 20, 50, 100]"
                    :total="expListTotal"
                    layout="total, sizes, prev, pager, next, jumper"
                    @size-change="handleExpListSizeChange"
                    @current-change="handleExpListCurrentChange"
                />
            </div>
        </div>
        
        <!-- 实验报告查看对话框 -->
        <el-dialog
            v-model="experimentDialogVisible"
            :title="experimentDialogTitle"
            width="80%"
            top="5vh"
        >
            <div v-if="!isEditing" class="experiment-content" v-html="experimentDialogContent"></div>
            <div v-else class="editor-container">
                <QuillEditor
                    ref="quillEditor"
                    v-model:content="editorContent"
                    contentType="html"
                    theme="snow"
                    toolbar="full"
                    class="quill-editor"
                />
            </div>
            <template #footer>
                <div class="dialog-footer">
                    <el-button v-if="!isEditing" @click="startEditing" type="primary">编辑</el-button>
                    <template v-else>
                        <el-button @click="cancelEditing">取消</el-button>
                        <el-button type="primary" @click="saveEditing">保存</el-button>
                    </template>
                </div>
            </template>
        </el-dialog>
    </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch, reactive, nextTick } from 'vue';
import { ElMessage, ElMessageBox, ElLoading } from 'element-plus';
import { ArrowDown, ChatRound, Document } from '@element-plus/icons-vue';
import { marked } from 'marked';
import { QuillEditor } from '@vueup/vue-quill';
import '@vueup/vue-quill/dist/vue-quill.snow.css';
import { 
    getSqlFiles,
    getKnowledgeCategories,
    getKnowledgePointsPaginated,
    generateQueries,
    updateNLQuery,
    deleteNLQuery,
    getKnowledgePointsByCategory,
    getExperimentByPointsCategory,
    toggleQueryStatus,
    generateExperiment,
    generateExperiment2nd,
    getExperimentsList,
    downloadExperiment as apiDownloadExperiment,
    updateExperiment
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

// 新增实验报告数量
const experimentCount = ref(1);

// 实验报告列表相关
const activeTab = ref('teacher');
const experimentList = ref([]);
const expListPage = ref(1);
const expListPageSize = ref(10);
const expListTotal = ref(0);

// 实验报告对话框相关
const experimentDialogVisible = ref(false);
const experimentDialogTitle = ref('');
const experimentDialogContent = ref('');
const currentExperiment = ref(null);  // 保存当前查看的实验对象
const isEditing = ref(false);
const quillEditor = ref(null);
const editorContent = ref('');

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

const viewSchema = (schema) => {
    dialogType.value = 'schema';
    dialogTitle.value = `Schema: ${schema.filename}`;
    currentSchema.value = schema.file_content.replace(/\n/g, '<br>');
    dialogVisible.value = true;
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
const handlePointSelectionChange = (selection) => {
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

    // 将该分类下所有知识点的 ID 和生成数量添加到请求数据中
    newCategories.forEach(category => {
        // 假设您有一个 API 可以根据分类 ID 获取知识点
        getKnowledgePointsByCategory(category.id).then(response => {
            const categoryPoints = response.data.data; // 假设返回的数据结构
            categoryPoints.forEach(point => {
                requestData.points.push({
                    id: point.id,
                    generateCount: category.generateCount // 使用分类的生成数量
                });
            });
        });
    });

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

// 生命周期钩子
onMounted(() => {
    fetchSchemas();
    fetchExperimentList();
});

 
// 处理生成查询 (AI生成)
const handleGenerateExperiment = async () => {
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
            text: '正在生成实验报告，请稍等...',
            background: 'rgba(0, 0, 0, 0.7)'
        });

        // 确保数据格式正确
        const requestData = {
            schema_ids: selectedSchemaIds.value,
            points: selectedPoints.value.map(point => ({ id: point.id, generateCount: parseInt(point.generateCount) || 1 })),
            count: experimentCount.value
        };

        // 如果选择了知识点大类，则将该大类下的所有知识点信息添加到请求数据中
        if (selectedCategories.value.length) {
            for (const category of selectedCategories.value) {
                try {
                    const response = await getExperimentByPointsCategory(category.id);
                    console.log('API Response:', response); // 用于调试
                    
                    // response.data.data，这是后端 ApiResponse.success(data=points_data) 返回的结构
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

        const response = await generateExperiment(requestData);
        loading.close();

        if (response.data.status === 'success') {
            ElMessage.success(response.data.message);
            
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

// 处理生成查询 (本地生成)
const handleGenerateExperiment2nd = async () => {
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
            text: '正在生成实验报告，请稍等...',
            background: 'rgba(0, 0, 0, 0.7)'
        });

        // 确保数据格式正确
        const requestData = {
            schema_ids: selectedSchemaIds.value,
            points: selectedPoints.value.map(point => ({ id: point.id, generateCount: parseInt(point.generateCount) || 1 })),
            count: experimentCount.value
        };

        // 如果选择了知识点大类，则将该大类下的所有知识点信息添加到请求数据中
        if (selectedCategories.value.length) {
            for (const category of selectedCategories.value) {
                try {
                    const response = await getKnowledgePointsByCategory(category.id);
                    console.log('API Response:', response);
                    
                    const categoryPoints = response.data.data;
                    
                    requestData.points.push(...categoryPoints.map(point => ({
                        id: point.id,
                        generateCount: category.generateCount
                    })));
                } catch (error) {
                    console.error('获取知识点失败:', error);
                    ElMessage.error('获取知识点失败，请重试');
                }
            }
        }

        const response = await generateExperiment2nd(requestData);
        loading.close();

        if (response.data.status === 'success') {
            ElMessage.success(response.data.message);
            
            clearSelected(); // 清空已选知识点和大类
            fetchExperimentList(); // 刷新实验报告列表
        } else {
            ElMessage.error(response.data.message || '生成实验报告失败');
        }
    } catch (error: any) {
        loading?.close();
        console.error('生成实验报告失败:', error);
        ElMessage.error(error.response?.data?.message || '生成实验报告失败');
    }
};

// 获取实验报告列表
const fetchExperimentList = async () => {
    try {
        const response = await getExperimentsList({
            page: expListPage.value,
            page_size: expListPageSize.value,
            version: activeTab.value
        });
        
        if (response.data.status === 'success') {
            experimentList.value = response.data.data.items;
            expListTotal.value = response.data.data.total;
        }
    } catch (error) {
        console.error('获取实验报告列表失败:', error);
        ElMessage.error('获取实验报告列表失败');
    }
};

// 处理标签切换
const handleTabClick = () => {
    expListPage.value = 1;
    fetchExperimentList();
};

// 分页处理
const handleSizeChange = (val: number) => {
    pageSize.value = val;
};

const handleCurrentChange = (val: number) => {
    currentPage.value = val;
};

// 查看实验报告
const viewExperiment = (experiment) => {
    experimentDialogTitle.value = experiment.title;
    experimentDialogContent.value = marked(experiment.report_content);
    currentExperiment.value = experiment;
    experimentDialogVisible.value = true;
    isEditing.value = false;
};

// 进入编辑模式
const startEditing = async () => {
    isEditing.value = true;
    
    // 将Markdown转换为HTML用于编辑
    const htmlContent = marked(currentExperiment.value.report_content);
    // 设置编辑器内容
    editorContent.value = htmlContent;
};

// 取消编辑
const cancelEditing = () => {
    isEditing.value = false;
    editorContent.value = '';
};

// 保存编辑
const saveEditing = async () => {
    try {
        // 获取编辑器内容
        const htmlContent = editorContent.value;
        
        // 检查内容长度，如果使用的是VARCHAR字段且未修改为LONGTEXT
        if (htmlContent.length > 65000) { // 稍微小于TEXT类型的限制
            ElMessage.warning('内容过长，可能无法保存！请减少内容或联系管理员扩展数据库字段。');
            // 继续尝试保存，或在此返回中止保存
        }
        
        const loading = ElLoading.service({
            lock: true,
            text: '保存中...',
            background: 'rgba(0, 0, 0, 0.7)'
        });
        
        // 更新实验报告
        const response = await updateExperiment({
            id: currentExperiment.value.id,
            report_content: htmlContent  // 存储为HTML
        });
        
        loading.close();
        
        if (response.data.status === 'success') {
            ElMessage.success('保存成功');
            // 更新显示内容
            currentExperiment.value.report_content = htmlContent;
            experimentDialogContent.value = htmlContent;
            isEditing.value = false;
            editorContent.value = '';
            // 刷新列表
            fetchExperimentList();
        } else {
            ElMessage.error(response.data.message || '保存失败');
        }
    } catch (error) {
        console.error('保存失败:', error);
        ElMessage.error('保存失败: ' + (error.message || '未知错误'));
    }
};

// 监听对话框关闭事件
watch(experimentDialogVisible, (val) => {
    if (!val && isEditing.value) {
        isEditing.value = false;
        editorContent.value = '';
    }
});

// 使用Fetch API下载Word文档
const downloadExperiment = async (id) => {
    try {
        const loading = ElLoading.service({
            lock: true,
            text: '准备下载...',
            background: 'rgba(0, 0, 0, 0.7)'
        });
        
        // 明确指定后端服务器地址
        const backendUrl = 'http://localhost:5000'; // 根据实际情况修改
        const downloadUrl = `${backendUrl}/experiment/download/${id}`;
        
        // 使用fetch API获取文件
        const response = await fetch(downloadUrl);
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        
        // 获取blob
        const blob = await response.blob();
        
        // 创建下载链接
        const url = window.URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.style.display = 'none';
        a.href = url;
        a.download = `实验报告_${id}.docx`;
        document.body.appendChild(a);
        a.click();
        
        // 清理
        window.URL.revokeObjectURL(url);
        document.body.removeChild(a);
        
        loading.close();
        ElMessage.success('下载成功');
    } catch (error) {
        ElLoading.service().close();
        console.error('下载失败:', error);
        ElMessage.error(`下载失败: ${error.message}`);
    }
};

// 分页处理
const handleExpListSizeChange = (val: number) => {
    expListPageSize.value = val;
    fetchExperimentList();
};

const handleExpListCurrentChange = (val: number) => {
    expListPage.value = val;
    fetchExperimentList();
};

// 监听标签页变化
watch(activeTab, () => {
    fetchExperimentList();
});

// HTML格式下载
const downloadExperimentAsHTML = (id) => {
    try {
        // 明确指定后端服务器地址
        const backendUrl = 'http://localhost:5000'; // 根据实际情况修改
        const downloadUrl = `${backendUrl}/experiment/download_html/${id}`;
        
        // 打开新窗口并移除 # 路由
        window.open(downloadUrl, '_blank', 'noopener,noreferrer');
        ElMessage.success('开始下载HTML格式...');
    } catch (error) {
        console.error('下载HTML报告失败:', error);
        ElMessage.error('下载失败');
    }
};

// 在新窗口中打开实验报告
const openInNewWindow = (experiment) => {
    try {
        // 创建一个包含实验报告内容的HTML页面
        const htmlContent = experiment.report_content;
        const title = experiment.title;
        const fullHtml = `
        <!DOCTYPE html>
        <html>
            <head>
                <meta charset="utf-8">
                <title>${title}</title>
                <style>
                    body { font-family: Arial, sans-serif; margin: 20px; }
                    h1 { color: #333; text-align: center; }
                    pre { background-color: #f5f5f5; padding: 10px; border-radius: 5px; overflow-x: auto; }
                    code { font-family: Consolas, Monaco, monospace; }
                    img { max-width: 100%; height: auto; }
                    @media print {
                        body { font-size: 12pt; }
                        pre { border: 1px solid #ccc; }
                    }
                </style>
            </head>
            <body>
                <div style="text-align: right; margin: 10px;">
                    <button onclick="window.print()">打印</button>
                </div>
                <h1>${title}</h1>
                ${htmlContent}
            </body>
        </html>
        `;
        
        // 创建一个新窗口
        const newWindow = window.open('', '_blank');
        if (newWindow) {
            newWindow.document.write(fullHtml);
            newWindow.document.close();
        } else {
            ElMessage.warning('您的浏览器阻止了弹出窗口，请允许弹出窗口后重试。');
        }
    } catch (error) {
        console.error('在新窗口打开报告失败:', error);
        ElMessage.error('打开失败');
    }
};
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
.experiment-list {
    margin-top: 30px;
}
.experiment-content {
    max-height: 70vh;
    overflow-y: auto;
    padding: 0 20px;
}
.experiment-content :deep(h1) {
    font-size: 24px;
    margin-bottom: 20px;
}
.experiment-content :deep(h2) {
    font-size: 20px;
    margin: 16px 0;
}
.experiment-content :deep(h3) {
    font-size: 18px;
    margin: 14px 0;
}
.experiment-content :deep(h4) {
    font-size: 16px;
    margin: 12px 0;
}
.experiment-content :deep(pre) {
    background-color: #f5f5f5;
    padding: 10px;
    border-radius: 4px;
    overflow-x: auto;
}
.experiment-content :deep(code) {
    font-family: Consolas, Monaco, 'Andale Mono', monospace;
}
.editor-container {
    border: 1px solid #ccc;
    z-index: 100;
    margin-bottom: 20px;
}

.quill-editor {
    height: 450px;
    font-family: Arial, sans-serif;
}

/* Quill编辑器样式调整 */
:deep(.ql-container) {
    font-size: 16px;
}

:deep(.ql-toolbar) {
    border-bottom: 1px solid #ccc;
}
</style>