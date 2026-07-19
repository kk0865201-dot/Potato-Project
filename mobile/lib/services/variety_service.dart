import '../constants/api_constants.dart';
import 'api_client.dart';

/// Raw calls to the variety ("products") endpoints.
class VarietyService {
  final ApiClient _client;

  VarietyService(this._client);

  Future<ApiResult> fetchVarieties({
    int page = 1,
    int perPage = ApiConstants.defaultPerPage,
    String? search,
  }) {
    return _client.get('/varieties', query: {
      'page': '$page',
      'per_page': '$perPage',
      if (search != null && search.isNotEmpty) 'search': search,
    });
  }

  Future<ApiResult> fetchVariety(String slug) => _client.get('/varieties/$slug');
}
