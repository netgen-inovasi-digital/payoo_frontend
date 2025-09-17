
class OrderReport {
  final String id;
  final String userId;
  final String shopId;
  final String status;
  final String notes;
  final double total;
  final double amountPaid;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int totalItems;

  OrderReport({
    required this.id,
    required this.userId,
    required this.shopId,
    required this.status,
    required this.notes,
    required this.total,
    required this.amountPaid,
    required this.createdAt,
    required this.updatedAt,
    required this.totalItems,
  });

  factory OrderReport.fromJson(Map<String, dynamic> json) {
    return OrderReport(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      shopId: json['shop_id'] as String,
      status: json['status'] as String,
      notes: json['notes'] as String,
      total: double.parse(json['total'] as String),
      amountPaid: double.parse(json['amount_paid'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      totalItems: int.parse(json['total_items'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'shop_id': shopId,
      'status': status,
      'notes': notes,
      'total': total.toString(),
      'amount_paid': amountPaid.toString(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'total_items': totalItems.toString(),
    };
  }

  OrderReport copyWith({
    String? id,
    String? userId,
    String? shopId,
    String? status,
    String? notes,
    double? total,
    double? amountPaid,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? totalItems,
  }) {
    return OrderReport(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      shopId: shopId ?? this.shopId,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      total: total ?? this.total,
      amountPaid: amountPaid ?? this.amountPaid,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      totalItems: totalItems ?? this.totalItems,
    );
  }
}

class OrdersReport {
  final List<OrderReport> orders;

  OrdersReport({required this.orders});

  factory OrdersReport.fromJson(Map<String, dynamic> json) {
    final ordersList = json['orders'] as List;
    final orders = ordersList
        .map((orderJson) => OrderReport.fromJson(orderJson))
        .toList();
    
    return OrdersReport(orders: orders);
  }

  Map<String, dynamic> toJson() {
    return {
      'orders': orders.map((order) => order.toJson()).toList(),
    };
  }
}

class ReportSummary {
  final double totalRevenue;
  final int totalTransactions;

  ReportSummary({
    required this.totalRevenue,
    required this.totalTransactions,
  });

  factory ReportSummary.fromJson(Map<String, dynamic> json) {
    return ReportSummary(
      totalRevenue: double.parse(json['total_revenue'] as String),
      totalTransactions: json['total_transactions'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_revenue': totalRevenue.toString(),
      'total_transactions': totalTransactions,
    };
  }

  ReportSummary copyWith({
    double? totalRevenue,
    int? totalTransactions,
  }) {
    return ReportSummary(
      totalRevenue: totalRevenue ?? this.totalRevenue,
      totalTransactions: totalTransactions ?? this.totalTransactions,
    );
  }
}