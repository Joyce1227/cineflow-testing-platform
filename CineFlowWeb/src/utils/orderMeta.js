export function rememberOrderMovie(orderId, movieId) {
    const values = readOrderMovies();
    values[String(orderId)] = movieId;
    localStorage.setItem("cineflow_order_movies", JSON.stringify(values));
}
export function orderMovieId(orderId) {
    return readOrderMovies()[String(orderId)];
}
function readOrderMovies() {
    try {
        return JSON.parse(localStorage.getItem("cineflow_order_movies") || "{}");
    }
    catch {
        return {};
    }
}
