class ProductDetailModel {
  final String id;
  final String name;
  final String price;
  final String oldPrice;
  final String stock;
  final String category;
  final String weight;
  final String description;
  final String careInstruction;
  final String returnPolicy;
  final String packageInfo;
  final String manufacturer;
  final String itemPartNumber;
  final List<String> images;

  ProductDetailModel({
    required this.id,
    required this.name,
    required this.price,
    required this.oldPrice,
    required this.stock,
    required this.category,
    required this.weight,
    required this.description,
    required this.careInstruction,
    required this.returnPolicy,
    required this.packageInfo,
    required this.manufacturer,
    required this.itemPartNumber,
    required this.images,
  });

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    List<String> imagesList = [];
    if (json['images'] != null && json['images'] is List) {
      imagesList = List<String>.from(json['images']);
    }

    return ProductDetailModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      price: json['price'] ?? '',
      oldPrice: json['old_price'] ?? '',
      stock: json['stock'] ?? '',
      category: json['category'] ?? '',
      weight: json['weight'] ?? '',
      description: json['description'] ?? '',
      careInstruction: json['care_instruction'] ?? '',
      returnPolicy: json['return_policy'] ?? '',
      packageInfo: json['package_info'] ?? '',
      manufacturer: json['manufacturer'] ?? '',
      itemPartNumber: json['item_partnumber'] ?? '',
      images: imagesList,
    );
  }
}
