import 'package:flutter/material.dart';
import 'package:grocery_app/API/main_api.dart';

class CreateaccProvider with ChangeNotifier {
  final Main_Apis _api = Main_Apis();

  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  Future<bool> createAccount({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String address,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final response = await _api.createaccount(
        name,
        email,
        password,
        phone,
        address,
      );

      if (response['status'] == 'success') {
        _isLoading = false;
        _successMessage = response['message'] ?? 'Account created successfully';
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        _errorMessage = response['message'] ?? 'Registration failed';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;

      final errorText = e.toString().replaceAll('Exception: ', '').trim();

      _errorMessage = errorText.isEmpty
          ? 'An unexpected error occurred.'
          : errorText;

      notifyListeners();
      return false;
    }
  }
}
