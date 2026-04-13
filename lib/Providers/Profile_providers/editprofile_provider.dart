import 'package:flutter/material.dart';
import 'package:grocery_app/API/main_api.dart';

class EditProfileProvider with ChangeNotifier {
  final Main_Apis _api = Main_Apis();

  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  Future<bool> editProfile({
    required String name,
    required String email,
    required String phone,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final int phoneNum = int.tryParse(phone) ?? 0;

      final response = await _api.editProfile(phoneNum, name, email);

      if (response['status'] == 'success') {
        _isLoading = false;
        _successMessage = response['message'] ?? 'Profile updated successfully';
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        _errorMessage = response['message'] ?? 'Profile update failed';
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
