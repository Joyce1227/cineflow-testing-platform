import { createRouter, createWebHistory } from "vue-router";
import { useAuthStore } from "../stores/auth";
const router = createRouter({
    history: createWebHistory(),
    scrollBehavior: () => ({ top: 0 }),
    routes: [
        { path: "/", name: "home", component: () => import("../views/HomeView.vue") },
        { path: "/login", name: "login", component: () => import("../views/LoginView.vue"), meta: { guest: true } },
        { path: "/register", name: "register", component: () => import("../views/RegisterView.vue"), meta: { guest: true } },
        { path: "/movies/:id", name: "movie-detail", component: () => import("../views/MovieDetailView.vue") },
        { path: "/movies/:movieId/schedules/:scheduleId/seats", name: "seats", component: () => import("../views/SeatSelectionView.vue"), meta: { auth: true } },
        { path: "/checkout", name: "checkout", component: () => import("../views/CheckoutView.vue"), meta: { auth: true } },
        { path: "/orders", name: "orders", component: () => import("../views/OrdersView.vue"), meta: { auth: true } },
        { path: "/orders/:id", name: "order-detail", component: () => import("../views/OrderDetailView.vue"), meta: { auth: true } },
        { path: "/recommendations", name: "recommendations", component: () => import("../views/RecommendationsView.vue") },
        { path: "/forbidden", name: "forbidden", component: () => import("../views/ForbiddenView.vue") },
        {
            path: "/admin",
            component: () => import("../layouts/AdminLayout.vue"),
            meta: { auth: true, admin: true },
            children: [
                { path: "", name: "admin-dashboard", component: () => import("../views/admin/AdminDashboardView.vue") },
                { path: "movies", name: "admin-movies", component: () => import("../views/admin/AdminMoviesView.vue") },
                { path: "cinemas", name: "admin-cinemas", component: () => import("../views/admin/AdminCinemasView.vue") },
                { path: "schedules", name: "admin-schedules", component: () => import("../views/admin/AdminSchedulesView.vue") }
            ]
        },
        { path: "/:pathMatch(.*)*", name: "not-found", component: () => import("../views/NotFoundView.vue") }
    ]
});
router.beforeEach((to) => {
    const auth = useAuthStore();
    if (to.meta.auth && !auth.isLoggedIn)
        return { name: "login", query: { redirect: to.fullPath } };
    if (to.meta.admin && auth.user?.role !== "ADMIN")
        return { name: "forbidden" };
    if (to.meta.guest && auth.isLoggedIn)
        return { name: "home" };
});
export default router;
