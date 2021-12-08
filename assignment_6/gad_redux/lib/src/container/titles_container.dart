import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../models/app_state.dart';

class TitlesContainer extends StatelessWidget {
  const TitlesContainer({Key? key, required this.builder}) : super(key: key);

  final ViewModelBuilder<List<MovieSummary>> builder;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<MovieSummary>>(
      converter: (Store<AppState> store) {
        return store.state.titles;
      },
      builder: builder,
    );
  }
}
