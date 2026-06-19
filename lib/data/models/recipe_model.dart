import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/recipe.dart';

part 'recipe_model.g.dart';

@JsonSerializable()
class RecipeModel {
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
  final String createdAt;
  final String updatedAt;
  final RecipeAuthorModel author;

  const RecipeModel({
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

  factory RecipeModel.fromJson(Map<String, dynamic> json) =>
      _$RecipeModelFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeModelToJson(this);

  Recipe toEntity() {
    return Recipe(
      id: id,
      authorId: authorId,
      title: title,
      description: description,
      imageUrl: imageUrl,
      prepTimeMinutes: prepTimeMinutes,
      cookTimeMinutes: cookTimeMinutes,
      servings: servings,
      difficulty: difficulty,
      isFeatured: isFeatured,
      instructions: instructions,
      likesCount: likesCount,
      viewsCount: viewsCount,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
      author: author.toEntity(),
    );
  }

  factory RecipeModel.fromEntity(Recipe entity) {
    return RecipeModel(
      id: entity.id,
      authorId: entity.authorId,
      title: entity.title,
      description: entity.description,
      imageUrl: entity.imageUrl,
      prepTimeMinutes: entity.prepTimeMinutes,
      cookTimeMinutes: entity.cookTimeMinutes,
      servings: entity.servings,
      difficulty: entity.difficulty,
      isFeatured: entity.isFeatured,
      instructions: entity.instructions,
      likesCount: entity.likesCount,
      viewsCount: entity.viewsCount,
      createdAt: entity.createdAt.toIso8601String(),
      updatedAt: entity.updatedAt.toIso8601String(),
      author: RecipeAuthorModel.fromEntity(entity.author),
    );
  }
}

@JsonSerializable()
class RecipeAuthorModel {
  final String id;
  final String name;
  final String? avatarUrl;

  const RecipeAuthorModel({
    required this.id,
    required this.name,
    this.avatarUrl,
  });

  factory RecipeAuthorModel.fromJson(Map<String, dynamic> json) =>
      _$RecipeAuthorModelFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeAuthorModelToJson(this);

  RecipeAuthor toEntity() {
    return RecipeAuthor(
      id: id,
      name: name,
      avatarUrl: avatarUrl,
    );
  }

  factory RecipeAuthorModel.fromEntity(RecipeAuthor entity) {
    return RecipeAuthorModel(
      id: entity.id,
      name: entity.name,
      avatarUrl: entity.avatarUrl,
    );
  }
}
