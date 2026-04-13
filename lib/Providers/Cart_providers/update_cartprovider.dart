import 'package:flutter/foundation.dart';
import 'package:grocery_app/API/main_api.dart';

class UpdateCartProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _message;
  bool _isError = false;

  bool get isLoading => _isLoading;
  String? get message => _message;
  bool get isError => _isError;

  final Main_Apis _api = Main_Apis();

  Future<String> updateCart(int productId, int quantity) async {
    _isLoading = true;
    _isError = false;
    _message = null;
    notifyListeners();

    try {
      final response = await _api.updateCart(productId, quantity);

      if (response['status'] == 'success') {
        _message = response['message'] ?? 'Cart updated successfully';
      } else {
        _message = response['message'] ?? 'Failed to update cart';
        _isError = true;
      }
      return _message!;
    } catch (e) {
      _message = e.toString(); // clean readable error
      _isError = true;
      return _message!;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
