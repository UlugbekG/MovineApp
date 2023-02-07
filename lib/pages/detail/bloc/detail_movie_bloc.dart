import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:movies_data/movies_data.dart';

part 'detail_movie_state.dart';

part 'detail_movie_event.dart';

///TODO: create checker whether is market or not.
class DetailMovieBloc extends Bloc<DetailMovieEvent, DetailMovieState> {
  final MoviesRepository moviesRepository;
  final StorageRepository storageRepository;

  DetailMovieBloc({
    required this.moviesRepository,
    required this.storageRepository,
  }) : super(const DetailMovieState.initialState()) {
    on<FetchedMovieEvent>(_onFetchMovieDetailEvent);
    on<BookmarkEvent>(_onBookmarkEvent);
  }

  Future<void> _onFetchMovieDetailEvent(
    FetchedMovieEvent event,
    Emitter<DetailMovieState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      final movie = await moviesRepository.getMovieDetail(event.movieId);

      final movies =
          await moviesRepository.getSimilarMovies(movieId: event.movieId);

      final isMarked =
          await storageRepository.checkWhetherIsMarkedOrNot(movie.id);

      logger(isMarked);

      emit(state.copyWith(
        isLoading: false,
        movie: movie,
        movies: movies.movies,
        isMarked: isMarked,
      ));
    } catch (error) {
      emit(state.copyWith(isLoading: false, error: error));
    }
  }

  Future<void> _onBookmarkEvent(
    BookmarkEvent event,
    Emitter<DetailMovieState> emit,
  ) async {
    logger(state.isMarked);
    if (state.isMarked) {
      logger('delete');
      storageRepository.deleteMovie(event.item.id);
      emit(state.copyWith(isMarked: false));
    } else {
      logger('save');
      storageRepository.saveTodo(event.item);
      emit(state.copyWith(isMarked: true));
    }
  }
}
