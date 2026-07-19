import 'package:flutter/foundation.dart';

import '../models/api_exception.dart';
import '../models/variety.dart';
import '../repositories/variety_repository.dart';
import '../utils/view_state.dart';

/// Loads the potato varieties list from the API with search + pagination.
class VarietiesProvider extends ChangeNotifier {
  final VarietyRepository _repository;

  VarietiesProvider(this._repository);

  final List<Variety> _items = [];
  ViewState _state = ViewState.idle;
  ApiException? _error;
  bool _isLoadingMore = false;
  int _currentPage = 1;
  int _lastPage = 1;
  String _search = '';

  List<Variety> get items => List.unmodifiable(_items);
  List<Variety> get featured =>
      _items.where((variety) => variety.featured).toList();
  ViewState get state => _state;
  ApiException? get error => _error;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _currentPage < _lastPage;
  String get search => _search;

  /// Loads page 1 (also used by pull-to-refresh and retry).
  Future<void> load() async {
    _state = ViewState.loading;
    _error = null;
    notifyListeners();

    try {
      final page = await _repository.getVarieties(page: 1, search: _search);
      _items
        ..clear()
        ..addAll(page.items);
      _currentPage = page.currentPage;
      _lastPage = page.lastPage;
      _state = ViewState.loaded;
    } on ApiException catch (e) {
      _error = e;
      _state = ViewState.error;
    }
    notifyListeners();
  }

  /// Loads the next page when the user scrolls near the bottom.
  Future<void> loadMore() async {
    if (_isLoadingMore || !hasMore || _state != ViewState.loaded) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final page = await _repository.getVarieties(
        page: _currentPage + 1,
        search: _search,
      );
      _items.addAll(page.items);
      _currentPage = page.currentPage;
      _lastPage = page.lastPage;
    } on ApiException {
      // Keep what we already have; the user can scroll again to retry.
    }

    _isLoadingMore = false;
    notifyListeners();
  }

  Future<void> setSearch(String query) async {
    final normalized = query.trim();
    if (normalized == _search) return;
    _search = normalized;
    await load();
  }
}
