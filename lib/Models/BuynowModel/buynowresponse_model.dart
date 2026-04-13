class BuyNowResponse {
  final String status;
  final int orderId;
  final String merchantKey;

  BuyNowResponse({
    required this.status,
    required this.orderId,
    required this.merchantKey,
  });

  factory BuyNowResponse.fromJson(Map<String, dynamic> json) {
    return BuyNowResponse(
      status: json['status'] as String,
      orderId: json['order_id'] as int,
      merchantKey: json['merchant_key'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'order_id': orderId, 'merchant_key': merchantKey};
  }

  bool get isSuccess => status == 'success';
}
