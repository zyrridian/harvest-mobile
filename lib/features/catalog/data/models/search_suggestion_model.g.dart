// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_suggestion_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchSuggestionModel _$SearchSuggestionModelFromJson(
        Map<String, dynamic> json) =>
    SearchSuggestionModel(
      type: json['type'] as String,
      text: json['text'] as String,
      id: json['id'] as String,
    );

Map<String, dynamic> _$SearchSuggestionModelToJson(
        SearchSuggestionModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'text': instance.text,
      'id': instance.id,
    };
