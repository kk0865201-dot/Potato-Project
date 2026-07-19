import '../models/paginated.dart';
import '../models/recipe.dart';
import '../services/recipe_service.dart';

/// Turns raw recipe API responses into typed domain objects.
class RecipeRepository {
  final RecipeService _service;

  RecipeRepository(this._service);

  Future<Paginated<Recipe>> getRecipes({int page = 1, String? search}) async {
    final result = await _service.fetchRecipes(page: page, search: search);
    final items = (result.data as List)
        .map((json) => Recipe.fromJson(json as Map<String, dynamic>))
        .toList();
    return Paginated.fromMeta(items, result.meta);
  }

  Future<Recipe> getRecipe(String slug) async {
    final result = await _service.fetchRecipe(slug);
    return Recipe.fromJson(result.data as Map<String, dynamic>);
  }
}
