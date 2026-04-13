import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/Common_Widgets/Screen_Colors/screen_colors.dart';
import 'package:grocery_app/Common_Widgets/Screen_Resolution/screen_res.dart';
import 'package:grocery_app/Providers/Placeorder_providers/placeorde_provider.dart';
import 'package:grocery_app/Screens/Home_Screen/Cart_Screen/bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:grocery_app/Providers/Address_providers/view_addressprovider.dart';
import 'package:grocery_app/Common_Widgets/Circular_progressindicator/progress_indicator.dart';
import 'package:weipl_checkout_flutter/weipl_checkout_flutter.dart';
import 'dart:io' show Platform;

class Placeorder extends StatefulWidget {
  final num amount;
  final String? userName;
  final int orderid;
  final String? merchantKey;
  final String? userEmail;
  final String? userPhone;
  final String? userId;

  const Placeorder({
    super.key,
    required this.amount,
    this.userName,
    required this.orderid,
    this.merchantKey,
    this.userEmail,
    this.userPhone,
    this.userId,
  });

  @override
  State<Placeorder> createState() => _PlaceorderState();
}

class _PlaceorderState extends State<Placeorder> {
  WeiplCheckoutFlutter wlCheckoutFlutter = WeiplCheckoutFlutter();
  dynamic _selectedAddress;
  String? _selectedPaymentMethod;
  bool _showPaymentOptions = false;
  bool _isProcessingPayment = false;

  @override
  void initState() {
    super.initState();
    wlCheckoutFlutter.on(
      WeiplCheckoutFlutter.wlResponse,
      _handlePaymentResponse,
      _handlePaymentError,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ViewAddressProvider>(context, listen: false).fetchAddresses();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _showAddAddressBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return AddAddressBottomSheet(
          onAddressAdded: () {
            Provider.of<ViewAddressProvider>(
              context,
              listen: false,
            ).fetchAddresses();
          },
        );
      },
    );
  }

  Future<void> _openPaynimoPayment(Map<String, dynamic> paymentPayload) async {
    try {
      setState(() {
        _isProcessingPayment = true;
      });

      final List<dynamic> rawData = List.from(paymentPayload['data'] ?? []);
      final List<String> data = rawData.map((e) => e.toString()).toList();

      debugPrint("=== PAYNIMO PAYLOAD ===");
      debugPrint("Hash: ${paymentPayload['hash']}");
      for (int i = 0; i < data.length; i++) {
        debugPrint(
          "data[$i]: '${data[i]}' (Original: ${rawData[i]}, Type: ${rawData[i].runtimeType})",
        );
      }

      final Map<String, dynamic> consumerData = {
        "deviceId": Platform.isAndroid ? "AndroidSH2" : "iOSSH2",
        "token": paymentPayload['hash'].toString(), // MUST BE EXACT HASH
        "paymentMode": "all",
        "merchantLogoUrl":
            "https://www.paynimo.com/CompanyDocs/company-logo-vertical.png",
        "merchantId": data[0], // T206030
        "currency": data[15], // INR
        "consumerId": data[8], // user_id as string
        "consumerMobileNo": data[9], // phone
        "consumerEmailId": data[10], // email
        "txnId": data[1], // TXN ID
        "responseUrl": data[12], // callback URL - CRITICAL!
        "items": [
          {
            "itemId": "order_${widget.orderid}",
            "amount": data[2], // Amount as string
            "comAmt": "0",
          },
        ],
        "customStyle": {
          "PRIMARY_COLOR_CODE": "#45beaa",
          "SECONDARY_COLOR_CODE": "#FFFFFF",
          "BUTTON_COLOR_CODE_1": "#2d8c8c",
          "BUTTON_COLOR_CODE_2": "#FFFFFF",
        },
      };

      final Map<String, dynamic> reqJson = {
        "features": {
          "enableAbortResponse": true,
          "enableExpressPay": true,
          "enableInstrumentDeRegistration": true,
          "enableMerTxnDetails": true,
        },
        "consumerData": consumerData,
      };

      debugPrint("=== SENDING TO PAYNIMO ===");
      debugPrint(jsonEncode(reqJson));

      // Open Paynimo
      wlCheckoutFlutter.open(reqJson);
    } catch (e, stackTrace) {
      debugPrint("Paynimo Error: $e");
      debugPrint("Stack Trace: $stackTrace");

      setState(() {
        _isProcessingPayment = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Payment initialization failed: ${e.toString()}"),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _handlePaymentResponse(Map<dynamic, dynamic> response) {
    debugPrint("Paynimo Response: $response");

    setState(() {
      _isProcessingPayment = false;
    });

    if (response['status'] == 'success' || response['status'] == 'Success') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "✅ Payment Successful!\nTransaction ID: ${response['txnId'] ?? response['txn_id'] ?? 'N/A'}",
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );

      _showOrderSuccessDialog(
        txnId: response['txnId']?.toString() ?? response['txn_id']?.toString(),
        orderId: widget.orderid,
        amount: widget.amount,
        paymentMethod: "Online Payment",
      );
    } else if (response['status'] == 'failure' ||
        response['status'] == 'failed') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "❌ Payment Failed: ${response['message'] ?? 'Transaction declined'}",
          ),
          backgroundColor: AppColors.error,
          duration: Duration(seconds: 3),
        ),
      );
    } else if (response['status'] == 'cancelled' ||
        response['status'] == 'cancel') {
      // Payment cancelled
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("⏸️ Payment Cancelled by user"),
          backgroundColor: Colors.orange,
        ),
      );
    } else {
      // Other status
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Payment Status: ${response['status'] ?? 'Unknown'}"),
          backgroundColor: Colors.grey,
        ),
      );
    }
  }

  void _handlePaymentError(Map<dynamic, dynamic> response) {
    debugPrint("Paynimo Error Response: $response");
    setState(() {
      _isProcessingPayment = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Payment Error: ${response['message'] ?? 'Unknown error'}",
        ),
        backgroundColor: AppColors.error,
      ),
    );
  }

  void _showOrderSuccessDialog({
    String? txnId,
    int? orderId,
    required num amount,
    String? paymentMethod,
    String? orderStatus,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 30),
            SizedBox(width: 10),
            Text(
              "Order Placed!",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "✅ ${paymentMethod == "Cash on Delivery" ? "Order Confirmed!" : "Payment Successful!"}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            if (paymentMethod == "Cash on Delivery")
              Text(
                "You have selected Cash on Delivery. Please pay ₹$amount when your order is delivered.",
              )
            else
              Text("Your order has been confirmed and payment is completed."),
            SizedBox(height: 15),
            if (orderId != null) Text("📦 Order ID: $orderId"),
            if (txnId != null) Text("💳 Transaction ID: $txnId"),
            Text("💰 Amount: ₹$amount"),
            if (paymentMethod != null)
              Text("💵 Payment Method: $paymentMethod"),
            if (orderStatus != null)
              Text("📊 Order Status: ${orderStatus.toUpperCase()}"),
            SizedBox(height: 15),
            if (paymentMethod == "Cash on Delivery")
              Text(
                "Our delivery executive will contact you at ${widget.userPhone ?? 'your registered phone'} for delivery.",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              )
            else
              Text(
                "Payment confirmation has been automatically sent to our server.",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: Text("Go to Home"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: Text("Continue Shopping"),
          ),
        ],
      ),
    );
  }

  void _handleProceedToPay() {
    if (_selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 1),
          content: Center(child: Text("Please select an address")),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    setState(() {
      _showPaymentOptions = true;
    });
  }

  Future<void> _placeOrder() async {
    if (_selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 1),
          content: Center(child: Text("Please select a payment method")),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_selectedPaymentMethod == 'online') {
      try {
        setState(() {
          _isProcessingPayment = true;
        });

        final placeOrderProvider = Provider.of<PlaceOrderProvider>(
          context,
          listen: false,
        );

        await placeOrderProvider.placeOrder(
          orderId: widget.orderid,
          amount: widget.amount,
          address: _selectedAddress.address ?? "Unknown Address",
          paymentMethod: "Online Payment",
        );

        if (placeOrderProvider.isError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                placeOrderProvider.message ?? "Failed to place order",
              ),
              backgroundColor: AppColors.error,
            ),
          );
          setState(() {
            _isProcessingPayment = false;
          });
          return;
        }

        if (placeOrderProvider.orderData?['status'] == 'success' &&
            placeOrderProvider.orderData?['payment_payload'] != null) {
          final paymentPayload =
              placeOrderProvider.orderData!['payment_payload']
                  as Map<String, dynamic>;

          await _openPaynimoPayment(paymentPayload);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Failed to get payment details"),
              backgroundColor: AppColors.error,
            ),
          );
          setState(() {
            _isProcessingPayment = false;
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: $e"),
            backgroundColor: AppColors.error,
          ),
        );
        setState(() {
          _isProcessingPayment = false;
        });
      }
    } else if (_selectedPaymentMethod == 'cod') {
      try {
        setState(() {
          _isProcessingPayment = true;
        });

        final placeOrderProvider = Provider.of<PlaceOrderProvider>(
          context,
          listen: false,
        );

        await placeOrderProvider.placeOrder(
          orderId: widget.orderid,
          amount: widget.amount,
          address: _selectedAddress.address ?? "Unknown Address",
          paymentMethod: "Cash on Delivery",
        );

        if (placeOrderProvider.isError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                placeOrderProvider.message ?? "Failed to place order",
              ),
              backgroundColor: AppColors.error,
            ),
          );
        } else {
          final orderData = placeOrderProvider.orderData;
          if (orderData?['status'] == 'success') {
            final orderId = orderData?['order_id'];
            final orderStatus = orderData?['order_status']?.toString();

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: Duration(seconds: 3),
                content: Text(
                  "✅ Order Placed Successfully!\nCash on Delivery selected.",
                ),
                backgroundColor: AppColors.primary,
              ),
            );

            _showOrderSuccessDialog(
              orderId: orderId,
              amount: widget.amount,
              paymentMethod: "Cash on Delivery",
              orderStatus: orderStatus ?? "received",
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  orderData?['message'] ?? "Failed to place COD order",
                ),
                backgroundColor: AppColors.error,
              ),
            );
          }
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: $e"),
            backgroundColor: AppColors.error,
          ),
        );
      } finally {
        setState(() {
          _isProcessingPayment = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get addresses from provider
    final viewAddressProvider = Provider.of<ViewAddressProvider>(context);
    final addresses = viewAddressProvider.addressResponse?.addresses ?? [];

    // Get place order provider
    final placeOrderProvider = Provider.of<PlaceOrderProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0.5,
        toolbarHeight: SizeConfig.blockHeight * 8,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Payment Screen",
          style: GoogleFonts.poppins(
            color: AppColors.secondary,
            fontSize: SizeConfig.blockHeight * 1.9,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: SizeConfig.blockHeight * 1),
                Container(
                  width: 130,
                  padding: EdgeInsets.all(SizeConfig.blockHeight * 1),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Order ID :',
                        style: GoogleFonts.poppins(
                          color: AppColors.black,
                          fontSize: SizeConfig.blockHeight * 1.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: SizeConfig.blockHeight * 0.5),
                      Expanded(
                        child: Text(
                          '${widget.orderid ?? 'N/A'}',
                          style: GoogleFonts.poppins(
                            color: AppColors.secondary,
                            fontSize: SizeConfig.blockHeight * 1.4,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: SizeConfig.blockHeight * 0.5),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Select Delivery Address",
                      style: GoogleFonts.poppins(
                        fontSize: SizeConfig.blockHeight * 1.8,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _showAddAddressBottomSheet,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: Icon(
                        Icons.add,
                        size: SizeConfig.blockHeight * 1.8,
                        color: Colors.white,
                      ),
                      label: Text(
                        "Add",
                        style: GoogleFonts.poppins(
                          fontSize: SizeConfig.blockHeight * 1.5,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: SizeConfig.blockHeight * 2.5),

                Container(
                  height: SizeConfig.blockHeight * 24,
                  child: viewAddressProvider.isLoading
                      ? Center(child: CustomLoader())
                      : viewAddressProvider.errorMessage != null
                      ? Center(
                          child: Text(
                            "Error: ${viewAddressProvider.errorMessage}",
                            style: const TextStyle(color: Colors.red),
                          ),
                        )
                      : addresses.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: SizeConfig.blockHeight * 6,
                                color: Colors.grey,
                              ),
                              SizedBox(height: SizeConfig.blockHeight * 1),
                              Text(
                                "No addresses found",
                                style: GoogleFonts.poppins(
                                  fontSize: SizeConfig.blockHeight * 1.6,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Scrollbar(
                          thumbVisibility: false,
                          radius: const Radius.circular(10),
                          child: ListView.builder(
                            itemCount: addresses.length,
                            itemBuilder: (context, index) {
                              final address = addresses[index];
                              return Card(
                                elevation: 2,
                                shadowColor: Colors.black.withOpacity(0.5),
                                color: AppColors.white,
                                margin: EdgeInsets.only(
                                  bottom: SizeConfig.blockHeight * 1.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(
                                    color: Colors.grey.withOpacity(0.15),
                                  ),
                                ),
                                child: RadioListTile<dynamic>(
                                  value: address,
                                  groupValue: _selectedAddress,
                                  activeColor: const Color.fromARGB(
                                    255,
                                    5,
                                    143,
                                    47,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedAddress = value;
                                    });
                                  },
                                  title: Text(
                                    "${address.addressType}",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: SizeConfig.blockHeight * 1.7,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "${address.address}\n${address.pincode}",
                                    style: GoogleFonts.poppins(
                                      fontSize: SizeConfig.blockHeight * 1.5,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ),

                Divider(endIndent: 1, indent: 1),
                SizedBox(height: SizeConfig.blockHeight * 1),

                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Amount:",
                        style: GoogleFonts.poppins(
                          fontSize: SizeConfig.blockHeight * 1.8,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "₹${widget.amount}",
                        style: GoogleFonts.poppins(
                          fontSize: SizeConfig.blockHeight * 2.0,
                          fontWeight: FontWeight.w700,
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: SizeConfig.blockHeight * 1),
                Divider(endIndent: 1, indent: 1),
                SizedBox(height: SizeConfig.blockHeight * .2),

                if (!_showPaymentOptions)
                  SizedBox(
                    width: double.infinity,
                    height: SizeConfig.blockHeight * 5.6,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 5, 143, 47),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: _handleProceedToPay,
                      child: Text(
                        "Proceed to Pay",
                        style: GoogleFonts.poppins(
                          fontSize: SizeConfig.blockHeight * 1.8,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                if (_showPaymentOptions) ...[
                  SizedBox(height: SizeConfig.blockHeight * 1),
                  Text(
                    "Select Payment Method",
                    style: GoogleFonts.poppins(
                      fontSize: SizeConfig.blockHeight * 1.8,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: SizeConfig.blockHeight * 1),

                  Card(
                    color: AppColors.white,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: _selectedPaymentMethod == 'online'
                            ? AppColors.primary
                            : Colors.white,
                        width: _selectedPaymentMethod == 'online' ? 2 : 1,
                      ),
                    ),
                    child: RadioListTile<String>(
                      value: 'online',
                      groupValue: _selectedPaymentMethod,
                      onChanged: (value) {
                        setState(() {
                          _selectedPaymentMethod = value;
                        });
                      },
                      activeColor: AppColors.primary,
                      title: Row(
                        children: [
                          Icon(
                            Icons.credit_card,
                            color: AppColors.secondary,
                            size: SizeConfig.blockHeight * 2.2,
                          ),
                          SizedBox(width: SizeConfig.blockHeight * 1),
                          Text(
                            "Pay Online",
                            style: GoogleFonts.poppins(
                              fontSize: SizeConfig.blockHeight * 1.7,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Text(
                        "Secure online payment via Paynimo",
                        style: GoogleFonts.poppins(
                          fontSize: SizeConfig.blockHeight * 1.4,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: SizeConfig.blockHeight * 1.5),

                  Card(
                    color: AppColors.white,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: _selectedPaymentMethod == 'cod'
                            ? AppColors.primary
                            : Colors.white,
                        width: _selectedPaymentMethod == 'cod' ? 2 : 1,
                      ),
                    ),
                    child: RadioListTile<String>(
                      value: 'cod',
                      groupValue: _selectedPaymentMethod,
                      onChanged: (value) {
                        setState(() {
                          _selectedPaymentMethod = value;
                        });
                      },
                      activeColor: AppColors.primary,
                      title: Row(
                        children: [
                          Icon(
                            Icons.money,
                            color: AppColors.secondary,
                            size: SizeConfig.blockHeight * 2.2,
                          ),
                          SizedBox(width: SizeConfig.blockHeight * 1),
                          Text(
                            "Cash on Delivery",
                            style: GoogleFonts.poppins(
                              fontSize: SizeConfig.blockHeight * 1.7,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Text(
                        "Pay when your order is delivered",
                        style: GoogleFonts.poppins(
                          fontSize: SizeConfig.blockHeight * 1.4,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: SizeConfig.blockHeight * 3),

                  SizedBox(
                    width: double.infinity,
                    height: SizeConfig.blockHeight * 5.6,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 5, 143, 47),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: _isProcessingPayment ? null : _placeOrder,
                      child: _isProcessingPayment
                          ? CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            )
                          : Text(
                              "Place Order",
                              style: GoogleFonts.poppins(
                                fontSize: SizeConfig.blockHeight * 1.8,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Show loading overlay when processing
          if (_isProcessingPayment || placeOrderProvider.isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: 3,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
