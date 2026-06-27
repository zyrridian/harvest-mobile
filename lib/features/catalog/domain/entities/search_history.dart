import 'package:equatable/equatable.dart';

class SearchHistory extends Equatable {
  final String id;
  final String query;
  final int resultCount;
  final DateTime searchedAt;

  const SearchHistory({
    required this.id,
    required this.query,
    required this.resultCount,
    required this.searchedAt,
  });

  @override
  List<Object?> get props => [id, query, resultCount, searchedAt];
}
