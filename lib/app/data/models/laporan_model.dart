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

class ReportFilters {
  final String rangeStart;
  final String rangeEnd;

  ReportFilters({
    required this.rangeStart,
    required this.rangeEnd,
  });

  factory ReportFilters.fromJson(Map<String, dynamic> json) {
    return ReportFilters(
      rangeStart: json['range_start'] ?? '',
      rangeEnd: json['range_end'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'range_start': rangeStart,
      'range_end': rangeEnd,
    };
  }
}

class OrdersReport {
  final List<OrderReport> orders;
  final int totalOrders;
  final ReportFilters filters;
  final DateRange dateRange;

  OrdersReport({
    required this.orders,
    required this.totalOrders,
    required this.filters,
    required this.dateRange,
  });

  factory OrdersReport.fromJson(Map<String, dynamic> json) {
    final ordersList = (json['orders'] as List?) ?? [];
    final orders = ordersList.map((e) => OrderReport.fromJson(e as Map<String, dynamic>)).toList();

    return OrdersReport(
      orders: orders,
      totalOrders: json['total_orders'] ?? 0,
      filters: ReportFilters.fromJson(json['filters'] ?? {}),
      dateRange: DateRange.fromJson(json['date_range'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orders': orders.map((o) => o.toJson()).toList(),
      'total_orders': totalOrders,
      'filters': filters.toJson(),
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
}