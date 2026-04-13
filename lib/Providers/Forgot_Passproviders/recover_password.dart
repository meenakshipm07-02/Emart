import 'package:flutter/foundation.dart';
import 'package:grocery_app/API/main_api.dart';

class RecoverPasswordProvider extends ChangeNotifier {
  final Main_Apis _api = Main_Apis();

  bool isLoading = false;
  String? message;
  String? errorMessage;

  Future<bool> sendForgotOtp(String email) async {
    isLoading = true;
    message = null;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await _api.forgotOtpFetch(email);

      if (response['status'] == 'success') {
        message = response['message'] ?? 'OTP sent successfully';
        return true;
      } else {
        errorMessage = response['message'] ?? 'Failed to send OTP';
        return false;
      }
    } catch (e) {
      errorMessage = e.toString().replaceAll('Exception: ', '').trim();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
