import axios from 'axios';

const service = axios.create({
    baseURL: import.meta.env.VITE_APP_BASE_API || '',
    timeout: 50000
});

// ... 其他配置 