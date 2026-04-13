import 'package:flutter/material.dart';
import 'package:grocery_app/API/main_api.dart';
import 'package:grocery_app/Models/Product_Model/product_model.dart';

class ProductlistProvider extends ChangeNotifier {
  final Main_Apis _api = Main_Apis();

  List<ProductModel> _products = [];
  List<ProductModel> get products =>
      _filteredProducts.isEmpty && _searchText.isEmpty
      ? _products
      : _filteredProducts;

  List<ProductModel> _filteredProducts = [];
  String _searchText = "";
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchProductsByCategory(String categoryId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _api.getProductsByCategory(categoryId);

      if (response['status'] == true || response['products'] != null) {
        final List<dynamic> data = response['products'];
        _products = data.map((json) => ProductModel.fromJson(json)).toList();
        _filteredProducts = _products;
      } else {
        _errorMessage = response['message'] ?? 'Failed to load products';
      }
    } catch (e) {
      final errorText = e.toString().replaceAll('Exception: ', '').trim();
      _errorMessage = errorText.isEmpty
          ? 'Something went wrong while fetching products.'
          : errorText;
    }

    _isLoading = false;
    notifyListeners();
  }

  void filterProducts(String query) {
    _searchText = query;
    if (query.isEmpty) {
      _filteredProducts = _products;
    } else {
      _filteredProducts = _products
          .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
}
