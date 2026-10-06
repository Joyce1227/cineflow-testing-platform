import { ref } from "vue";
import { defineStore } from "pinia";
export const useBookingStore = defineStore("booking", () => {
    const movie = ref(null);
    const schedule = ref(null);
    const seats = ref([]);
    const lockExpiresAt = ref("");
    function setSelection(selectedMovie, selectedSchedule, selectedSeats, expiresAt) {
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
            if (!raw)
                return;
            const value = JSON.parse(raw);
            movie.value = value.movie;
            schedule.value = value.schedule;
            seats.value = value.seats;
            lockExpiresAt.value = value.lockExpiresAt;
        }
        catch {
            clear();
        }
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
