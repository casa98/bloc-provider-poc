import 'package:flutter/material.dart';

import '../services/movie_service.dart';

enum MovieStatus { initial, loading, loaded, error }

class MovieProvider extends ChangeNotifier {
  final MovieService _movieService;

  MovieStatus _status = MovieStatus.initial;
  List<Movie> _movies = [];
  Movie? _selectedMovie;
  final Set<String> _favorites = {};
  String? _errorMessage;

  MovieProvider(this._movieService);

  MovieStatus get status => _status;
  List<Movie> get movies => _movies;
  Movie? get selectedMovie => _selectedMovie;
  Set<String> get favorites => _favorites;
  String? get errorMessage => _errorMessage;

  Future<void> fetchMovies() async {
    _status = MovieStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _movies = await _movieService.fetchMovies();
      _status = MovieStatus.loaded;
    } catch (e) {
      _status = MovieStatus.error;
      _errorMessage = 'Failed to fetch movies';
    }
    notifyListeners();
  }

  Future<void> fetchMovieDetails(String id) async {
    _status = MovieStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _selectedMovie = await _movieService.fetchMovieDetails(id);
      _status = MovieStatus.loaded;
    } catch (e) {
      _status = MovieStatus.error;
      _errorMessage = 'Failed to fetch movie details';
    }
    notifyListeners();
  }

  void toggleFavorite(String movieId) {
    if (_favorites.contains(movieId)) {
      _favorites.remove(movieId);
    } else {
      _favorites.add(movieId);
    }
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    _status = MovieStatus.loaded;
    notifyListeners();
  }
}
