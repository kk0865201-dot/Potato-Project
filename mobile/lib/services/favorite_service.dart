import 'api_client.dart';

/// Raw calls to the favorites endpoints (all require authentication).
class FavoriteService {
  final ApiClient _client;

  FavoriteService(this._client);

  Future<ApiResult> fetchFavorites() => _client.get('/favorites');

  Future<ApiResult> addFavorite(int varietyId) =>
      _client.post('/favorites', body: {'variety_id': varietyId});

  Future<ApiResult> removeFavorite(int varietyId) =>
      _client.delete('/favorites/$varietyId');
}
