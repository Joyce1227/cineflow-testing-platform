import { ref } from "vue";
import { defineStore } from "pinia";
import type { Movie, Schedule, Seat } from "../types";

export const useBookingStore = defineStore("booking", () => {
  const movie = ref<Movie | null>(null);
  const schedule = ref<Schedule | null>(null);
  const seats = ref<Seat[]>([]);
  const lockExpiresAt = ref("");

  function setSelection(selectedMovie: Movie, selectedSchedule: Schedule, selectedSeats: Seat[], expiresAt: string) {
    movie.value = selectedMovie;
    schedule.value = selectedSchedule;
    seats.value = selectedSeats;
    lockExpiresAt.value = expiresAt;
    sessionStorage.setItem("cineflow_booking", JSON.stringify({
      movie: movie.value, schedule: schedule.value, seats: seats.value, lockExpiresAt: lockExpiresAt.value
    }));
  }

  function restore() {
    try {
      const raw = sessionStorage.getItem("cineflow_booking");
      if (!raw) return;
      const value = JSON.parse(raw);
      movie.value = value.movie;
      schedule.value = value.schedule;
      seats.value = value.seats;
      lockExpiresAt.value = value.lockExpiresAt;
    } catch { clear(); }
  }

  function clear() {
    movie.value = null;
    schedule.value = null;
    seats.value = [];
    lockExpiresAt.value = "";
    sessionStorage.removeItem("cineflow_booking");
  }

  restore();
  return { movie, schedule, seats, lockExpiresAt, setSelection, clear };
});
