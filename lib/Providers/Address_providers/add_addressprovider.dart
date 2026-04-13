import 'package:flutter/material.dart';
import 'package:grocery_app/API/main_api.dart';

class AddAddressProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Map<String, dynamic>? _addressResponse;
  Map<String, dynamic>? get addressResponse => _addressResponse;

  final Main_Apis _api = Main_Apis();

  Future<void> addAddress({
    required String address,
    required String pincode,
    required String addressType,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _api.add_address(address, pincode, addressType);
      _addressResponse = response;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearResponse() {
    _addressResponse = null;
    _errorMessage = null;
    notifyListeners();
  }
}
