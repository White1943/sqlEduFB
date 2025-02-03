
export interface User {
    id: number;
    name: string;
    password: string;
    email: string;
    phone: string;
    role: string;
    date: string;
}

export interface Register {
    username: string;
    password: string;
    email: string;
}
//typescript 的强类型。这里写出数据结构，可以进行注册时的校验检查
//嗯，register页面的东西如有相应更改，这里最好同步下