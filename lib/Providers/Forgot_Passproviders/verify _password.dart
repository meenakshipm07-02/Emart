import 'package:flutter/material.dart';
import 'package:grocery_app/API/main_api.dart';

class ResetPasswordProvider with ChangeNotifier {
  final Main_Apis _api = Main_Apis();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _statusMessage;
  String? get statusMessage => _statusMessage;

  Future<void> resetPassword({
    required String email,
    required int otp,
    required String newPassword,
  }) async {
    _setLoading(true);

    try {
      final response = await _api.password_reset(email, otp, newPassword);

      if (response['status'] == 'success') {
        _statusMessage = response['message'] ?? 'Password updated successfully';
      } else {
        _statusMessage = response['message'] ?? 'Password update failed';
      }
    } catch (e) {
      _statusMessage = e.toString().replaceAll('Exception: ', '').trim();
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
