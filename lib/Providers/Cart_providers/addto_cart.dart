import 'package:flutter/foundation.dart';
import 'package:grocery_app/API/main_api.dart';

class AddToCartProvider extends ChangeNotifier {
  final Main_Apis _api = Main_Apis();
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<String> addToCart(String productId, int quantity) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _api.addToCart(productId, quantity);

      if (response['status'] == 'success') {
        return response['message'] ?? 'Added to cart';
      } else {
        _errorMessage = response['message'] ?? 'Failed to add item';
        return Future.error(_errorMessage!);
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '').trim();
      return Future.error(_errorMessage!);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
