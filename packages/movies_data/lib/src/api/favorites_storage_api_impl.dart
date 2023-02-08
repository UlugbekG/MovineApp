import 'package:hive/hive.dart';
import 'package:movies_data/movies_data.dart';
import 'package:rxdart/rxdart.dart';
import 'package:storage_api/storage_api.dart';

class FavoritesStorageApiImpl extends FavoritesStorageApi {
  FavoritesStorageApiImpl({
    required this.boxCollection,
    required this.collectionName,
  }) {
    init();
  }

  final BoxCollection boxCollection;
  final String collectionName;

  late CollectionBox collectionBox;

  Future<void> init() async {
    collectionBox = await boxCollection.openBox(collectionName);
    final map = await collectionBox.getAllValues();
    if (map.isNotEmpty) {
      final movies = <MovieItemEntity>[];
      map.values.forEach((e) {
        movies.add(MovieItemEntity(
            e['id'], e['poster_path'], e['title'], e['rating']));
      });
      _moviesStreamController.add(movies);
    } else {
      _moviesStreamController.add([]);
    }
  }

  final _moviesStreamController =
      BehaviorSubject<List<MovieItemEntity>>.seeded(const []);

  @override
  Stream<List<MovieItemEntity>> getMovies() =>
      _moviesStreamController.asBroadcastStream();

  @override
  Future<void> clearAll() async {
    // delete one or more entries
    // await catsBox.delete('loki');
    // await catsBox.deleteAll(['loki', 'fluffy']);

    // ...or clear the whole box at once
    await collectionBox.clear();
    _moviesStreamController.add([]);
  }

  @override
  Future<void> deleteMovie(String id) async {
    await collectionBox.delete(id);
    final values = [..._moviesStreamController.value];
    final index = values.indexWhere((movie) => movie.id == id);
    if (index != -1) {
      values.removeAt(index);
      _moviesStreamController.add(values);
    } else {
      throw MovieNotFoundException();
    }
  }

  @override
  Future<void> saveMovie(MovieItemEntity movie) async {
    await collectionBox.put(movie.id, movie.toJson());
    final values = [..._moviesStreamController.value];
    values.add(movie);
    _moviesStreamController.add(values);
  }

  @override
  Future<bool> checkWhetherIsMarkedOrNot(String id) async {
    final value = _moviesStreamController.value;
    return value.indexWhere((movie) => movie.id == id) != -1;
  }

  @override
  void close() {
    _moviesStreamController.close();
  }
}
