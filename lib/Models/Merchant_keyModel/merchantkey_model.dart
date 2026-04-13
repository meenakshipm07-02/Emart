class MerchantKeyResponse {
  final String status;
  final String key;

  MerchantKeyResponse({required this.status, required this.key});

  factory MerchantKeyResponse.fromJson(Map<String, dynamic> json) {
    return MerchantKeyResponse(
      status: json['status'] ?? '',
      key: json['key'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'key': key};
  }
}
