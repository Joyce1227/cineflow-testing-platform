export interface ApiEnvelope<T> {
  code: number;
  message: string;
  data: T;
  timestamp: number;
}

export interface User {
  id: number;
  username: string;
  role: "USER" | "ADMIN";
}

export interface LoginResult {
  token: string;
  tokenType: string;
  expiresIn: number;
  user: User;
}

export interface Movie {
  id: number;
  name: string;
  alias?: string | null;
  actors?: string | null;
  directors?: string | null;
  cover?: string | null;
  genres: string;
  regions: string;
  languages?: string | null;
  releaseYear?: number | null;
  releaseDate?: string | null;
  mins?: number | null;
  storyline?: string | null;
  score: number;
  ratingCount: number;
  popularity: number;
  status: string;
}

export interface PageResult<T> {
  list: T[];
  pageNum: number;
  pageSize: number;
  total: number;
  totalPages: number;
}

export interface Schedule {
  id: number;
  movieId: number;
  cinemaId: number;
  cinemaName: string;
  hallName: string;
  startTime: string;
  endTime: string;
  price: number;
  status: string;
}

export interface Cinema {
  id: number;
  name: string;
  address: string;
  city: string;
  status: string;
}

export interface ActorStat {
  personName: string;
  actedMovieCnt: number;
}

export interface MinsSummary {
  totalMins: number;
  averageMins: number;
  minMins: number;
  maxMins: number;
}

export interface Seat {
  id: number;
  scheduleId: number;
  seatRow: string;
  seatNumber: number;
  seatCode: string;
  status: "AVAILABLE" | "LOCKED" | "SOLD";
  lockExpiresAt?: string | null;
  price?: number;
}

export interface Order {
  id: number;
  orderNo: string;
  userId: number;
  scheduleId: number;
  totalAmount: number;
  status: string;
  createdAt: string;
  paidAt?: string | null;
  refundedAt?: string | null;
  seats: Seat[];
}

export interface Review {
  id: number;
  userId: number;
  username: string;
  movieId: number;
  rating: number;
  content: string;
  createdAt: string;
  updatedAt: string;
}
