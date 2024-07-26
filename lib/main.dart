import 'package:flutter/material.dart';
import 'package:poc/cubit_version/movie_list_screen.dart';
// import 'package:poc/provider_version/movie_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Material App',
      home: MovieListingScreen(),
    );
  }
}
