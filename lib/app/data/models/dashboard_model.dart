class DashboardData {
  final int productQuantity;
  final int categoryQuantity;
  final int compositionQuantity;
  final int transactionCount;
  final int revenue;
  final String date;

  DashboardData({
    required this.productQuantity,
    required this.categoryQuantity,
    required this.compositionQuantity,
    required this.transactionCount,
    required this.revenue,
    required this.date,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      productQuantity: json['product_quantity'] as int,
      categoryQuantity: json['category_quantity'] as int,
      compositionQuantity: json['composition_quantity'] as int,
      transactionCount: json['transaction_count'] as int,
      revenue: json['revenue'] as int,
      date: json['date'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'product_quantity': productQuantity,
        'category_quantity': categoryQuantity,
        'composition_quantity': compositionQuantity,
        'transaction_count': transactionCount,
        'revenue': revenue,
        'date': date,
      };

  DashboardData copyWith({
    int? productQuantity,
    int? categoryQuantity,
    int? compositionQuantity,
    int? transactionCount,
    int? revenue,
    String? date,
  }) {
    return DashboardData(
      productQuantity: productQuantity ?? this.productQuantity,
      categoryQuantity: categoryQuantity ?? this.categoryQuantity,
      compositionQuantity: compositionQuantity ?? this.compositionQuantity,
      transactionCount: transactionCount ?? this.transactionCount,
      revenue: revenue ?? this.revenue,
      date: date ?? this.date,
    );
  }
}