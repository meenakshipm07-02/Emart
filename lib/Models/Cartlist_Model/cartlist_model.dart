// Models/Cartlist_Model/cartlist_model.dart

class CartItem {
  final int cartId;
  final int productId;
  final String name;
  final double price; // Already fixed
  final int quantity;
  final double subtotal; // Already fixed
  final String? weight;
  final String image;

  CartItem({
    required this.cartId,
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.subtotal,
    this.weight,
    required this.image,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      cartId: json['cart_id'] ?? 0,
      productId: json['product_id'] ?? 0,
      name: json['name'] ?? '',
      price: (json['price'] is num ? json['price'].toDouble() : 0.0),
      quantity: json['quantity'] ?? 1,
      subtotal: (json['subtotal'] is num ? json['subtotal'].toDouble() : 0.0),
      weight: json['weight'],
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cart_id': cartId,
      'product_id': productId,
      'name': name,
      'price': price,
      'quantity': quantity,
      'subtotal': subtotal,
      'weight': weight,
      'image': image,
    };
  }
}

class CartResponse {
  final String status;
  final int orderId;
  final List<CartItem> cart;
  final double total; // CHANGED: int → double

  CartResponse({
    required this.status,
    required this.orderId,
    required this.cart,
    required this.total, // Now double
  });

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    return CartResponse(
      status: json['status'] ?? '',
      orderId: json['order_id'] ?? 0,
      cart: json['cart'] != null
          ? List<CartItem>.from(
              json['cart'].map((item) => CartItem.fromJson(item)),
            )
          : [],
      total: (json['total'] is num
          ? json['total'].toDouble()
          : 0.0), // Safe conversion
    );
  }
}
