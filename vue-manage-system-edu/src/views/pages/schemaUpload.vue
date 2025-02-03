<template>
  <div>
      <div class="container">
          <!-- 文件上传部分 -->
          <el-upload
              class="upload-demo"
              drag
              action="#"
              :auto-upload="false"
              :on-change="handleFileChange"
              accept=".sql"
          >
              <el-icon class="el-icon--upload"><upload-filled /></el-icon>
              <div class="el-upload__text">
                  拖拽文件到此处或 <em>点击上传</em>
              </div>
          </el-upload>
          <el-button type="primary" @click="handleUpload">上传文件</el-button>

          <!-- SQL文件列表表格 -->
          <el-table :data="sqlFiles" style="width: 100%; margin-top: 20px">
              <el-table-column prop="id" label="ID" width="80" />
              <el-table-column prop="filename" label="文件名" width="180" />
              <el-table-column prop="file_content" label="SQL内容" />
              <el-table-column prop="created_at" label="上传时间" width="180" />
          </el-table>
      </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { ElMessage } from 'element-plus';
import { uploadSchema, tableSchema } from '../api';
import { UploadFilled } from '@element-plus/icons-vue';


const sqlFiles = ref([]);
const selectedFile = ref(null);

// 文件选择处理
const handleFileChange = (file) => {
  selectedFile.value = file.raw;
};


const handleUpload = async () => {
    if (!selectedFile.value) {
        ElMessage.warning('请先选择文件');
        return;
    }

    const formData = new FormData();
    formData.append('file', selectedFile.value);

    try {
        const response = await uploadSqlFile(formData);
        if (response.code === 200) {
            ElMessage.success(response.msg || '文件上传成功');
            fetchSqlFiles(); // 刷新文件列表
        } else {
            ElMessage.error(response.msg || '文件上传失败');
        }
    } catch (error) {
        ElMessage.error('文件上传失败');
    }
};

const fetchSqlFiles = async () => {
    try {
        const response = await getSqlFiles();
        if (response.code === 200) {
            sqlFiles.value = response.data;
        } else {
            ElMessage.error(response.msg || '获取文件列表失败');
        }
    } catch (error) {
        ElMessage.error('获取文件列表失败');
    }
};


onMounted(() => {
  fetchSqlFiles();
});
</script>

<style scoped>
.container {
  padding: 20px;
}
</style>