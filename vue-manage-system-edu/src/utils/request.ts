import axios, { AxiosInstance, AxiosError, AxiosResponse, InternalAxiosRequestConfig } from 'axios';
const API_URL = 'http://localhost:5000'; 
const service: AxiosInstance = axios.create({
    baseURL: API_URL,
    timeout: 50000000
});

// request.use 负责在每次请求发送之前对请求进行一些处理，比如设置请求头、处理 token 等
service.interceptors.request.use(
    (config: InternalAxiosRequestConfig) => {
        const token = localStorage.getItem('token');  //wy
        if (token) {
            config.headers['Authorization'] = `Bearer ${token}`;  
        }
        return config;
    },
    (error: AxiosError) => {
        console.log(error);
        return Promise.reject();
    }
);

service.interceptors.response.use(
    (response: AxiosResponse) => {
        if (response.status === 200 || response.status === 201) {
            return response;
        } else {
            Promise.reject('异常响应状态');
        }
    },
    (error: AxiosError) => {
        console.log(error);
        if (error.response?.status === 401) {
            // 如果返回的是 401 Unauthorized 错误，跳转登录
            localStorage.removeItem('token');
            window.location.href = '/login';
        }
        return Promise.reject(error);
    }
);

export default service;
//找到axios导入拉，差点被src/api/index.ts骗过去了，还好发现马脚
//原理在src/utils/request.ts
//this is app/utils/request.ts