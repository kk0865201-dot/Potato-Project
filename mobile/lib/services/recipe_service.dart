import '../constants/api_constants.dart';
import 'api_client.dart';

/// Raw calls to the recipe endpoints.
class RecipeService {
  final ApiClient _client;

  RecipeService(this._client);

  Future<ApiResult> fetchRecipes({
    int page = 1,
    int perPage = ApiConstants.defaultPerPage,
    String? search,
  }) {
    return _client.get('/recipes', query: {
      'page': '$page',
      'per_page': '$perPage',
      if (search != null && search.isNotEmpty) 'search': search,
    });
  }

  Future<ApiResult> fetchRecipe(String slug) => _client.get('/recipes/$slug');
}
