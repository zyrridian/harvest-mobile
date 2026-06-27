// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryModel _$CategoryModelFromJson(Map<String, dynamic> json) =>
    CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String,
      emoji: json['emoji'] as String,
      gradientColors: (json['gradient_colors'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      productCount: (json['product_count'] as num).toInt(),
      displayOrder: (json['display_order'] as num).toInt(),
      isActive: json['is_active'] as bool,
    );

Map<String, dynamic> _$CategoryModelToJson(CategoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'description': instance.description,
      'emoji': instance.emoji,
      'gradient_colors': instance.gradientColors,
      'product_count': instance.productCount,
      'display_order': instance.displayOrder,
      'is_active': instance.isActive,
    };
