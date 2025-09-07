class KeranjangModel {
  final int shopId;
  final String notes;
  final double total;
  final List<OrderItem> orderItems;

  KeranjangModel({
    required this.shopId,
    required this.notes,
    required this.total,
    required this.orderItems,
  });

  factory KeranjangModel.fromJson(Map<String, dynamic> json) {
    return KeranjangModel(
      shopId: json['shop_id'],
      notes: json['notes'],
      total: json['total'].toDouble(),
      orderItems: (json['order_items'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'shop_id': shopId,
      'notes': notes,
      'total': total,
      'order_items': orderItems.map((item) => item.toJson()).toList(),
    };
  }
}

class OrderItem {
  final int productId;
  final int quantity;
  final double price;

  OrderItem({
    required this.productId,
    required this.quantity,
    required this.price,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['product_id'],
      quantity: json['quantity'],
      price: json['price'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'quantity': quantity,
      'price': price,
    };
  }
}