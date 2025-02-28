<!-- 已弃用 -->

<template>
    <div class="queries">
      <el-input v-model="queryTemplate" placeholder="请输入查询需求描述" />
      <el-button type="primary" @click="generateQueries">生成查询需求</el-button>
  
      <div v-if="queries.length">
        <el-table :data="queries" style="width: 100%">
          <el-table-column prop="description" label="查询需求" />
          <el-table-column prop="sql" label="生成的SQL语句" />
        </el-table>
      </div>
    </div>
  </template>
  
  <script setup lang="ts">
  import { ref } from 'vue';
  import { ElInput, ElButton, ElTable, ElTableColumn } from 'element-plus';
  
  const queryTemplate = ref('');
  const queries = ref([]);
  
  const generateQueries = async () => {
    
    const res = await fetch('/api/generate-query', { method: 'POST', body: JSON.stringify({ query: queryTemplate.value }) });
    queries.value = await res.json();
  };
  </script>
  