import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

import '../actions/get_movies.dart';
import '../data/movies_api.dart';
import '../models/app_state.dart';

class AppEpics {
  AppEpics(this._api);

  final MoviesApi _api;

  Epic<AppState> get epics {
    return combineEpics([
      TypedEpic<AppState, GetMovies>(getMovies),
    ]);
  }

  Stream<dynamic> getMovies(Stream<GetMovies> actions, EpicStore<AppState> store) {
    return actions //
        .flatMap<void>((GetMovies action) => Stream<void>.value(null)
        .asyncMap((_) => _api.getMovies(store.state.page))
        .map<Object>((List<MovieSummary> titles) => GetMoviesSuccessful(titles))
        .onErrorReturnWith((Object error, StackTrace stackTrace) => GetMoviesError(error))
        .doOnData(action.result));
  }
}
