<template>
    <div class="sql-validator">
        <h2>SQL正确性判断</h2>
        <el-input v-model="query" placeholder="输入自然语言" />
        <el-input v-model="sql" placeholder="输入SQL语句" />
    <el-button @click="validateSQLQuery">验证SQL</el-button>
        <div v-if="validationResult">
            <h3>验证结果：</h3>
            <pre>{{ validationResult }}</pre>
        </div>
    </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import { validateSQL } from '@/api/index';
import { ElMessage } from 'element-plus';
const query = ref('');
const validationResult = ref('');
const sql = ref('');
const validateSQLQuery = async() => {
    try {
            if (query.value.trim() === '') {
                ElMessage.error('请输入有效的查询需求');
            return;
            }
            const response = await validateSQL({
            query_description: query.value,  
            generated_sql: sql.value          
        });
        console.log(response)
        validationResult.value = response.data.data;   
        if (validationResult.toString().includes('不符合描述')) {
            ElMessage.error('SQL 需要修改:' );
        }
        else if (!validationResult.toString().includes('符合要求')) {
            ElMessage.error('SQL 需要修改:' );
        }
        else {
            ElMessage.success('SQL 符合描述:' );
        }
    } catch (error) {
        console.error('Error validating SQL:', error);
        ElMessage.error('验证过程中发生错误');
    }
    // if (query.value.toUpperCase().includes('正确')) {
    //     validationResult.value = 'SQL语句正确';
    // } else {
    //     validationResult.value = 'SQL语句错误';
    // }
};
 
</script>
