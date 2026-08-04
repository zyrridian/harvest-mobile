import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harvest_app/core/models/paginated_response.dart';
import 'package:harvest_app/features/community/domain/entities/recipe.dart';

part 'recipe_state.freezed.dart';

@freezed
class RecipeState with _$RecipeState {
  const factory RecipeState.initial() = _Initial;
  const factory RecipeState.loading() = _Loading;
  const factory RecipeState.data(PaginatedResponse<Recipe> data) = _Data;
  const factory RecipeState.error(String message) = _Error;
}
