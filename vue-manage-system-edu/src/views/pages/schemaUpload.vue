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
              <el-table-column prop="filename" label="文件名" width="180">
                  <template #default="scope">
                      <span v-if="!scope.row.isEditing">{{ scope.row.filename }}</span>
                      <el-input
                          v-else
                          v-model="scope.row.filename"
                          size="small"
                      />
                  </template>
              </el-table-column>
              <el-table-column prop="file_content" label="SQL内容">
                  <template #default="scope">
                      <span v-if="!scope.row.isEditing">{{ scope.row.file_content }}</span>
                      <el-input
                          v-else
                          v-model="scope.row.file_content"
                          type="textarea"
                          :rows="3"
                      />
                  </template>
              </el-table-column>
              <el-table-column prop="created_at" label="上传时间" width="180" />
              <el-table-column label="操作" width="200">
                  <template #default="scope">
                      <el-button
                          v-if="!scope.row.isEditing"
                          type="primary"
                          size="small"
                          @click="handleEdit(scope.row)"
                      >
                          编辑
                      </el-button>
                      <el-button
                          v-else
                          type="success"
                          size="small"
                          @click="handleSave(scope.row)"
                      >
                          保存
                      </el-button>
                      <el-button
                          type="danger"
                          size="small"
                          @click="handleDelete(scope.row)"
                      >
                          删除
                      </el-button>
                  </template>
              </el-table-column>
          </el-table>
      </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { ElMessage, ElMessageBox } from 'element-plus';
import { uploadSqlFile, getSqlFiles, deleteSqlFile, updateSqlFile } from '@/api/index';
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
        console.log(response)
        if (response.data.status === '201'||response.data.status === '200') {
            ElMessage.success(response.data.message || '文件上传成功');
            fetchSqlFiles(); // 刷新文件列表
        } else {
            ElMessage.error(response.data.message || '文件上传失败');
        }


    } catch (error) {
        ElMessage.error('文件上传失败');
    }
};

const handleEdit = (row) => {
    row.isEditing = true;
    row.originalData = { ...row };
};

const handleSave = async (row) => {
    try {
        await updateSqlFile(row.id, {
            filename: row.filename,
            file_content: row.file_content
        });
        row.isEditing = false;
        ElMessage.success('更新成功');
    } catch (error) {
        ElMessage.error('更新失败');
        Object.assign(row, row.originalData);
    }
};

const handleDelete = async (row) => {
    try {
        await ElMessageBox.confirm('确定要删除这条记录吗？', '提示', {
            type: 'warning'
        });
        
        await deleteSqlFile(row.id);
        ElMessage.success('删除成功');
        fetchSqlFiles(); // 刷新列表
    } catch (error) {
        if (error !== 'cancel') {
            ElMessage.error('删除失败');
        }
    }
};

const fetchSqlFiles = async () => {
    try {
        const response = await getSqlFiles();
        if (response.data.status === 'success') {
            sqlFiles.value = response.data.data.map(item => ({
                ...item,
                isEditing: false
            }));
        } else {
            ElMessage.error(response.data.message || '获取文件列表失败');
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