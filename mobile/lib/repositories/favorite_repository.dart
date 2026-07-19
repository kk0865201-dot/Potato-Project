import '../models/variety.dart';
import '../services/favorite_service.dart';

/// Turns raw favorites API responses into typed domain objects.
/// Favorites live on the Laravel server — the app never stores them locally.
class FavoriteRepository {
  final FavoriteService _service;

  FavoriteRepository(this._service);

  Future<List<Variety>> getFavorites() async {
    final result = await _service.fetchFavorites();
    return (result.data as List)
        .map((json) => Variety.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> add(int varietyId) => _service.addFavorite(varietyId);

  Future<void> remove(int varietyId) => _service.removeFavorite(varietyId);
}
