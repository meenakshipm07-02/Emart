class RecentproductsModel {
  final int productId;
  final String name;
  final String description;
  final int price;
  final int stock;
  final String weight;
  final int categoryId;
  final String image;
  final bool isFavourite;

  RecentproductsModel({
    required this.productId,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.weight,
    required this.categoryId,
    required this.image,
    required this.isFavourite,
  });

  factory RecentproductsModel.fromJson(Map<String, dynamic> json) {
    return RecentproductsModel(
      productId: json['product_id'] is int
          ? json['product_id']
          : int.tryParse(json['product_id'].toString()) ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] is int
          ? json['price']
          : int.tryParse(json['price'].toString()) ?? 0,
      stock: json['stock'] is int
          ? json['stock']
          : int.tryParse(json['stock'].toString()) ?? 0,
      weight: json['weight'] ?? '',
      categoryId: json['category_id'] is int
          ? json['category_id']
          : int.tryParse(json['category_id'].toString()) ?? 0,
      image: json['image'] ?? '',
      isFavourite: json['is_favourite'] == true,
    );
  }
}
