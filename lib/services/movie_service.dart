class Movie {
  final String id;
  final String title;
  final String genre;
  final double rating;

  Movie({
    required this.id,
    required this.title,
    required this.genre,
    required this.rating,
  });
}

class MovieService {
  Future<List<Movie>> fetchMovies() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      Movie(id: '1', title: 'Interstellar', genre: 'Sci-Fi', rating: 10.0),
      Movie(id: '2', title: 'Shutter Island', genre: 'Sci-Fi', rating: 10.0),
      Movie(id: '3', title: 'Titanic', genre: 'Drama', rating: 9.9),
    ];
  }

  Future<Movie> fetchMovieDetails(String id) async {
    await Future.delayed(const Duration(seconds: 1));
    return Movie(id: id, title: 'Interstellar', genre: 'Sci-Fi', rating: 10.0);
  }
}
