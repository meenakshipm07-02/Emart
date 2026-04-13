import 'package:flutter/material.dart';
import 'package:grocery_app/API/main_api.dart';

class RemoveAddressProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Map<String, dynamic>? _response;
  Map<String, dynamic>? get response => _response;

  Future<void> removeAddress(int addressId) async {
    _isLoading = true;
    _response = null;
    notifyListeners();

    try {
      final result = await Main_Apis().remove_address(addressId);
      _response = result;
    } catch (e) {
      _response = {'status': 'error', 'message': e.toString()};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    _isLoading = false;
    _response = null;
    notifyListeners();
  }
}
