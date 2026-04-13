import 'package:flutter/material.dart';
import 'package:grocery_app/API/main_api.dart';
import 'package:grocery_app/Models/BuynowModel/buynowresponse_model.dart';

class BuyNowProvider extends ChangeNotifier {
  final Main_Apis _apis = Main_Apis();

  BuyNowResponse? _buyNowResponse;
  bool _isLoading = false;
  String? _errorMessage;

  BuyNowResponse? get buyNowResponse => _buyNowResponse;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  void reset() {
    _buyNowResponse = null;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> buyNow(String productId, int quantity) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apis.Buynow(productId, quantity);

      final buyNowResponse = BuyNowResponse.fromJson(response);

      _buyNowResponse = buyNowResponse;

      if (!buyNowResponse.isSuccess) {
        _errorMessage = 'Failed to process order';
      }
    } catch (e) {
      _errorMessage = e.toString();
      _buyNowResponse = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool get isOrderSuccessful {
    return _buyNowResponse?.isSuccess ?? false;
  }

  String? get merchantKey {
    return _buyNowResponse?.merchantKey;
  }

  int? get orderId {
    return _buyNowResponse?.orderId;
  }
}
