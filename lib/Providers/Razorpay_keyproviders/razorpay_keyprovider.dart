import 'package:flutter/material.dart';
import 'package:grocery_app/API/main_api.dart';
import 'package:grocery_app/Models/Merchant_keyModel/merchantkey_model.dart';

class RazorpayKeyProvider with ChangeNotifier {
  bool _isLoading = false;
  String _error = '';
  MerchantKeyResponse? _razorpayKey;
  String? _message;

  bool get isLoading => _isLoading;
  String get error => _error;
  MerchantKeyResponse? get razorpayKey => _razorpayKey;
  String? get message => _message;

  Future<void> fetchRazorpayKey() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final mainApis = Main_Apis();
      final response = await mainApis.getRazorpayKey();
      _razorpayKey = MerchantKeyResponse.fromJson(response);
      _message = 'Razorpay key fetched successfully';
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearData() {
    _razorpayKey = null;
    _error = '';
    _message = null;
    notifyListeners();
  }
}
