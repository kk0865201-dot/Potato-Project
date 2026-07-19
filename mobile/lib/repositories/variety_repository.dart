import '../models/paginated.dart';
import '../models/variety.dart';
import '../services/variety_service.dart';

/// Turns raw variety API responses into typed domain objects.
class VarietyRepository {
  final VarietyService _service;

  VarietyRepository(this._service);

  Future<Paginated<Variety>> getVarieties({
    int page = 1,
    String? search,
  }) async {
    final result = await _service.fetchVarieties(page: page, search: search);
    final items = (result.data as List)
        .map((json) => Variety.fromJson(json as Map<String, dynamic>))
        .toList();
    return Paginated.fromMeta(items, result.meta);
  }

  Future<Variety> getVariety(String slug) async {
    final result = await _service.fetchVariety(slug);
    return Variety.fromJson(result.data as Map<String, dynamic>);
  }
}
