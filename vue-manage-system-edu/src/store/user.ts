import { defineStore } from 'pinia';

export const useUserStore = defineStore('user', {
    state: () => ({
        name: '',
        role: '',
    }),
    actions: {
        // 设置用户信息
        setUserInfo(userInfo: { name: string; role: string }) {
            this.name = userInfo.name;
            this.role = userInfo.role;
        },
        // 清除用户信息
        clearUserInfo() {
            this.name = '';
            this.role = '';
        }
    }
}); 