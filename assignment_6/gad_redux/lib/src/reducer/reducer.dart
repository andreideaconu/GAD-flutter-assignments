import 'package:redux/redux.dart';

import '../actions/get_movies.dart';
import '../models/app_state.dart';

Reducer<AppState> reducer = combineReducers<AppState>(<Reducer<AppState>>[
  TypedReducer<AppState, GetMovies>(_getMovies),
  TypedReducer<AppState, GetMoviesSuccessful>(_getMoviesSuccessful),
  TypedReducer<AppState, GetMoviesError>(_getMoviesError),
]);

AppState _getMovies(AppState state, GetMovies action) {
  return state.copyWith(isLoading: true);
}

AppState _getMoviesSuccessful(AppState state, GetMoviesSuccessful action) {
  final List<MovieSummary> titles = <MovieSummary>[];
  titles.addAll(state.titles);
  titles.addAll(action.titles);

  return state.copyWith(
    titles: titles,
    page: state.page + 1,
    isLoading: false,
  );
}

AppState _getMoviesError(AppState state, GetMoviesError action) {
  return state.copyWith(isLoading: false);
}

AppState _getMovieDetails(AppState state, GetMovieDetails action) {
  return state.copyWith();
}

AppState _getMovieDetailsSuccessful(AppState state, GetMovieDetailsSuccessful action) {
  final MovieDetails details = action.details;

  return state.copyWith(
    details: details,
  );
}
