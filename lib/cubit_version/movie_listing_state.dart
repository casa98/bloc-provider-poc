import 'package:poc/services/movie_service.dart';

enum MovieStatus { none, loading, loaded, error }

class MovieState {
  final MovieStatus status;
  final List<Movie> movies;
  final Movie? selectedMovie;
  final Set<String> favorites;
  final String? errorMessage;

  MovieState({
    this.status = MovieStatus.none,
    this.movies = const [],
    this.selectedMovie,
    this.favorites = const {},
    this.errorMessage,
  });

  MovieState copyWith({
    MovieStatus? status,
    List<Movie>? movies,
    Movie? selectedMovie,
    Set<String>? favorites,
    String? errorMessage,
  }) {
    return MovieState(
      status: status ?? this.status,
      movies: movies ?? this.movies,
      selectedMovie: selectedMovie ?? this.selectedMovie,
      favorites: favorites ?? this.favorites,
      errorMessage: errorMessage,
    );
  }
}
