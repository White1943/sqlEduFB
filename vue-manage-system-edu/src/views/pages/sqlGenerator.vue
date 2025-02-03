<template>
    <div class="sql-generator">
        <h2>SQL自动生成工具</h2>
        <el-input v-model="query" placeholder="输入查询需求（自然语言）" />
        <el-button @click="generateSQLQuery">生成SQL</el-button>
        <div v-if="sql">
            <h3>生成的SQL：</h3>
            <pre>{{ sql }}</pre>
        </div>
    </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import { generateSQL } from '@/api/index';
import { ElMessage } from 'element-plus';
const query = ref('');
const sql = ref('');
const generateSQLQuery = async () => {
    try {
            if (query.value.trim() === '') {
                ElMessage.error('请输入有效的查询需求');
            return;
            }
         
        const response = await generateSQL(query.value);
        console.log(response)
        sql.value = response.data.data;  // 显示生成的 SQL
    } catch (error) {
        console.error('Error generating SQL:', error);
    }
};


 
</script>
