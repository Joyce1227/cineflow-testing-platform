export function rememberOrderMovie(orderId: number, movieId: number) {
  const values = readOrderMovies();
  values[String(orderId)] = movieId;
  localStorage.setItem("cineflow_order_movies", JSON.stringify(values));
}

export function orderMovieId(orderId: number): number | undefined {
  return readOrderMovies()[String(orderId)];
}

function readOrderMovies(): Record<string, number> {
  try { return JSON.parse(localStorage.getItem("cineflow_order_movies") || "{}"); }
  catch { return {}; }
}
