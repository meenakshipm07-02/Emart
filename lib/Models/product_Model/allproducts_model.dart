class Product {
  final String id;
  final String name;
  final String image;
  final String oldPrice;
  final String newPrice;
  final String stock;

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.oldPrice,
    required this.newPrice,
    required this.stock,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      oldPrice: json['old_price']?.toString() ?? '0',
      newPrice: json['new_price']?.toString() ?? '0',
      stock: json['stock']?.toString() ?? '0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'old_price': oldPrice,
      'new_price': newPrice,
      'stock': stock,
    };
  }

  // Helper to check if product has discount
  bool get hasDiscount {
    final old = double.tryParse(oldPrice) ?? 0;
    final newP = double.tryParse(newPrice) ?? 0;
    return old > newP;
  }

  // Calculate discount percentage
  double get discountPercentage {
    if (!hasDiscount) return 0;
    final old = double.tryParse(oldPrice) ?? 0;
    final newP = double.tryParse(newPrice) ?? 0;
    return ((old - newP) / old) * 100;
  }

  Product copyWith({
    String? id,
    String? name,
    String? image,
    String? oldPrice,
    String? newPrice,
    String? stock,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      oldPrice: oldPrice ?? this.oldPrice,
      newPrice: newPrice ?? this.newPrice,
      stock: stock ?? this.stock,
    );
  }

  @override
  String toString() {
    return 'Product(id: $id, name: $name, oldPrice: $oldPrice, newPrice: $newPrice, stock: $stock)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Product && other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }
}

class ProductResponse {
  final String status;
  final List<Product> products;

  ProductResponse({required this.status, required this.products});

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    final productsList = json['products'] as List<dynamic>?;

    return ProductResponse(
      status: json['status']?.toString() ?? '',
      products: productsList != null
          ? productsList.map((item) => Product.fromJson(item)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'products': products.map((product) => product.toJson()).toList(),
    };
  }
}
