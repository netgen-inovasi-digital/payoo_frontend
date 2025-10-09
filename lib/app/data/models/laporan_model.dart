import 'dart:convert';

class OrderReport {
  final String id;
  final String userId;
  final String shopId;
  final String status;
  final String notes;
  final double total;
  final double amountPaid;
  final double changeMoney;
  final double tax;
  final String paymentMethod;
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
    required this.changeMoney,
    required this.tax,
    required this.paymentMethod,
    required this.createdAt,
    required this.updatedAt,
    required this.totalItems,
  });

  factory OrderReport.fromJson(Map<String, dynamic> json) {
    return OrderReport(
      id: json['id'].toString(),
      userId: json['user_id'].toString(),
      shopId: json['shop_id'].toString(),
      status: json['status'] ?? '',
      notes: json['notes'] ?? '',
      total: double.tryParse(json['total'].toString()) ?? 0.0,
      amountPaid: double.tryParse(json['amount_paid'].toString()) ?? 0.0,
      changeMoney: double.tryParse(json['change_money'].toString()) ?? 0.0,
      tax: double.tryParse(json['tax'].toString()) ?? 0.0,
      paymentMethod: json['payment_method'] ?? '',
      // FIX: Handle the specific date format by replacing the space with a 'T'.
      createdAt: DateTime.parse(json['created_at'].toString().replaceFirst(' ', 'T')),
      updatedAt: DateTime.parse(json['updated_at'].toString().replaceFirst(' ', 'T')),
      totalItems: int.tryParse(json['total_items'].toString()) ?? 0,
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
      'change_money': changeMoney.toString(),
      'tax': tax.toString(),
      'payment_method': paymentMethod,
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
    double? changeMoney,
    double? tax,
    String? paymentMethod,
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
      changeMoney: changeMoney ?? this.changeMoney,
      tax: tax ?? this.tax,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      totalItems: totalItems ?? this.totalItems,
    );
  }
}

class DateRange {
  final DateTime start;
  final DateTime end;

  DateRange({
    required this.start,
    required this.end,
  });

  factory DateRange.fromJson(Map<String, dynamic> json) {
    return DateRange(
      // FIX: Handle the specific date format by replacing the space with a 'T'.
      start: DateTime.parse(json['start'].toString().replaceFirst(' ', 'T')),
      end: DateTime.parse(json['end'].toString().replaceFirst(' ', 'T')),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'start': start.toIso8601String(),
      'end': end.toIso8601String(),
    };
  }
}

class OrdersReport {
  final List<OrderReport> orders;
  final int totalOrders;
  final String period;
  final DateRange dateRange;

  OrdersReport({
    required this.orders,
    required this.totalOrders,
    required this.period,
    required this.dateRange,
  });

  // FIX: This factory now works directly with the 'data' object from your API response.
  factory OrdersReport.fromJson(Map<String, dynamic> json) {
    // The 'json' parameter is now expected to be the 'data' object itself.
    final ordersList = json['orders'] as List;
    final orders = ordersList.map((e) => OrderReport.fromJson(e)).toList();

    return OrdersReport(
      orders: orders,
      totalOrders: json['total_orders'] ?? 0,
      period: json['period'] ?? '',
      dateRange: DateRange.fromJson(json['date_range']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orders': orders.map((o) => o.toJson()).toList(),
      'total_orders': totalOrders,
      'period': period,
      'date_range': dateRange.toJson(),
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
      totalRevenue: double.tryParse(json['total_revenue'].toString()) ?? 0.0,
      totalTransactions: json['total_transactions'] ?? 0,
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