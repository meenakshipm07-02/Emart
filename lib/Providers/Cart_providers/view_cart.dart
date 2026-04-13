// Providers/Cart_providers/view_cart.dart

import 'package:flutter/material.dart';
import 'package:grocery_app/API/main_api.dart';
import 'package:grocery_app/Models/Cartlist_Model/cartlist_model.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> _cartItems = [];
  double _total = 0.0; // CHANGED: int → double
  int _orderId = 0;
  bool _isLoading = false;
  String _error = '';

  List<CartItem> get cartItems => _cartItems;
  double get total => _total; // CHANGED: int → double
  int get orderId => _orderId;
  bool get isLoading => _isLoading;
  String get error => _error;

  final Main_Apis api = Main_Apis();

  Future<void> fetchCart() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final response = await api.viewcart();
      final cartResponse = CartResponse.fromJson(response);

      _cartItems = cartResponse.cart;
      _total = cartResponse.total; // Now compatible (double = double)
      _orderId = cartResponse.orderId;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
