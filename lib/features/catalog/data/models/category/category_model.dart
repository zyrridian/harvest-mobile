import 'package:harvest_app/features/catalog/domain/entities/category.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category_model.g.dart';

@JsonSerializable()
class CategoryModel {
  final String id;
  final String name;
  final String slug;
  final String description;
  final String emoji;
  @JsonKey(name: 'gradient_colors')
  final List<String> gradientColors;
  @JsonKey(name: 'product_count')
  final int productCount;
  @JsonKey(name: 'display_order')
  final int displayOrder;
  @JsonKey(name: 'is_active')
  final bool isActive;

  CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.emoji,
    required this.gradientColors,
    required this.productCount,
    required this.displayOrder,
    required this.isActive,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);

  Category toEntity() {
    return Category(
      id: id,
      name: name,
      description: description,
      emoji: emoji,
      gradientColors: gradientColors,
      productCount: productCount,
    );
  }
}
