import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/search_history.dart';

part 'search_history_model.g.dart';

@JsonSerializable()
class SearchHistoryModel {
  final String id;
  final String query;
  @JsonKey(name: 'result_count')
  final int resultCount;
  @JsonKey(name: 'searched_at')
  final String searchedAt;

  SearchHistoryModel({
    required this.id,
    required this.query,
    required this.resultCount,
    required this.searchedAt,
  });

  factory SearchHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$SearchHistoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$SearchHistoryModelToJson(this);

  SearchHistory toEntity() {
    return SearchHistory(
      id: id,
      query: query,
      resultCount: resultCount,
      searchedAt: DateTime.parse(searchedAt),
    );
  }

  factory SearchHistoryModel.fromEntity(SearchHistory entity) {
    return SearchHistoryModel(
      id: entity.id,
      query: entity.query,
      resultCount: entity.resultCount,
      searchedAt: entity.searchedAt.toIso8601String(),
    );
  }
}
