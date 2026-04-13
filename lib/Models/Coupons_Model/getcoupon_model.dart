class CouponResponse {
  final String status;
  final String userId;
  final int totalCoupons;
  final List<Coupon> coupons;

  CouponResponse({
    required this.status,
    required this.userId,
    required this.totalCoupons,
    required this.coupons,
  });

  factory CouponResponse.fromJson(Map<String, dynamic> json) {
    return CouponResponse(
      status: json['status'] as String,
      userId: json['user_id']?.toString() ?? '',
      totalCoupons: (json['total_coupons'] as num?)?.toInt() ?? 0,
      coupons:
          (json['coupons'] as List<dynamic>?)
              ?.map((couponJson) => Coupon.fromJson(couponJson))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'user_id': userId,
      'total_coupons': totalCoupons,
      'coupons': coupons.map((coupon) => coupon.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'CouponResponse(status: $status, userId: $userId, totalCoupons: $totalCoupons, coupons: $coupons)';
  }
}

class Coupon {
  final int id;
  final String code;
  final String discountType;
  final double discountValue;
  final String expiryDate;
  final String createdAt;

  Coupon({
    required this.id,
    required this.code,
    required this.discountType,
    required this.discountValue,
    required this.expiryDate,
    required this.createdAt,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      id: (json['id'] as num?)?.toInt() ?? 0,
      code: json['code'] as String? ?? '',
      discountType: json['discount_type'] as String? ?? '',
      discountValue: (json['discount_value'] as num?)?.toDouble() ?? 0.0,
      expiryDate: json['expiry_date'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'discount_type': discountType,
      'discount_value': discountValue,
      'expiry_date': expiryDate,
      'created_at': createdAt,
    };
  }

  bool get isExpired {
    if (expiryDate.isEmpty) return false;
    try {
      final expiry = DateTime.parse(expiryDate);
      final now = DateTime.now();
      return expiry.isBefore(now);
    } catch (e) {
      return false;
    }
  }

  double calculateDiscount(double originalPrice) {
    if (discountType == 'percent') {
      return originalPrice * discountValue;
    } else if (discountType == 'fixed') {
      return discountValue;
    }
    return 0;
  }

  String get discountDescription {
    if (discountType == 'percent') {
      return '${(discountValue * 100).toStringAsFixed(1)}% off';
    } else if (discountType == 'fixed') {
      return '\$${discountValue.toStringAsFixed(2)} off';
    }
    return '';
  }

  @override
  String toString() {
    return 'Coupon(id: $id, code: $code, discountType: $discountType, discountValue: $discountValue, expiryDate: $expiryDate)';
  }
}
