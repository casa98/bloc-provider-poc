import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'movie_listing_provider.dart';

class MovieDetailScreen extends StatelessWidget {
  final String movieId;

  const MovieDetailScreen({
    required this.movieId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.read<MovieProvider>();
    provider.fetchMovieDetails(movieId);

    return Scaffold(
      appBar: AppBar(title: const Text('Movie Details')),
      body: Consumer<MovieProvider>(
        builder: (context, provider, child) {
          if (provider.status == MovieStatus.error) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(provider.errorMessage!)),
              );
            });
          }
          return _buildBody(context, provider);
        },
      ),
    );
  }

  // prefer classes instead of widgets, for prod
  Widget _buildBody(BuildContext context, MovieProvider provider) {
    if (provider.status == MovieStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    } else if (provider.selectedMovie != null) {
      final movie = provider.selectedMovie!;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(movie.title, style: Theme.of(context).textTheme.displayMedium),
            Text(movie.genre, style: Theme.of(context).textTheme.bodySmall),
            Text(
              'Rating: ${movie.rating}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            IconButton(
              icon: Icon(
                provider.favorites.contains(movie.id)
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: Colors.red,
              ),
              onPressed: () {
                provider.toggleFavorite(movie.id);
              },
            ),
          ],
        ),
      );
    }
    return const Center(child: Text('Movie not found'));
  }
}
