import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:gad_redux/src/actions/get_movies.dart';
import 'package:gad_redux/src/container/is_loading_container.dart';
import 'package:gad_redux/src/container/titles_container.dart';
import 'package:gad_redux/src/models/app_state.dart';
import 'package:redux/redux.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();

    final Store store = StoreProvider.of<AppState>(context, listen: false);
    store.dispatch(GetMovies(onResult));

    _controller.addListener(_onScroll);
  }

  void _onScroll() {
    final double currentPosition = _controller.offset;
    final double maxPosition = _controller.position.maxScrollExtent;

    final Store<AppState> store = StoreProvider.of<AppState>(context);

    if (!store.state.isLoading && currentPosition > (maxPosition - 1)) {
      store.dispatch(GetMovies(onResult));
    }
  }

  void onResult(dynamic action) {
    if (action is GetMoviesError) {
      showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error getting movies'),
            content: Text('${action.error}'),
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const lightGray = Colors.white70;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        foregroundColor: Colors.black,
        title: Text(widget.title),
        centerTitle: true,
        actions: <Widget>[
          IsLoadingContainer(
            builder: (BuildContext context, bool isLoading) {
              if (!isLoading) {
                return const SizedBox.shrink();
              }
              return const Center(
                child: CircularProgressIndicator(color: Colors.blue),
              );
            },
          ),
        ],
      ),
      body: TitlesContainer(
        builder: (BuildContext context, List<MovieSummary> titles) {
          return ListView.builder(
            controller: _controller,
            itemCount: titles.length,
            itemBuilder: (BuildContext context, int index) {
              final String title = titles[index].title;
              final int? year = titles[index].year;
              final num? rating = titles[index].rating;
              final String imageUrl = titles[index].imageUrl ?? '';

              return Container(
                margin: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, (index == titles.length - 1) ? 16.0 : 0.0),
                decoration: BoxDecoration(border: Border.all(color: Colors.yellowAccent)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.network(imageUrl),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 300,
                            child: Flexible(
                              child: Text(title),
                            ),
                          ),
                          Row(
                            children: [
                              Row(
                                children: year != null
                                    ? [
                                        const Padding(
                                          padding: EdgeInsetsDirectional.only(end: 5.0),
                                          child: Icon(
                                            Icons.access_time,
                                            color: lightGray,
                                            size: 14,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional.only(end: 7.0),
                                          child: Text(
                                            year.toString(),
                                            style: const TextStyle(color: lightGray),
                                          ),
                                        ),
                                      ]
                                    : [],
                              ),
                              Row(
                                children: rating != null
                                    ? [
                                        const Padding(
                                          padding: EdgeInsetsDirectional.only(end: 5.0),
                                          child: Icon(
                                            Icons.star_rate_sharp,
                                            color: lightGray,
                                            size: 14,
                                          ),
                                        ),
                                        Text(
                                          rating.toString(),
                                          style: const TextStyle(color: lightGray),
                                        ),
                                      ]
                                    : [],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
