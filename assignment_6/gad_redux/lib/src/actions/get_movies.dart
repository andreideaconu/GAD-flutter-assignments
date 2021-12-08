import '../models/app_state.dart';

class GetMovies {
  const GetMovies(this.result);

  final void Function(dynamic action) result;
}

class GetMoviesSuccessful {
  const GetMoviesSuccessful(this.titles);

  final List<MovieSummary> titles;
}

class GetMoviesError {
  const GetMoviesError(this.error);

  final Object error;
}

class GetMovieDetails {
  const GetMovieDetails(this.result);

  final void Function(dynamic action) result;
}

class GetMovieDetailsSuccessful {
  const GetMovieDetailsSuccessful(this.details);

  final MovieDetails details;
}
