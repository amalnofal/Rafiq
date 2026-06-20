class CartItemModel {
  final String id;
  final String productId;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final String productName;
  final String imageUrl;

  CartItemModel({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    required this.productName,
    required this.imageUrl,
  });

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      id: map['cartItemID']?.toString() ?? '',
      productId: map['productID']?.toString() ?? '',
      quantity: map['quantity'] ?? 1,
      unitPrice: (map['unitPrice'] ?? 0.0).toDouble(),
      totalPrice: (map['subtotal'] ?? 0.0).toDouble(),
      productName: map['productName'] ?? "منتج غير معروف",
      imageUrl: map['imageURL'] ?? "",
    );
  }
}

class CartModel {
  final String id;
  final String userId;
  final List<CartItemModel> items;
  final double totalAmount;

  CartModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
  });

  factory CartModel.fromMap(Map<String, dynamic> map) {
    final itemsList = map['items'] ?? map['cartItems'] ?? [];

    return CartModel(
      id: map['id']?.toString() ?? map['cartId']?.toString() ?? '',
      userId: map['userId']?.toString() ?? '',
      items: (itemsList as List)
          .map((e) => CartItemModel.fromMap(e as Map<String, dynamic>))
          .toList(),
      totalAmount: (map['totalAmount'] ?? map['totalPrice'] ?? 0.0).toDouble(),
    );
  }
}
