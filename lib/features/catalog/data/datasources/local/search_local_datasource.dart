import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:harvest_app/features/catalog/data/models/search_history_model.dart';
import 'package:harvest_app/features/catalog/data/models/search_suggestion_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../core/error/exceptions.dart';

abstract class SearchLocalDataSource {
  Future<void> saveRecentSearches(List<SearchHistoryModel> searches);
  Future<List<SearchHistoryModel>?> getRecentSearches();
  
  Future<void> saveSearchSuggestions(List<SearchSuggestionModel> suggestions);
  Future<List<SearchSuggestionModel>?> getSearchSuggestions();
  
  Future<void> clearRecentSearches();
}

class SearchLocalDataSourceImpl implements SearchLocalDataSource {
  final FlutterSecureStorage secureStorage;
  final SharedPreferences sharedPreferences;

  static const String _recentSearchesKey = 'local_recent_searches';
  static const String _searchSuggestionsKey = 'local_search_suggestions';

  SearchLocalDataSourceImpl({
    required this.secureStorage,
    required this.sharedPreferences,
  });

  @override
  Future<List<SearchHistoryModel>?> getRecentSearches() async {
    try {
      final jsonString = sharedPreferences.getString(_recentSearchesKey);
      if (jsonString != null) {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        return jsonList.map<SearchHistoryModel>((json) => SearchHistoryModel.fromJson(json as Map<String, dynamic>)).toList();
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get local recent searches: $e');
    }
  }

  @override
  Future<void> saveRecentSearches(List<SearchHistoryModel> searches) async {
    try {
      final jsonList = searches.map<Map<String, dynamic>>((model) => model.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      await sharedPreferences.setString(_recentSearchesKey, jsonString);
    } catch (e) {
      throw CacheException('Failed to save local recent searches: $e');
    }
  }

  @override
  Future<List<SearchSuggestionModel>?> getSearchSuggestions() async {
    try {
      final jsonString = sharedPreferences.getString(_searchSuggestionsKey);
      if (jsonString != null) {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        return jsonList.map<SearchSuggestionModel>((json) => SearchSuggestionModel.fromJson(json as Map<String, dynamic>)).toList();
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get local search suggestions: $e');
    }
  }

  @override
  Future<void> saveSearchSuggestions(List<SearchSuggestionModel> suggestions) async {
    try {
      final jsonList = suggestions.map<Map<String, dynamic>>((model) => model.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      await sharedPreferences.setString(_searchSuggestionsKey, jsonString);
    } catch (e) {
      throw CacheException('Failed to save local search suggestions: $e');
    }
  }

  @override
  Future<void> clearRecentSearches() async {
    try {
      await sharedPreferences.remove(_recentSearchesKey);
    } catch (e) {
      throw CacheException('Failed to clear local recent searches: $e');
    }
  }
}
