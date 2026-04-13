import 'package:flutter/material.dart';
import 'package:grocery_app/API/main_api.dart';
import 'package:grocery_app/Models/Category_Model/catogories_model.dart';

class CategoryProvider extends ChangeNotifier {
  final Main_Apis _api = Main_Apis();

  List<CategoryModel> _categories = [];
  List<CategoryModel> get categories =>
      _filteredCategories.isEmpty && _searchText.isEmpty
      ? _categories
      : _filteredCategories;

  List<CategoryModel> _filteredCategories = [];
  String _searchText = "";

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchCategories() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _api.getCategories();

      if (response['status'] == true || response['categories'] != null) {
        final List<dynamic> data = response['categories'];
        _categories = data.map((json) => CategoryModel.fromJson(json)).toList();
        _filteredCategories = _categories;
      } else {
        _errorMessage = response['message'] ?? 'Failed to load categories';
      }
    } catch (e) {
      final errorText = e.toString().replaceAll('Exception: ', '').trim();
      _errorMessage = errorText.isEmpty
          ? 'Something went wrong while fetching categories.'
          : errorText;
    }

    _isLoading = false;
    notifyListeners();
  }

  //  Filter categories based on search text
  void filterCategories(String query) {
    _searchText = query;
    if (query.isEmpty) {
      _filteredCategories = _categories;
    } else {
      _filteredCategories = _categories
          .where(
            (category) =>
                category.name.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }
    notifyListeners();
  }
}
