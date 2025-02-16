import { defineStore } from 'pinia';

interface ObjectList {
    [key: string]: string[];
}

export const usePermissStore = defineStore('permiss', {
    state: () => {
        const defaultList: ObjectList = {
            admin: [
                '0',
                '1',
                '11',
                '12',
                '13',
                // '2',
                // '21',
                // '22',
                // '23',
                // '24',
                // '25',
                // '26',
                // '27',
                // '28',
                // '29',
                // '291',
                // '292',
                // '3',
                // '31',
                // '32',
                // '33',
                // '34',
                // '4',
                // '41',
                // '42',
                // '5',
                // '7',
                // '6',
                // '61',
                // '62',
                // '63',
                // '64',
                // '65',
                // '66',
                '81','82','8'//8开头的是有关学生端sql的权限
                ,"9","91","92"//表模式相关
                ,"153"//知识点
                ,"10","101","102" //实验作业相关
                ,"15","151"//自然语言查询管理
                ,"16","161"//AI助手
            ],
            user: ['0',
                // '1', '11', '12', '13',普通用户就不用显示系统管理了
                
                '81','82','8'],
        };
        const username = localStorage.getItem('vuems_name');
        const is_admin=localStorage.getItem('is_admin');
        console.log(username);
        return {
            key: (is_admin == 'true' ? defaultList.admin : defaultList.user) as string[],
            defaultList,
        };
    },
    actions: {
        handleSet(val: string[]) {
            this.key = val;
        },
    },
});
