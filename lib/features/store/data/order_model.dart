class OrderItemModel {
  final String productId;
  final String productName;
  final String imageUrl;
  final double unitPrice;
  final int quantity;
  final double subtotal;

  OrderItemModel({
    required this.productId,
    required this.productName,
    required this.imageUrl,
    required this.unitPrice,
    required this.quantity,
    required this.subtotal,
  });

  factory OrderItemModel.fromMap(Map<String, dynamic> map) {
    return OrderItemModel(
      productId: map['productID']?.toString() ?? '',
      productName: map['productName'] ?? '',
      imageUrl: map['imageURL'] ?? '',
      unitPrice: (map['unitPrice'] ?? 0.0).toDouble(),
      quantity: map['quantity'] ?? 1,
      subtotal: (map['subtotal'] ?? 0.0).toDouble(),
    );
  }
}

class OrderModel {
  final String orderId;
  final int status; // Pending=0, Accepted=1
  final double totalAmount;
  final String orderDate;
  final String? userName;
  final String? phoneNumber;
  final String shippingAddress;
  final List<OrderItemModel> items;

  OrderModel({
    required this.orderId,
    required this.status,
    required this.totalAmount,
    required this.orderDate,
    this.userName,
    this.phoneNumber,
    required this.shippingAddress,
    required this.items,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    final itemsList = map['items'] ?? [];

    return OrderModel(
      orderId: map['orderID']?.toString() ?? '',
      status: map['status'] ?? 0,
      totalAmount: (map['totalAmount'] ?? 0.0).toDouble(),
      orderDate: map['orderDate'] ?? '',
      userName: map['userName']?.toString(),
      shippingAddress: map['shippingAddress'] ?? '',
      phoneNumber: map['phoneNumber']?.toString(),
      items: (itemsList as List)
          .map((e) => OrderItemModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
