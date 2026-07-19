import 'package:flutter/foundation.dart';

import '../models/api_exception.dart';
import '../models/recipe.dart';
import '../repositories/recipe_repository.dart';
import '../utils/view_state.dart';

/// Loads the recipes list from the API with pagination.
class RecipesProvider extends ChangeNotifier {
  final RecipeRepository _repository;

  RecipesProvider(this._repository);

  final List<Recipe> _items = [];
  ViewState _state = ViewState.idle;
  ApiException? _error;
  bool _isLoadingMore = false;
  int _currentPage = 1;
  int _lastPage = 1;

  List<Recipe> get items => List.unmodifiable(_items);
  ViewState get state => _state;
  ApiException? get error => _error;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _currentPage < _lastPage;

  Future<void> load() async {
    _state = ViewState.loading;
    _error = null;
    notifyListeners();

    try {
      final page = await _repository.getRecipes(page: 1);
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

  Future<void> loadMore() async {
    if (_isLoadingMore || !hasMore || _state != ViewState.loaded) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final page = await _repository.getRecipes(page: _currentPage + 1);
      _items.addAll(page.items);
      _currentPage = page.currentPage;
      _lastPage = page.lastPage;
    } on ApiException {
      // Keep what we already have; scrolling again retries.
    }

    _isLoadingMore = false;
    notifyListeners();
  }
}
