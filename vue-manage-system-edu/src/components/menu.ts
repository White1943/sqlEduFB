import { Menus } from '@/types/menu';
const isAdmin = localStorage.getItem('is_admin') === 'true' ? true : false;
// alert('ee'+isAdmin)
export const menuData: Menus[] = [
    {
        id: '0',
        title: '系统首页',
        index: '/dashboard',
        icon: 'rank',
    },
    {
        id:'8',
        title:'学生自学自测',
        
        index:'8',
        icon:'Odometer',
        children:[
            {id: '81',
                pid:'8',
                index: '/sql-generator',
                title: 'SQL自动生成',
               
                
            },
            {
                id: '82',
                pid:'8',
                index: '/sql-validator',
                title: 'SQL正确性判断',
                
            },
        ]
    },
    {
        id: '1',
        title: '系统管理',
        index: '1',
        icon: 'HomeFilled',
        children: [
         
                {
                    id: '11',
                    pid: '1',
                    index: '/system-user',
                    title: '用户管理',
                },
                {
                    id: '12',
                    pid: '1',
                    index: '/system-role',
                    title: '角色管理',
                },
                {
                    id: '13',
                    pid: '1',
                    index: '/system-menu',
                    title: '菜单管理',
                },
           
        ],
    },
    {
        id:'9',
        title:'数据库管理',
        index:'9',
        icon:'upload-filled',
        children:[
            {
                id: '91',
                pid: '9',
                index: '/schema-table',
                title: '查看表结构',
            },
            {
                id: '92',
                pid: '9',
                index: '/schema-upload',
                title: '表模式导入',
            },
        ]
    },
    {
        id:'10',
        title:'实验作业管理',
        index:'10',
        icon:'edit',
        children:[
            {
                id: '101',
                pid: '10',
                index: '/gen-experiment',
                title: '查看表结构',
            },
            {
                id: '102',
                pid: '10',
                index: '/system-experiment',
                title: '表模式导入',
            },
        ]
    },
    {
        id:'11',
        title:'知识点管理',
        index:'/knowledge',
        icon:'sort',
        // children:[
        //     {
        //         id: '111',
        //         pid: '11',
        //         index: '/table',
        //         title: '知识点管理',
        //     },
        //     {
        //         id: '112',
        //         pid:'11' ,
        //         index: '/upload',
        //         title: '知识点分类',
        //     },
        // ]
    },
    {
        id: '2',
        title: '组件',
        index: '2-1',
        icon: 'Calendar',
        children: [
            {
                id: '21',
                pid: '3',
                index: '/form',
                title: '表单',
            },
            {
                id: '22',
                pid: '3',
                index: '/upload',
                title: '上传',
            },
            {
                id: '23',
                pid: '2',
                index: '/carousel',
                title: '走马灯',
            },
            {
                id: '24',
                pid: '2',
                index: '/calendar',
                title: '日历',
            },
            {
                id: '25',
                pid: '2',
                index: '/watermark',
                title: '水印',
            },
            {
                id: '26',
                pid: '2',
                index: '/tour',
                title: '分布引导',
            },
            {
                id: '27',
                pid: '2',
                index: '/steps',
                title: '步骤条',
            },
            {
                id: '28',
                pid: '2',
                index: '/statistic',
                title: '统计',
            },
            {
                id: '29',
                pid: '3',
                index: '29',
                title: '三级菜单',
                children: [
                    {
                        id: '291',
                        pid: '29',
                        index: '/editor',
                        title: '富文本编辑器',
                    },
                    {
                        id: '292',
                        pid: '29',
                        index: '/markdown',
                        title: 'markdown编辑器',
                    },
                ],
            },
        ],
    },
    {
        id: '3',
        title: '表格',
        index: '3',
        icon: 'Calendar',
        children: [
            {
                id: '31',
                pid: '3',
                index: '/table',
                title: '基础表格',
            },
            {
                id: '32',
                pid: '3',
                index: '/table-editor',
                title: '可编辑表格',
            },
            {
                id: '33',
                pid: '3',
                index: '/import',
                title: '导入Excel',
            },
            {
                id: '34',
                pid: '3',
                index: '/export',
                title: '导出Excel',
            },
        ],
    },
    {
        id: '4',
        icon: 'PieChart',
        index: '4',
        title: '图表',
        children: [
            {
                id: '41',
                pid: '4',
                index: '/schart',
                title: 'schart图表',
            },
            {
                id: '42',
                pid: '4',
                index: '/echarts',
                title: 'echarts图表',
            },
        ],
    },
    {
        id: '5',
        icon: 'Guide',
        index: '/icon',
        title: '图标',
        permiss: '5',
    },
    {
        id: '7',
        icon: 'Brush',
        index: '/theme',
        title: '主题',
    },
    {
        id: '6',
        icon: 'DocumentAdd',
        index: '6',
        title: '附加页面',
        children: [
            {
                id: '61',
                pid: '6',
                index: '/ucenter',
                title: '个人中心',
            },
            {
                id: '62',
                pid: '6',
                index: '/login',
                title: '登录',
            },
            {
                id: '63',
                pid: '6',
                index: '/register',
                title: '注册',
            },
            {
                id: '64',
                pid: '6',
                index: '/reset-pwd',
                title: '重设密码',
            },
            {
                id: '65',
                pid: '6',
                index: '/403',
                title: '403',
            },
            {
                id: '66',
                pid: '6',
                index: '/404',
                title: '404',
            },
        ],
    },
    
   
];
console.log("menudata"+menuData);

//this is components/menu.ts