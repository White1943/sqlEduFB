<template>
    <div class="schema-table">
        <div v-loading="loading" class="container">
            <!-- Schema选择器 -->
            <el-select v-model="selectedSchemaId" placeholder="请选择数据库模式" @change="handleSchemaChange">
                <el-option
                    v-for="schema in schemas"
                    :key="schema.id"
                    :label="schema.filename"
                    :value="schema.id"
                />
            </el-select>

            <!-- 表结构展示 -->
            <div v-if="schemaContent" class="schema-content">
                <h3>表结构：</h3>
                <pre>{{ schemaContent }}</pre>
            </div>
        </div>
    </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { ElMessage } from 'element-plus';
import { getSqlFiles } from '@/api/index';

const loading = ref(false);
const schemas = ref([]);
const selectedSchemaId = ref('');
const schemaContent = ref('');
 
const fetchSchemas = async () => {
    loading.value = true;
    try {
        const response = await getSqlFiles();
        if (response.data.status === 'success') {
            schemas.value = response.data.data;
        } else {
            ElMessage.error('获取数据库模式列表失败');
        }
    } catch (error) {
        ElMessage.error('获取数据库模式列表失败');
    } finally {
        loading.value = false;
    }
};

// 处理schema选择变化
const handleSchemaChange = async (schemaId) => {
    if (!schemaId) return;
    
    const selectedSchema = schemas.value.find(s => s.id === schemaId);
    if (selectedSchema) {
        schemaContent.value = selectedSchema.file_content;
    }
};

onMounted(() => {
    fetchSchemas();
});
</script>

<style scoped>
.schema-table {
    padding: 20px;
}
.container {
    min-height: 200px;
}
.schema-content {
    margin-top: 20px;
}
pre {
    white-space: pre-wrap;
    word-wrap: break-word;
    background: #f5f5f5;
    padding: 15px;
    border-radius: 4px;
}
</style>
