import { http } from "./http";
import type { ActorStat, ApiEnvelope, Cinema, LoginResult, MinsSummary, Movie, Order, PageResult, Review, Schedule, Seat } from "../types";

export const authApi = {
  login: (payload: { username: string; password: string }) =>
    http.post<ApiEnvelope<LoginResult>>("/auth/login", payload),
  register: (payload: { username: string; phone: string; email: string; password: string }) =>
    http.post<ApiEnvelope<{ id: number; username: string }>>("/auth/register", payload)
};

export const movieApi = {
  list: (params: Record<string, string | number | undefined>) =>
    http.get<ApiEnvelope<PageResult<Movie>>>("/movies", { params }),
  hot: (limit = 6) => http.get<ApiEnvelope<Movie[]>>("/movies/hot", { params: { limit } }),
  detail: (id: number) => http.get<ApiEnvelope<Movie>>(`/movies/${id}`),
  schedules: (id: number) => http.get<ApiEnvelope<Schedule[]>>(`/movies/${id}/schedules`),
  seats: (scheduleId: number) => http.get<ApiEnvelope<Seat[]>>(`/schedules/${scheduleId}/seats`),
  cinemas: () => http.get<ApiEnvelope<Cinema[]>>("/cinemas")
};

export const orderApi = {
  lock: (scheduleId: number, seatIds: number[]) =>
    http.post<ApiEnvelope<{ scheduleId: number; seats: Seat[]; expiresAt: string }>>(
      `/schedules/${scheduleId}/seats/lock`, { seatIds }
    ),
  create: (payload: { scheduleId: number; seatIds: number[]; idempotencyKey: string }) =>
    http.post<ApiEnvelope<Order>>("/orders", payload),
  list: () => http.get<ApiEnvelope<Order[]>>("/orders"),
  detail: (id: number) => http.get<ApiEnvelope<Order>>(`/orders/${id}`),
  cancel: (id: number) => http.post<ApiEnvelope<Order>>(`/orders/${id}/cancel`),
  pay: (id: number, providerTradeNo: string) =>
    http.post<ApiEnvelope<Order>>(`/orders/${id}/payment-callback`, { providerTradeNo, success: true }),
  refund: (id: number) => http.post<ApiEnvelope<Order>>(`/orders/${id}/refund`)
};

export const reviewApi = {
  list: (movieId: number, pageNum = 1) =>
    http.get<ApiEnvelope<PageResult<Review>>>(`/movies/${movieId}/reviews`, { params: { pageNum, pageSize: 10 } }),
  save: (movieId: number, payload: { rating: number; content: string }) =>
    http.put<ApiEnvelope<Review>>(`/movies/${movieId}/reviews`, payload),
  remove: (reviewId: number) => http.delete(`/reviews/${reviewId}`)
};

export const recommendationApi = {
  hot: (limit = 8) => http.get<ApiEnvelope<Movie[]>>("/recommendations/hot", { params: { limit } }),
  mine: (limit = 8) => http.get<ApiEnvelope<Movie[]>>("/recommendations/me", { params: { limit } })
};

export const adminApi = {
  health: () => http.get<ApiEnvelope<{ status: string }>>("/admin/health"),
  createMovie: (payload: { name: string; genres: string; regions: string; releaseYear?: number; score: number; status: string }) =>
    http.post<ApiEnvelope<Movie>>("/admin/movies", payload),
  createCinema: (payload: { name: string; address: string; city: string }) =>
    http.post<ApiEnvelope<Cinema>>("/admin/cinemas", payload),
  createSchedule: (payload: { movieId: number; cinemaId: number; hallName: string; startTime: string; endTime: string; price: number; rows: number; seatsPerRow: number }) =>
    http.post<ApiEnvelope<Schedule>>("/admin/schedules", payload)
};

export const statApi = {
  actors: () => http.get<ApiEnvelope<ActorStat[]>>("/stat/actor-top50"),
  highScore: () => http.get<ApiEnvelope<{ threshold: number; averageScore: number }>>("/stat/high-score-average"),
  mins: () => http.get<ApiEnvelope<MinsSummary>>("/stat/mins-summary")
};
