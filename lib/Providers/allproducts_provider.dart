import 'package:flutter/foundation.dart';
import 'package:grocery_app/API/main_api.dart';
import 'package:grocery_app/Models/product_Model/allproducts_model.dart';

class AllproductsProvider with ChangeNotifier {
  final Main_Apis _mainApis = Main_Apis();

  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = false;
  String _errorMessage = '';
  bool _hasError = false;
  String _searchQuery = '';

  List<Product> get products =>
      _searchQuery.isEmpty ? _products : _filteredProducts;
  List<Product> get allProducts => _products;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get hasError => _hasError;
  String get searchQuery => _searchQuery;

  // Get product by ID
  Product? getProductById(String id) {
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  // Search products
  void searchProducts(String query) {
    _searchQuery = query.trim();

    if (_searchQuery.isEmpty) {
      _filteredProducts = _products;
    } else {
      _filteredProducts = _products
          .where(
            (product) =>
                product.name.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }
    notifyListeners();
  }

  // Clear search
  void clearSearch() {
    _searchQuery = '';
    _filteredProducts = _products;
    notifyListeners();
  }

  // Filter products by name (for external use)
  List<Product> filterProductsByName(String query) {
    if (query.isEmpty) return _products;

    return _products
        .where(
          (product) => product.name.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  // Sort products by price (new price)
  List<Product> sortProductsByPrice({bool ascending = true}) {
    final sortedProducts = List<Product>.from(products);

    sortedProducts.sort((a, b) {
      final priceA = double.tryParse(a.newPrice) ?? 0;
      final priceB = double.tryParse(b.newPrice) ?? 0;

      return ascending ? priceA.compareTo(priceB) : priceB.compareTo(priceA);
    });

    return sortedProducts;
  }

  // Sort products by discount percentage
  List<Product> sortProductsByDiscount({bool ascending = true}) {
    final sortedProducts = List<Product>.from(products);

    sortedProducts.sort((a, b) {
      final discountA = a.discountPercentage;
      final discountB = b.discountPercentage;

      return ascending
          ? discountA.compareTo(discountB)
          : discountB.compareTo(discountA);
    });

    return sortedProducts;
  }

  // Get products with discount
  List<Product> get discountedProducts {
    return products.where((product) => product.hasDiscount).toList();
  }

  // Get products in stock
  List<Product> get inStockProducts {
    return products.where((product) {
      final stock = int.tryParse(product.stock) ?? 0;
      return stock > 0;
    }).toList();
  }

  // Get out of stock products
  List<Product> get outOfStockProducts {
    return products.where((product) {
      final stock = int.tryParse(product.stock) ?? 0;
      return stock <= 0;
    }).toList();
  }

  // Fetch all products
  Future<void> fetchAllProducts() async {
    _isLoading = true;
    _hasError = false;
    _errorMessage = '';
    _searchQuery = '';
    notifyListeners();

    try {
      final response = await _mainApis.getallproducts();

      final productResponse = ProductResponse.fromJson(response);

      if (productResponse.status == 'success') {
        _products = productResponse.products;
        _filteredProducts = _products;
        _hasError = false;
        _errorMessage = '';
      } else {
        _hasError = true;
        _errorMessage = 'Failed to fetch products';
        _products = [];
        _filteredProducts = [];
      }
    } catch (e) {
      _hasError = true;
      _errorMessage = e.toString();
      _products = [];
      _filteredProducts = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Refresh products
  Future<void> refreshProducts() async {
    await fetchAllProducts();
  }

  // Clear error state
  void clearError() {
    _hasError = false;
    _errorMessage = '';
    notifyListeners();
  }

  // Clear all data
  void clear() {
    _products = [];
    _filteredProducts = [];
    _isLoading = false;
    _hasError = false;
    _errorMessage = '';
    _searchQuery = '';
    notifyListeners();
  }
}
