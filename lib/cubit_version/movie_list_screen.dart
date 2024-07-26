import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/movie_service.dart';
import 'movie_detail_screen.dart';
import 'movie_listing_cubit.dart';
import 'movie_listing_state.dart';

class MovieListingScreen extends StatelessWidget {
  const MovieListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MovieCubit(MovieService())..fetchMovies(),
      child: BlocConsumer<MovieCubit, MovieState>(
        listener: (context, state) {
          if (state.status == MovieStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                action: SnackBarAction(
                  label: 'Dismiss',
                  onPressed: () {
                    context.read<MovieCubit>().clearError();
                  },
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text('Movies')),
            body: _buildBody(context, state),
          );
        },
      ),
    );
  }

  // prefer classes instead of widgets, for prod
  Widget _buildBody(BuildContext context, MovieState state) {
    switch (state.status) {
      case MovieStatus.none:
      case MovieStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case MovieStatus.loaded:
        return ListView.builder(
          itemCount: state.movies.length,
          itemBuilder: (context, index) {
            final movie = state.movies[index];
            return ListTile(
              title: Text(movie.title),
              subtitle: Text(movie.genre),
              trailing: IconButton(
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
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: context.read<MovieCubit>(),
                      child: MovieDetailScreen(movieId: movie.id),
                    ),
                  ),
                );
              },
            );
          },
        );
      case MovieStatus.error:
        return Center(child: Text('Error: ${state.errorMessage}'));
    }
  }
}
