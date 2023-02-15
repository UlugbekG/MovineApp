import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/pages/home/bloc/home_bloc.dart';
import 'package:movie_app/pages/home/movies_see_all.dart';
import 'package:movie_app/pages/widgets/empty_view.dart';
import 'package:movie_app/pages/widgets/error_view.dart';
import 'package:movie_app/pages/widgets/movie_item_card.dart';
import 'package:movie_app/pages/widgets/progress_view.dart';
import 'package:movie_app/theme/app_typography.dart';
import 'package:movie_app/utils/status.dart';
import 'package:movie_app/utils/strings.dart' show populars, seeAll;
import 'package:movies_data/movies_data.dart';

class PopularMovies extends StatelessWidget {
  final double size;

  const PopularMovies({Key? key, required this.size}) : super(key: key);

  void navigateToAllMovies(BuildContext context) {
    Navigator.of(context).push(MoviesSeeAll.route(MovieType.NOW_PLAYING));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
            margin: const EdgeInsets.all(20),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(populars, style: AppTypography.labelLarge),
                  GestureDetector(
                      onTap: () {
                        navigateToAllMovies(context);
                      },
                      child: const Text(seeAll, style: AppTypography.bodyText1))
                ])),
        SizedBox(
          height: size,
          child: BlocBuilder<HomeBloc, HomeState>(
            buildWhen: (prev, current) =>
                prev.popularState != current.popularState,
            builder: (context, homeState) {
              return _buildComponents(
                state: homeState.popularState,
                retry: () {
                  context.read<HomeBloc>().add(FetchPopularMoviesEvent());
                },
              );
            },
          ),
        )
      ],
    );
  }

  Widget _buildComponents(
      {required PopularMoviesState state, required OnRetry retry}) {
    switch (state.status) {
      case Status.success:
        return _MoviesView(movies: state.movies, itemSize: size);
      case Status.pending:
        return const ProgressView();
      case Status.error:
        return ErrorView(onRetry: retry);
      case Status.empty:
        return const EmptyView();
    }
  }
}

class _MoviesView extends StatelessWidget {
  const _MoviesView({Key? key, required this.movies, required this.itemSize})
      : super(key: key);

  /// Single Item size
  final double itemSize;

  /// Movies coming remote or local storage
  final List<MovieItem> movies;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: movies.length,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(
            left: 8,
            right: index == movies.length - 1 ? 8 : 0,
          ),
          height: itemSize,
          width: itemSize * 0.8,
          child: MovieItemCard(movie: movies[index]),
        );
      },
    );
  }
}