import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harvest_app/core/providers/dio_provider.dart';
import 'package:equatable/equatable.dart';

class ProductUnit extends Equatable {
  final String value;
  final String label;

  const ProductUnit({required this.value, required this.label});

  factory ProductUnit.fromJson(Map<String, dynamic> json) {
    return ProductUnit(
      value: json['value'] as String,
      label: json['label'] as String,
    );
  }

  @override
  List<Object?> get props => [value, label];
}

final allUnitsProvider = FutureProvider<List<ProductUnit>>((ref) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get('/units');
  
  if (response.statusCode == 200) {
    final data = response.data['data'] as List;
    return data.map((e) => ProductUnit.fromJson(e as Map<String, dynamic>)).toList();
  } else {
    throw Exception('Failed to load units');
  }
});
