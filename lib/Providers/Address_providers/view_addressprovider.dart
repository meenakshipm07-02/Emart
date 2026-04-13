import 'package:flutter/material.dart';
import 'package:grocery_app/API/main_api.dart';
import 'package:grocery_app/Models/Addresses_Model/get_address_model.dart';

class ViewAddressProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  AddressResponse? _addressResponse;
  AddressResponse? get addressResponse => _addressResponse;

  final Main_Apis _api = Main_Apis();

  Future<void> fetchAddresses() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _api.viewaddress();
      _addressResponse = AddressResponse.fromJson(response);
    } catch (e) {
      _errorMessage = e.toString();
      _addressResponse = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearData() {
    _addressResponse = null;
    _errorMessage = null;
    notifyListeners();
  }
}
