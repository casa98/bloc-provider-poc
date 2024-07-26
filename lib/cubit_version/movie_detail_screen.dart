import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'movie_listing_cubit.dart';
import 'movie_listing_state.dart';

class MovieDetailScreen extends StatelessWidget {
  final String movieId;

  const MovieDetailScreen({
    required this.movieId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MovieCubit>();
    cubit.fetchMovieDetails(movieId);

    return BlocConsumer<MovieCubit, MovieState>(
      listener: (context, state) {
        if (state.status == MovieStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Movie Details')),
          body: _buildBody(context, state),
        );
      },
    );
  }

// prefer classes instead of widgets, for prod
  Widget _buildBody(BuildContext context, MovieState state) {
    if (state.status == MovieStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state.selectedMovie != null) {
      final movie = state.selectedMovie!;
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
                state.favorites.contains(movie.id)
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: Colors.red,
              ),
              onPressed: () {
                context.read<MovieCubit>().toggleFavorite(movie.id);
              },
            ),
          ],
        ),
      );
    }
    return const Center(child: Text('Movie not found'));
  }
}
