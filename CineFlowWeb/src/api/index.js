import { http } from "./http";
export const authApi = {
    login: (payload) => http.post("/auth/login", payload),
    register: (payload) => http.post("/auth/register", payload)
};
export const movieApi = {
    list: (params) => http.get("/movies", { params }),
    hot: (limit = 6) => http.get("/movies/hot", { params: { limit } }),
    detail: (id) => http.get(`/movies/${id}`),
    schedules: (id) => http.get(`/movies/${id}/schedules`),
    seats: (scheduleId) => http.get(`/schedules/${scheduleId}/seats`),
    cinemas: () => http.get("/cinemas")
};
export const orderApi = {
    lock: (scheduleId, seatIds) => http.post(`/schedules/${scheduleId}/seats/lock`, { seatIds }),
    create: (payload) => http.post("/orders", payload),
    list: () => http.get("/orders"),
    detail: (id) => http.get(`/orders/${id}`),
    cancel: (id) => http.post(`/orders/${id}/cancel`),
    pay: (id, providerTradeNo) => http.post(`/orders/${id}/payment-callback`, { providerTradeNo, success: true }),
    refund: (id) => http.post(`/orders/${id}/refund`)
};
export const reviewApi = {
    list: (movieId, pageNum = 1) => http.get(`/movies/${movieId}/reviews`, { params: { pageNum, pageSize: 10 } }),
    save: (movieId, payload) => http.put(`/movies/${movieId}/reviews`, payload),
    remove: (reviewId) => http.delete(`/reviews/${reviewId}`)
};
export const recommendationApi = {
    hot: (limit = 8) => http.get("/recommendations/hot", { params: { limit } }),
    mine: (limit = 8) => http.get("/recommendations/me", { params: { limit } })
};
export const adminApi = {
    health: () => http.get("/admin/health"),
    createMovie: (payload) => http.post("/admin/movies", payload),
    createCinema: (payload) => http.post("/admin/cinemas", payload),
    createSchedule: (payload) => http.post("/admin/schedules", payload)
};
export const statApi = {
    actors: () => http.get("/stat/actor-top50"),
    highScore: () => http.get("/stat/high-score-average"),
    mins: () => http.get("/stat/mins-summary")
};
