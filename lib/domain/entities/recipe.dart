import 'package:equatable/equatable.dart';

class Recipe extends Equatable {
  final String id;
  final String authorId;
  final String title;
  final String description;
  final String imageUrl;
  final int prepTimeMinutes;
  final int cookTimeMinutes;
  final int servings;
  final String? difficulty;
  final bool isFeatured;
  final List<String> instructions;
  final int likesCount;
  final int viewsCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final RecipeAuthor author;

  const Recipe({
    required this.id,
    required this.authorId,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.prepTimeMinutes,
    required this.cookTimeMinutes,
    required this.servings,
    this.difficulty,
    required this.isFeatured,
    this.instructions = const [],
    required this.likesCount,
    required this.viewsCount,
    required this.createdAt,
    required this.updatedAt,
    required this.author,
  });

  @override
  List<Object?> get props => [
        id,
        authorId,
        title,
        description,
        imageUrl,
        prepTimeMinutes,
        cookTimeMinutes,
        servings,
        difficulty,
        isFeatured,
        instructions,
        likesCount,
        viewsCount,
        createdAt,
        updatedAt,
        author,
      ];
}

class RecipeAuthor extends Equatable {
  final String id;
  final String name;
  final String? avatarUrl;

  const RecipeAuthor({
    required this.id,
    required this.name,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [id, name, avatarUrl];
}
