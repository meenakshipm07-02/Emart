class AddressResponse {
  final String status;
  final String userId;
  final int totalAddresses;
  final List<Address> addresses;

  AddressResponse({
    required this.status,
    required this.userId,
    required this.totalAddresses,
    required this.addresses,
  });

  factory AddressResponse.fromJson(Map<String, dynamic> json) {
    return AddressResponse(
      status: json['status'] ?? '',
      userId: json['user_id'] ?? '',
      totalAddresses: json['total_addresses'] ?? 0,
      addresses:
          (json['addresses'] as List<dynamic>?)
              ?.map((e) => Address.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'user_id': userId,
      'total_addresses': totalAddresses,
      'addresses': addresses.map((e) => e.toJson()).toList(),
    };
  }
}

class Address {
  final int addressid;
  final String address;
  final String addressType;
  final String pincode;
  final String createdAt;

  Address({
    required this.addressid,
    required this.address,
    required this.addressType,
    required this.pincode,
    required this.createdAt,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      addressid: json['address_id'] ?? 0,
      address: json['address'] ?? '',
      addressType: json['address_type'] ?? '',
      pincode: json['pincode'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address_id': addressid,
      'address': address,
      'address_type': addressType,
      'pincode': pincode,
      'created_at': createdAt,
    };
  }
}
