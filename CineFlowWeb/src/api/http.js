import axios from "axios";
export const http = axios.create({
    baseURL: import.meta.env.VITE_API_BASE_URL || "/api",
    timeout: 10000,
    headers: { "Content-Type": "application/json" }
});
http.interceptors.request.use((config) => {
    const token = localStorage.getItem("cineflow_token");
    if (token)
        config.headers.Authorization = `Bearer ${token}`;
    return config;
});
http.interceptors.response.use((response) => response, (error) => {
    if (error.response?.status === 401) {
        localStorage.removeItem("cineflow_token");
        localStorage.removeItem("cineflow_user");
        window.dispatchEvent(new CustomEvent("cineflow:unauthorized"));
    }
    return Promise.reject(error);
});
export function errorMessage(error) {
    if (axios.isAxiosError(error)) {
        if (!error.response)
            return "无法连接服务器，请确认 FastAPI 已启动";
        return error.response.data?.message || `请求失败（${error.response.status}）`;
    }
    return error instanceof Error ? error.message : "操作失败，请稍后重试";
}
