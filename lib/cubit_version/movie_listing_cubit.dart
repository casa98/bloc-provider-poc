import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/movie_service.dart';
import 'movie_listing_state.dart';

class MovieCubit extends Cubit<MovieState> {
  final MovieService _movieService;

  MovieCubit(this._movieService) : super(MovieState());

  Future<void> fetchMovies() async {
    emit(state.copyWith(status: MovieStatus.loading));
    try {
      final movies = await _movieService.fetchMovies();
      emit(state.copyWith(status: MovieStatus.loaded, movies: movies));
    } catch (e) {
      emit(
        state.copyWith(
            status: MovieStatus.error, errorMessage: 'Failed to fetch movies'),
      );
    }
  }

  Future<void> fetchMovieDetails(String id) async {
    emit(state.copyWith(status: MovieStatus.loading));
    try {
      final movie = await _movieService.fetchMovieDetails(id);
      emit(state.copyWith(status: MovieStatus.loaded, selectedMovie: movie));
    } catch (e) {
      emit(
        state.copyWith(
            status: MovieStatus.error,
            errorMessage: 'Failed to fetch movie details'),
      );
    }
  }

  void toggleFavorite(String movieId) {
    final favorites = Set<String>.from(state.favorites);
    if (favorites.contains(movieId)) {
      favorites.remove(movieId);
    } else {
      favorites.add(movieId);
    }
    emit(state.copyWith(favorites: favorites));
  }

  void clearError() {
    emit(state.copyWith(status: MovieStatus.loaded, errorMessage: null));
  }
}
