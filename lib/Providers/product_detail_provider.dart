import 'package:flutter/material.dart';
import 'package:grocery_app/API/main_api.dart';
import 'package:grocery_app/Models/Product_Model/product_detail_model.dart';

class ProductDetailProvider extends ChangeNotifier {
  final Main_Apis _api = Main_Apis();

  ProductDetailModel? _product;
  bool _isLoading = false;
  String? _errorMessage;

  ProductDetailModel? get product => _product;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchProductDetail(String productId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _api.getProductDetail(productId);

      if (response.isNotEmpty && response['id'] != null) {
        _product = ProductDetailModel.fromJson(response);
      } else {
        _errorMessage = 'No product data found';
      }
    } catch (e) {
      final errorText = e.toString().replaceAll('Exception: ', '').trim();
      _errorMessage = errorText.isEmpty
          ? 'Something went wrong while fetching product details.'
          : errorText;
    }

    _isLoading = false;
    notifyListeners();
  }
}
