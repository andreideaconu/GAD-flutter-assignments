class MovieDetails {
  MovieDetails({required this.title, this.year, this.rating, this.imageUrl, this.coverUrl, this.description});

  final String title;
  final int? year;
  final num? rating;
  final String? imageUrl;
  final String? coverUrl;
  final String? description;
}

class MovieSummary {
  MovieSummary({required this.id, required this.title, this.year, this.rating, this.imageUrl});

  final int id;
  final String title;
  final int? year;
  final num? rating;
  final String? imageUrl;
}

class AppState {
  AppState({
    this.titles = const <MovieSummary>[],
    this.isLoading = false,
    this.page = 1,
    this.details,
  });

  final List<MovieSummary> titles;
  final bool isLoading;
  final int page;
  final MovieDetails? details;

  AppState copyWith({
    final List<MovieSummary>? titles,
    final bool? isLoading,
    final int? page,
    final MovieDetails? details,
  }) {
    return AppState(
      titles: titles ?? this.titles,
      isLoading: isLoading ?? this.isLoading,
      page: page ?? this.page,
      details: details ?? this.details,
    );
  }

  @override
  String toString() {
    return 'AppState{titles: $titles, isLoading: $isLoading, page: $page, details: $details}';
  }
}
