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

        <h3></h3>
        <div ref="chart" style="height: 400px; width: 100%;"></div>

        <el-divider></el-divider>

        <h3>生成的知识点大类类型</h3>
        <div id="pie-chart" style="height: 400px; width: 100%;"></div>

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

        <el-dialog v-model="dialogVisible" title="查询语句" width="50%">
            <pre>{{ currentQueries }}</pre>
            <template #footer>
                <el-button @click="dialogVisible = false">关闭</el-button>
            </template>
        </el-dialog>
    </div>
</template>

<script setup lang="ts">
import { ref, onMounted, nextTick } from 'vue';
import { ElMessage } from 'element-plus';
import { getStatistics, getQueriesByDate, getCategoriesStatistics } from '@/api/index';
import * as echarts from 'echarts';

const chart = ref<HTMLElement | null>(null);
const statistics = ref({
    total_nl_queries: 0,
    total_generated_sql: 0,
    daily_nl_queries: {}
});
const dailyQueries = ref([]);
const dialogVisible = ref(false);  
const currentQueries = ref(''); // 存当前查询语句

interface CategoryStatistic {
    id: number;
    name: string;
    count: number;
}

const categoriesStatistics = ref<CategoryStatistic[]>([]);

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

const fetchCategoriesStatistics = async () => {
    try {
        const response = await getCategoriesStatistics();
        if (response.data.status === 'success') {
            categoriesStatistics.value = response.data.data;
            renderPieChart();
        } else {
            ElMessage.error('获取大类统计信息失败');
        }
    } catch (error) {
        console.error('获取大类统计信息失败:', error);
        ElMessage.error('获取大类统计信息失败');
    }
};

const renderChart = () => {
    if (!chart.value) {
        console.error('Chart DOM element not found');
        return;
    }

    const myChart = echarts.init(chart.value);
    
    const option = {
        title: {
            text: '生成自然语言查询的趋势图'
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

const renderPieChart = () => {
    const pieChartElement = document.getElementById('pie-chart');
    if (!pieChartElement) return;

    const myPieChart = echarts.init(pieChartElement);
   
    const data = categoriesStatistics.value.map(category => ({
        name: category.name,   
        value: category.count
    }));

    const option = {
        title: {
            text: '自然语言查询所属大类数量及占比',
            subtext: '饼状图一览',
            left: 'center'
        },
        tooltip: {
            trigger: 'item',
            formatter: '{a} <br/>{b}: {c} ({d}%)'  // 显示百分比
        },
        legend: {
            orient: 'vertical',
            left: 'left',
            data: data.map(item => item.name)
        },
        series: [
            {
                name: '查询数量',
                type: 'pie',
                radius: '50%',
                data: data,
                emphasis: {
                    itemStyle: {
                        shadowBlur: 10,
                        shadowOffsetX: 0,
                        shadowColor: 'rgba(0, 0, 0, 0.5)'
                    }
                },
                label: {
                    show: true,
                    formatter: '{b}: {c} ({d}%)'  // 显示名称、数量和百分比
                }
            }
        ]
    };

    myPieChart.setOption(option);
};

const viewDailyQueries = async (date) => {
    try {
        const response = await getQueriesByDate(date);
        if (response.data.status === 'success') {
            currentQueries.value = response.data.data.map(query => query.query_text).join('\n'); // 假设返回的数据中有 query_text 字段
            dialogVisible.value = true; // 显示对话框
        } else {
            ElMessage.error('获取查询语句失败');
        }
    } catch (error) {
        console.error('获取查询语句失败:', error);
        ElMessage.error('获取查询语句失败');
    }
};

onMounted(() => {
    fetchStatistics();
    fetchCategoriesStatistics(); // 获取大类统计数据
});
</script>

<style scoped>
.statistics-view {
    padding: 20px;
}
</style>