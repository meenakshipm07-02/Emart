import 'package:flutter/foundation.dart';
import 'package:grocery_app/API/main_api.dart';

class RemoveCartproductProvider extends ChangeNotifier {
  final Main_Apis _api = Main_Apis();

  bool isLoading = false;
  String? message;
  bool isError = false;

  Future<void> removecartitem(int productId) async {
    try {
      isLoading = true;
      isError = false;
      message = null;
      notifyListeners();

      final response = await _api.removeFromCart(productId);

      if (response['status'] == 'success') {
        message = 'Removed from cart successfully';
      } else {
        message = response['message'] ?? 'Something went wrong';
        isError = true;
      }
    } catch (e) {
      message = e.toString();
      isError = true;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
