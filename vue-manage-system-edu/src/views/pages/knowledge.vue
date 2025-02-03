<template>
  <div class="knowledge">
    <el-tree
      :data="knowledgeData"
      :props="treeProps"
      :expand-on-click-node="false"
      @node-click="handleNodeClick"
    />
    <el-button type="primary" @click="openAddDialog">添加知识点</el-button>

    <el-dialog v-model="visible" title="编辑知识点">
      <el-form :model="currentKnowledgePoint">
        <el-form-item label="知识点名称">
          <el-input v-model="currentKnowledgePoint.title" />
        </el-form-item>
        <el-form-item label="关联SQL">
          <el-input v-model="currentKnowledgePoint.sqlExample" />
        </el-form-item>
        <el-button type="primary" @click="saveKnowledgePoint">保存</el-button>
      </el-form>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import { ElTree, ElButton, ElDialog, ElForm, ElFormItem, ElInput } from 'element-plus';

const knowledgeData = ref([
  { id: 1, title: 'SELECT', sqlExample: 'SELECT * FROM table;' },
  { id: 2, title: 'JOIN', sqlExample: 'SELECT a.*, b.* FROM a JOIN b ON a.id = b.id;' },
]);

const treeProps = ref({
  children: 'children',
  label: 'title',
});

const visible = ref(false);
const currentKnowledgePoint = ref({ title: '', sqlExample: '' });

const handleNodeClick = (node) => {
  currentKnowledgePoint.value = { ...node };
  visible.value = true;
};

const openAddDialog = () => {
  currentKnowledgePoint.value = { title: '', sqlExample: '' };
  visible.value = true;
};

const saveKnowledgePoint = () => {
  // 保存到数据库
  visible.value = false;
};
</script>




