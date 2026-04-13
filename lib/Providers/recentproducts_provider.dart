import 'package:flutter/foundation.dart';
import 'package:grocery_app/API/main_api.dart';
import 'package:grocery_app/Models/Recentproducts_Model/recentproducts_model.dart';

class RecentProductsProvider with ChangeNotifier {
  final Main_Apis _api = Main_Apis();

  List<RecentproductsModel> _recentProducts = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<RecentproductsModel> get recentProducts => _recentProducts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchRecentProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _api.viewrecent_products();

      if (response['status'] == 'success' && response['products'] != null) {
        final List<dynamic> productsJson = response['products'];
        _recentProducts = productsJson
            .map((json) => RecentproductsModel.fromJson(json))
            .toList();
      } else {
        _errorMessage = 'Unexpected response format';
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
