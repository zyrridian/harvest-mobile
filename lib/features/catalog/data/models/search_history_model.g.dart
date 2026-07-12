// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchHistoryModel _$SearchHistoryModelFromJson(Map<String, dynamic> json) =>
    SearchHistoryModel(
      id: json['id'] as String,
      query: json['query'] as String,
      resultCount: (json['result_count'] as num).toInt(),
      searchedAt: json['searched_at'] as String,
    );

Map<String, dynamic> _$SearchHistoryModelToJson(SearchHistoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'query': instance.query,
      'result_count': instance.resultCount,
      'searched_at': instance.searchedAt,
    };
