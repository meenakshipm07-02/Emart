class ProductModel {
  final int id;
  final String name;
  final String description;
  final String image;
  final double price;
  final int stock;
  final bool isFavourite;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.stock,
    required this.isFavourite,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['product_id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      price: (json['price'] is int)
          ? (json['price'] as int).toDouble()
          : double.tryParse(json['price'].toString()) ?? 0.0,
      stock: int.tryParse(json['stock'].toString()) ?? 0,
      isFavourite: json['is_favourite'] ?? false,
    );
  }
}
