class ProductModel {
  final String id;
  final String name;
  final double price;
  final String description;
  final int stockQuantity;
  final String imageUrl;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.stockQuantity,
    required this.imageUrl,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id:
          map['id']?.toString() ??
          map['productId']?.toString() ??
          map['productID']?.toString() ??
          '',
      name: map['productName'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      description: map['description'] ?? '',
      stockQuantity: map['stockQuantity'] ?? 0,
      imageUrl: map['imageUrl'] ?? map['imageURL'] ?? map['imageFile'] ?? '',
    );
  }
}
