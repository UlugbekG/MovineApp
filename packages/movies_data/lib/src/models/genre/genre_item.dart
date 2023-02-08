import 'package:equatable/equatable.dart';

class GenreItem extends Equatable {
  final String id;
  final String name;
  final bool isSelected;

  GenreItem({
    required this.id,
    required this.name,
    this.isSelected = false,
  });

  @override
  List<Object?> get props => [id, name, isSelected];
}
