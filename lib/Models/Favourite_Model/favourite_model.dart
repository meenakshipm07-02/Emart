class Favourite {
  final int favouriteId;
  final int productId;
  final String name;
  final double price;
  final String image;
  final bool isFavourite;
  final String? weight; // nullable

  Favourite({
    required this.favouriteId,
    required this.productId,
    required this.name,
    required this.price,
    required this.image,
    required this.isFavourite,
    this.weight,
  });

  factory Favourite.fromJson(Map<String, dynamic> json) {
    return Favourite(
      favouriteId: json['favourite_id'] ?? 0,
      productId: json['product_id'] ?? 0,
      name: json['name'] ?? '',
      price: (json['price'] is int)
          ? (json['price'] as int).toDouble()
          : double.tryParse(json['price'].toString()) ?? 0.0,
      image: json['image'] ?? '', // empty string if null
      isFavourite: json['is_favourite'] == true,
      weight: json['weight'], // nullable
    );
  }
}
