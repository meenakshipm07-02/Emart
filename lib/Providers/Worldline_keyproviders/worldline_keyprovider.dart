import 'package:flutter/material.dart';
import 'package:grocery_app/API/main_api.dart';
import 'package:grocery_app/Models/Merchant_keyModel/merchantkey_model.dart';

class WorldlineKeyProvider with ChangeNotifier {
  bool _isLoading = false;
  String _error = '';
  MerchantKeyResponse? _worldlinekey;
  String? _message;

  bool get isLoading => _isLoading;
  String get error => _error;
  MerchantKeyResponse? get worldlineKey => _worldlinekey;
  String? get message => _message;

  Future<void> fetchRazorpayKey() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final mainApis = Main_Apis();
      final response = await mainApis.getWorldlineKey();
      _worldlinekey = MerchantKeyResponse.fromJson(response);
      _message = 'Worldline key fetched successfully';
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearData() {
    _worldlinekey = null;
    _error = '';
    _message = null;
    notifyListeners();
  }
}
