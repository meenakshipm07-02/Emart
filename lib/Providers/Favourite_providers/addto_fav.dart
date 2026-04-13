import 'package:flutter/foundation.dart';
import 'package:grocery_app/API/main_api.dart';

class AddFavouriteProvider extends ChangeNotifier {
  final Main_Apis _api = Main_Apis();

  bool isLoading = false;
  String? message;
  bool isError = false;

  Future<void> addFavourite(int productId) async {
    try {
      isLoading = true;
      isError = false;
      message = null;
      notifyListeners();

      final response = await _api.addToFavorites(productId);

      if (response['status'] == 'success') {
        message = 'Added to favourites successfully';
      } else {
        message = response['message'] ?? 'Something went wrong';
        isError = true;
      }
    } catch (e) {
      final errorText = e.toString().replaceAll('Exception: ', '').trim();
      message = errorText.isEmpty ? 'Error adding favourite' : errorText;
      isError = true;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
