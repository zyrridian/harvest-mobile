import 'package:equatable/equatable.dart';

class SearchSuggestion extends Equatable {
  final String type; // product, category, farmer
  final String text;
  final String id;

  const SearchSuggestion({
    required this.type,
    required this.text,
    required this.id,
  });

  @override
  List<Object?> get props => [type, text, id];
}
