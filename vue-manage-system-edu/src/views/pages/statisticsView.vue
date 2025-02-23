<template>
    <div class="statistics-view">
        <h2>统计信息</h2>
        <el-row>
            <el-col :span="12">
                <el-card>
                    <h3>生成的自然语言描述语句数量: {{ statistics.total_nl_queries }}</h3>
                </el-card>
            </el-col>
            <el-col :span="12">
                <el-card>
                    <h3>生成的 SQL 数量: {{ statistics.total_generated_sql }}</h3>
                </el-card>
            </el-col>
        </el-row>

        <el-divider></el-divider>

        <h3>生成趋势图</h3>
        <div ref="chart" style="height: 400px; width: 100%;"></div>

        <el-divider></el-divider>

        <h3>每日生成的自然语言描述</h3>
        <el-table :data="dailyQueries" style="width: 100%">
            <el-table-column prop="date" label="日期" />
            <el-table-column prop="count" label="数量" />
            <el-table-column label="操作">
                <template #default="scope">
                    <el-button @click="viewDailyQueries(scope.row.date)">查看</el-button>
                </template>
            </el-table-column>
        </el-table>
    </div>
</template>

<script setup lang="ts">
import { ref, onMounted, nextTick } from 'vue';
import { ElMessage } from 'element-plus';
import { getStatistics } from '@/api/index';
import * as echarts from 'echarts';

// 使用 ref 获取 DOM 元素
const chart = ref<HTMLElement | null>(null);

const statistics = ref({
    total_nl_queries: 0,
    total_generated_sql: 0,
    daily_nl_queries: {}
});

const dailyQueries = ref([]);

const fetchStatistics = async () => {
    try {
        const response = await getStatistics();
        if (response.data.status === 'success') {
            statistics.value = response.data.data;
            dailyQueries.value = Object.entries(statistics.value.daily_nl_queries).map(([date, count]) => ({ date, count }));
            await nextTick(); // 确保 DOM 更新完成
            renderChart(); // 渲染图表
        } else {
            ElMessage.error('获取统计信息失败');
        }
    } catch (error) {
        console.error('获取统计信息失败:', error);
        ElMessage.error('获取统计信息失败');
    }
};

const renderChart = () => {
    // 使用 Vue 的 ref 获取 DOM 元素
    if (!chart.value) {
        console.error('Chart DOM element not found');
        return;
    }

    const myChart = echarts.init(chart.value);
    
    const option = {
        title: {
            text: '生成趋势图'
        },
        tooltip: {},
        xAxis: {
            type: 'category',
            data: Object.keys(statistics.value.daily_nl_queries) // 使用日期作为横坐标
        },
        yAxis: {
            type: 'value'
        },
        series: [{
            name: '数量',
            type: 'line',
            data: Object.values(statistics.value.daily_nl_queries) // 使用数量作为纵坐标
        }]
    };

    myChart.setOption(option);
};

const viewDailyQueries = (date) => {
    console.log(`查看 ${date} 的生成查询语句`);
};

onMounted(() => {
    fetchStatistics();
});
</script>

<style scoped>
.statistics-view {
    padding: 20px;
}
</style>