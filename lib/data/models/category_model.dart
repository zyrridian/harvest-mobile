import 'package:harvest_app/domain/entities/category.dart';

class CategoryModel extends Category {
  CategoryModel({
    required super.id,
    required super.name,
    required super.description,
    required super.emoji,
    super.iconName,
    required super.gradientColors,
    required super.productCount,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      emoji: json['emoji'] as String,
      iconName: json['iconName'] as String?,
      gradientColors: (json['gradientColors'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      productCount: json['productCount'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'emoji': emoji,
      'iconName': iconName,
      'gradientColors': gradientColors,
      'productCount': productCount,
    };
  }

  Category toEntity() {
    return Category(
      id: id,
      name: name,
      description: description,
      emoji: emoji,
      iconName: iconName,
      gradientColors: gradientColors,
      productCount: productCount,
    );
  }
}
