class KeranjangModel {
  final int id;
  final int userId;
  final int shopId;
  final String status;
  final String notes;
  final double total;
  final String createdAt;
  final String updatedAt;
  final double amountPaid;
  final String discount;
  final String paymentMethod;
  final double changeMoney;
  final double tax;
  final List<OrderItem> orderItems;

  KeranjangModel(
    this.paymentMethod,
    this.changeMoney,
    this.tax, {
    required this.id,
    required this.userId,
    required this.shopId,
    required this.status,
    required this.notes,
    required this.total,
    required this.amountPaid,
    this.discount = '0%',
    required this.createdAt,
    required this.updatedAt,
    required this.orderItems,
  });
  factory KeranjangModel.fromJson(Map<String, dynamic> json) {
    return KeranjangModel(
      json['payment_method'] ?? '',
      json['change_money'] != null ? double.parse(json['change_money'].toString()) : 0.0,
      json['tax'] != null ? double.parse(json['tax'].toString()) : 0.0,
      id: int.parse(json['id'].toString()),
      userId: int.parse(json['user_id'].toString()),
      shopId: int.parse(json['shop_id'].toString()),
      status: json['status'],
      notes: json['notes'],
      total: double.parse(json['total'].toString()),
      amountPaid: json['amount_paid'] != null
          ? double.parse(json['amount_paid'].toString())
          : 0.0,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      orderItems: json['order_items'] != null
          ? (json['order_items'] as List)
              .map((item) => OrderItem.fromJson(item))
              .toList()
          : [],
      discount: json['discount'] ?? '0%',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'shop_id': shopId,
      'status': status,
      'notes': notes,
      'total': total,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'amount_paid': amountPaid,
      'payment_method': paymentMethod,
      'change_money': changeMoney,
      'tax': tax,
      'discount': discount,
      'order_items': orderItems.map((item) => item.toJson()).toList(),
    };
  } 
}

class OrderItem {
  final int? id;
  final int? orderId;
  final int productId;
  final int quantity;
  final double price;
  final String? createdAt;
  final String? updatedAt;

  OrderItem({
    this.id,
    this.orderId,
    required this.productId,
    required this.quantity,
    required this.price,
    this.createdAt,
    this.updatedAt,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] != null ? int.parse(json['id'].toString()) : null,
      orderId: json['order_id'] != null
          ? int.parse(json['order_id'].toString())
          : null,
      productId: int.parse(json['product_id'].toString()),
      quantity: int.parse(json['quantity'].toString()),
      price: double.parse(json['price'].toString()),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'product_id': productId,
      'quantity': quantity,
      'price': price,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
