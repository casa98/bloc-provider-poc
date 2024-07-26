import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/movie_service.dart';
import 'movie_detail_screen.dart';
import 'movie_listing_provider.dart';

class MovieListingScreen extends StatelessWidget {
  const MovieListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MovieProvider(MovieService())..fetchMovies(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Movies')),
        body: Consumer<MovieProvider>(
          builder: (context, provider, child) {
            if (provider.status == MovieStatus.error) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(provider.errorMessage!),
                    action: SnackBarAction(
                      label: 'Dismiss',
                      onPressed: () => provider.clearError(),
                    ),
                  ),
                );
              });
            }
            return _buildBody(context, provider);
          },
        ),
      ),
    );
  }

  // prefer classes instead of widgets, for prod
  Widget _buildBody(BuildContext context, MovieProvider provider) {
    switch (provider.status) {
      case MovieStatus.initial:
      case MovieStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case MovieStatus.loaded:
        return ListView.builder(
          itemCount: provider.movies.length,
          itemBuilder: (context, index) {
            final movie = provider.movies[index];
            return ListTile(
              title: Text(movie.title),
              subtitle: Text(movie.genre),
              trailing: IconButton(
                icon: Icon(
                  provider.favorites.contains(movie.id)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Colors.red,
                ),
                onPressed: () => provider.toggleFavorite(movie.id),
              ),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ChangeNotifierProvider.value(
                    value: provider,
                    child: MovieDetailScreen(movieId: movie.id),
                  ),
                ),
              ),
            );
          },
        );
      case MovieStatus.error:
        return Center(child: Text('Error: ${provider.errorMessage}'));
    }
  }
}
