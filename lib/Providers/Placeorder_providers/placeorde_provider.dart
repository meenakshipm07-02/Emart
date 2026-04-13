import 'package:flutter/foundation.dart';
import 'package:grocery_app/API/main_api.dart';

class PlaceOrderProvider extends ChangeNotifier {
  final Main_Apis _api = Main_Apis();

  bool _isLoading = false;
  String? _message;
  bool _isError = false;
  Map<String, dynamic>? _orderData;

  // Getters
  bool get isLoading => _isLoading;
  String? get message => _message;
  bool get isError => _isError;
  Map<String, dynamic>? get orderData => _orderData;

  String? get transactionId => _orderData?['txn_id']?.toString();
  String? get orderStatus => _orderData?['order_status']?.toString();
  num? get orderAmount {
    if (_orderData?['amount'] == null) return null;
    final amount = _orderData!['amount'];
    return amount is num ? amount : num.tryParse(amount.toString());
  }

  String? get customerEmail {
    if (_orderData?['customer'] is Map<String, dynamic>) {
      return _orderData!['customer']['email']?.toString();
    }
    return null;
  }

  String? get customerPhone {
    if (_orderData?['customer'] is Map<String, dynamic>) {
      return _orderData!['customer']['phone']?.toString();
    }
    return null;
  }

  Map<String, dynamic>? get paymentPayload {
    if (_orderData?['payment_payload'] is Map<String, dynamic>) {
      return Map<String, dynamic>.from(_orderData!['payment_payload']);
    }
    return null;
  }

  Future<void> placeOrder({
    required int orderId,
    required num amount,
    required String address,
    required String paymentMethod,
  }) async {
    try {
      _isLoading = true;
      _isError = false;
      _message = null;
      _orderData = null;
      notifyListeners();

      // Call the API with positional parameters (matching your API class)
      final response = await _api.Placeorder(
        orderId, // orderid
        amount, // amount
        address, // address
        paymentMethod, // paymentmethod
      );

      // Store the response
      _orderData = Map<String, dynamic>.from(response);

      // Check if response has status field
      if (response.containsKey('status')) {
        final status = response['status']?.toString().toLowerCase();

        if (status == 'success') {
          _message =
              response['message']?.toString() ?? 'Order placed successfully';
          _isError = false;

          // Log success for debugging
          print('Order placed successfully. Txn ID: ${transactionId}');
          print('Payment payload: ${paymentPayload}');
        } else {
          _message = response['message']?.toString() ?? 'Failed to place order';
          _isError = true;
        }
      } else {
        _message = 'Invalid response from server';
        _isError = true;
      }
    } catch (e) {
      // Handle error messages (your API throws strings, not Exceptions)
      _message = e.toString();
      _isError = true;
      _orderData = null;

      // Log error for debugging
      print('Place order error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear all state
  void clearState() {
    _isLoading = false;
    _message = null;
    _isError = false;
    _orderData = null;
    notifyListeners();
  }

  // Reset only error state (useful for retry)
  void resetError() {
    _isError = false;
    _message = null;
    notifyListeners();
  }

  // Check if order was successful
  bool get isOrderSuccessful {
    if (_orderData == null) return false;
    final status = _orderData!['status']?.toString().toLowerCase();
    return status == 'success';
  }

  // Get hash for payment redirection
  String? get paymentHash => paymentPayload?['hash']?.toString();

  // Get data array for payment redirection
  List<dynamic>? get paymentData {
    if (paymentPayload?['data'] is List) {
      return List<dynamic>.from(paymentPayload!['data']);
    }
    return null;
  }
}
