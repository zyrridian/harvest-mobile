import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/search_suggestion.dart';

part 'search_suggestion_model.g.dart';

@JsonSerializable()
class SearchSuggestionModel {
  final String type;
  final String text;
  final String id;

  SearchSuggestionModel({
    required this.type,
    required this.text,
    required this.id,
  });

  factory SearchSuggestionModel.fromJson(Map<String, dynamic> json) =>
      _$SearchSuggestionModelFromJson(json);

  Map<String, dynamic> toJson() => _$SearchSuggestionModelToJson(this);

  SearchSuggestion toEntity() {
    return SearchSuggestion(
      type: type,
      text: text,
      id: id,
    );
  }

  factory SearchSuggestionModel.fromEntity(SearchSuggestion entity) {
    return SearchSuggestionModel(
      type: entity.type,
      text: entity.text,
      id: entity.id,
    );
  }
}
