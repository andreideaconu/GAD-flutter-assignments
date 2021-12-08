import 'dart:convert';

import 'package:http/http.dart';

import '../models/app_state.dart';

class MoviesApi {
  Future<List<MovieSummary>> getMovies(int page) async {
    final Uri uri = Uri(
      scheme: 'https',
      host: 'yts.mx',
      pathSegments: <String>['api', 'v2', 'list_movies.json'],
      queryParameters: <String, String>{
        'page': '$page',
      },
    );

    final Response response = await get(uri);
    if (response.statusCode != 200) {
      throw StateError('Error fetching the movies.');
    }

    final dynamic body = jsonDecode(response.body);
    final Map<String, dynamic> data = body['data'] as Map<String, dynamic>;
    final List<dynamic> movies = data['movies'] as List<dynamic>;

    return movies //
        .map((dynamic item) => MovieSummary(
            id: item['id'] as int,
            title: item['title'] as String,
            year: item['year'] as int,
            rating: item['rating'] as num,
            imageUrl: (item['small_cover_image'] ?? '') as String))
        .toList();
  }

  Future<MovieSummary> getMovieDetails(int movieId) async {
    final Uri uri = Uri(
      scheme: 'https',
      host: 'yts.mx',
      pathSegments: <String>['api', 'v2', 'movie_details.json'],
      queryParameters: <String, String>{
        'movie_id': '$movieId',
      },
    );

    final Response response = await get(uri);
    if (response.statusCode != 200) {
      throw StateError('Error fetching the movie.');
    }

    final dynamic body = jsonDecode(response.body);
    final Map<String, dynamic> data = body['data'] as Map<String, dynamic>;
    final dynamic movie = data['movie'] as dynamic;

    return MovieSummary(
        id: movie['id'] as int,
        title: movie['title'] as String,
        year: movie['year'] as int,
        rating: movie['rating'] as num,
        imageUrl: (movie['small_cover_image'] ?? '') as String);
  }
}
