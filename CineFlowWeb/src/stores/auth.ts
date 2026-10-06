import { computed, ref } from "vue";
import { defineStore } from "pinia";
import { authApi } from "../api";
import type { User } from "../types";

function loadUser(): User | null {
  try {
    const raw = localStorage.getItem("cineflow_user");
    return raw ? JSON.parse(raw) : null;
  } catch {
    return null;
  }
}

export const useAuthStore = defineStore("auth", () => {
  const token = ref(localStorage.getItem("cineflow_token") || "");
  const user = ref<User | null>(loadUser());
  const isLoggedIn = computed(() => Boolean(token.value && user.value));

  async function login(username: string, password: string) {
    const { data } = await authApi.login({ username, password });
    token.value = data.data.token;
    user.value = data.data.user;
    localStorage.setItem("cineflow_token", token.value);
    localStorage.setItem("cineflow_user", JSON.stringify(user.value));
  }

  function logout() {
    token.value = "";
    user.value = null;
    localStorage.removeItem("cineflow_token");
    localStorage.removeItem("cineflow_user");
  }

  return { token, user, isLoggedIn, login, logout };
});
