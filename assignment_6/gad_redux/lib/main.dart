import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:gad_redux/src/data/movies_api.dart';
import 'package:gad_redux/src/epics/app_epics.dart';
import 'package:gad_redux/src/models/app_state.dart';
import 'package:gad_redux/src/presentation/home_page.dart';
import 'package:gad_redux/src/reducer/reducer.dart';
import 'package:redux/redux.dart';
import 'package:redux_epics/redux_epics.dart';

void main() {
  final MoviesApi moviesApi = MoviesApi();
  final AppEpics epics = AppEpics(moviesApi);

  final Store<AppState> store = Store<AppState>(
    reducer,
    initialState: AppState(),
    middleware: <Middleware<AppState>>[
          (Store<AppState> store, dynamic action, NextDispatcher next) {
        next(action);
        print(store.state);
      },
      EpicMiddleware<AppState>(epics.epics),
    ],
  );
  runApp(MyApp(store: store));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.store}) : super(key: key);

  final Store<AppState> store;

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Movie Database';

    return StoreProvider(
      store: store,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: appTitle,
        home: const HomePage(title: appTitle),
        theme: ThemeData.dark(),
      ),
    );
  }
}
