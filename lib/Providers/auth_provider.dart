import 'package:flutter/material.dart';
import 'package:grocery_app/API/auth_api.dart';
import 'package:grocery_app/Datastore/shared_pref.dart';

class AuthProvider with ChangeNotifier {
  final Api _api = Api();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _api.authenticate(email, password);
      print("API response: $response");

      if (response['status'] == 'success') {
        await SharedPrefs.saveToken(response['token']);
        await SharedPrefs.saveUserId(response['user']['id']);
        await SharedPrefs.saveUsername(response['user']['name']);
        await SharedPrefs.saveUserEmail(response['user']['email']);
        await SharedPrefs.saveUserPhone(response['user']['phone']);

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        _errorMessage = response['message'] ?? 'Invalid email or password';
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
