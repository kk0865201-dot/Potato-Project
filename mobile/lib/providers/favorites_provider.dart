import 'package:flutter/foundation.dart';

import '../models/api_exception.dart';
import '../models/variety.dart';
import '../repositories/favorite_repository.dart';
import '../utils/view_state.dart';

/// Global favorites list, synchronized with the Laravel backend.
/// Every heart icon in the app reads and writes through this provider.
class FavoritesProvider extends ChangeNotifier {
  final FavoriteRepository _repository;

  FavoritesProvider(this._repository);

  final List<Variety> _items = [];
  final Set<int> _ids = {};
  ViewState _state = ViewState.idle;
  ApiException? _error;

  List<Variety> get items => List.unmodifiable(_items);
  ViewState get state => _state;
  ApiException? get error => _error;
  bool get isEmpty => _items.isEmpty;

  bool isFavorite(int varietyId) => _ids.contains(varietyId);

  Future<void> load() async {
    _state = ViewState.loading;
    _error = null;
    notifyListeners();

    try {
      final favorites = await _repository.getFavorites();
      _items
        ..clear()
        ..addAll(favorites);
      _ids
        ..clear()
        ..addAll(favorites.map((variety) => variety.id));
      _state = ViewState.loaded;
    } on ApiException catch (e) {
      _error = e;
      _state = ViewState.error;
    }
    notifyListeners();
  }

  /// Adds/removes optimistically so the heart reacts instantly, then rolls
  /// back if the server rejects the change.
  Future<void> toggle(Variety variety) async {
    if (isFavorite(variety.id)) {
      _removeLocally(variety.id);
      try {
        await _repository.remove(variety.id);
      } on ApiException {
        _addLocally(variety);
        notifyListeners();
        rethrow;
      }
    } else {
      _addLocally(variety);
      try {
        await _repository.add(variety.id);
      } on ApiException {
        _removeLocally(variety.id);
        notifyListeners();
        rethrow;
      }
    }
  }

  /// Called on logout so the next user starts with a clean list.
  void reset() {
    _items.clear();
    _ids.clear();
    _state = ViewState.idle;
    _error = null;
    notifyListeners();
  }

  void _addLocally(Variety variety) {
    if (_ids.add(variety.id)) {
      _items.add(variety);
      notifyListeners();
    }
  }

  void _removeLocally(int varietyId) {
    if (_ids.remove(varietyId)) {
      _items.removeWhere((variety) => variety.id == varietyId);
      notifyListeners();
    }
  }
}
