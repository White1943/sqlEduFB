<template>
    <div>
        <el-row :gutter="20">
            <el-col :span="8">
                <el-card shadow="hover" class="mgb20">
                    <div class="user-info">
                        <img src="../assets/img/sql-learning.png" class="user-avatar" />
                        <div class="user-info-cont">
                            <div class="user-info-name">{{ name }}</div>
                            <div>{{ role }}</div>
                        </div>
                    </div>
                </el-card>
                <el-card shadow="hover">
                    <template #header>
                        <div class="clearfix">
                            <span>系统信息</span>
                        </div>
                    </template>
                    <el-table :data="systemInfo" style="width: 100%">
                        <el-table-column prop="label" label="项目"></el-table-column>
                        <el-table-column prop="value" label="值"></el-table-column>
                    </el-table>
                </el-card>
            </el-col>
            <el-col :span="16">
                <el-row :gutter="20" class="mgb20">
                    <el-col :span="8">
                        <el-card shadow="hover" :body-style="{ padding: '20px' }">
                            <div class="grid-content">
                                <div class="grid-cont-right">
                                    <div class="value">{{ stats.schemaCount }}</div>
                                    <div class="text">数据库模式总数</div>
                                </div>
                            </div>
                        </el-card>
                    </el-col>
                    <el-col :span="8">
                        <el-card shadow="hover" :body-style="{ padding: '20px' }">
                            <div class="grid-content">
                                <div class="grid-cont-right">
                                    <div class="value">{{ stats.queryCount }}</div>
                                    <div class="text">自然语言查询总数</div>
                                </div>
                            </div>
                        </el-card>
                    </el-col>
                    <el-col :span="8">
                        <el-card shadow="hover" :body-style="{ padding: '20px' }">
                            <div class="grid-content">
                                <div class="grid-cont-right">
                                    <div class="value">{{ stats.generatedSQLCount }}</div>
                                    <div class="text">已生成SQL数</div>
                                </div>
                            </div>
                        </el-card>
                    </el-col>
                </el-row>
                <el-card shadow="hover">
                    <template #header>
                        <div class="clearfix">
                            <span>学习进度</span>
                        </div>
                    </template>
                    <el-table :data="recentQueries" style="width: 100%">
                        <el-table-column prop="query_text" label="查询描述" show-overflow-tooltip></el-table-column>
                        <el-table-column prop="status" label="状态" width="100">
                            <template #default="scope">
                                <el-tag :type="getStatusType(scope.row.status)">
                                    {{ scope.row.status }}
                                </el-tag>
                            </template>
                        </el-table-column>
                        <el-table-column prop="created_at" label="创建时间" width="180"></el-table-column>
                    </el-table>
                </el-card>
            </el-col>
        </el-row>
    </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { useUserStore } from '@/store/user';

const name = ref('');
const role = ref('');
const userStore = useUserStore();

const stats = ref({
    schemaCount: 0,
    queryCount: 0,
    generatedSQLCount: 0
});

const systemInfo = ref([
    {
        label: '系统名称',
        value: 'SQL教学系统'
    },
    {
        label: '当前版本',
        value: 'v1.0.0'
    },
    {
        label: 'LLM模型',
        value: 'Qwen-7B-Chat'
    }
]);

const recentQueries = ref([]);

// 获取状态标签类型
const getStatusType = (status) => {
    return {
        pending: 'warning',
        approved: 'success',
        rejected: 'danger'
    }[status];
};

// 获取统计数据
const fetchStats = async () => {
    try {
      
        // const response = await getStats();
        // stats.value = response.data;
    } catch (error) {
        console.error('获取统计数据失败:', error);
    }
};

// 获取最近查询
const fetchRecentQueries = async () => {
    try {
         
        // const response = await getRecentQueries();
        // recentQueries.value = response.data;
    } catch (error) {
        console.error('获取最近查询失败:', error);
    }
};

onMounted(async () => {
   
    name.value = localStorage.getItem('vuems_name') || '';
    role.value = localStorage.getItem('vuems_role') || '';
    
 
    
    await fetchStats();
    await fetchRecentQueries();
});
</script>

<style scoped>
.user-info {
    display: flex;
    align-items: center;
    padding: 20px;
}
.user-avatar {
    width: 120px;
    height: 120px;
    border-radius: 50%;
}
.user-info-cont {
    padding-left: 50px;
    flex: 1;
    font-size: 14px;
    color: #999;
}
.user-info-name {
    font-size: 30px;
    color: #333;
}
.grid-content {
    display: flex;
    align-items: center;
    height: 100px;
}
.grid-cont-right {
    flex: 1;
    text-align: center;
    font-size: 14px;
    color: #999;
}
.grid-cont-right .value {
    font-size: 30px;
    font-weight: bold;
    color: #333;
    margin-bottom: 10px;
}
.mgb20 {
    margin-bottom: 20px;
}
</style>
