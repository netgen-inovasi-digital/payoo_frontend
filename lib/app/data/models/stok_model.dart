class ProductWithStock {
  final int id;
  final int shopId;
  final int? categoryId;
  final String name;
  final String description;
  final String photo;
  final String type; // "product" or "composition"
  final String? unit;
  final double costPrice;
  final double sellingPrice;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int stock;

  ProductWithStock({
    required this.id,
    required this.shopId,
    this.categoryId,
    required this.name,
    required this.description,
    required this.photo,
    required this.type,
    this.unit,
    required this.costPrice,
    required this.sellingPrice,
    required this.createdAt,
    required this.updatedAt,
    required this.stock,
  });

  factory ProductWithStock.fromJson(Map<String, dynamic> json) {
    return ProductWithStock(
      id: _parseInt(json['id']) ?? 0,
      shopId: _parseInt(json['shop_id']) ?? 0,
      categoryId: _parseInt(json['category_id']),
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      photo: json['photo']?.toString() ?? '',
      type: json['type']?.toString() ?? 'product',
      unit: json['unit']?.toString(),
      costPrice: _parseDouble(json['cost_price']) ?? 0.0,
      sellingPrice: _parseDouble(json['selling_price']) ?? 0.0,
      createdAt: _parseDateTime(json['created_at']) ?? DateTime.now(),
      updatedAt: _parseDateTime(json['updated_at']) ?? DateTime.now(),
      stock: _parseInt(json['stock']) ?? 0,
    );
  }

  // Helper methods (reuse from Stock class)
  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value);
    }
    return null;
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is String && value.isNotEmpty) {
      try {
        if (value.startsWith('0000-00-00')) {
          return null;
        }
        return DateTime.parse(value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}
class Stock {
  final int id;
  final int productId; // Use product_id from API
  int quantity;
  final String? type;
  final double? buyPrice;
  final String? notes;
  final DateTime? date; // Can be null (e.g. "0000-00-00 00:00:00")
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String productName;
  final String? productType; // "product" or "composition"

  Stock({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.type,
    this.buyPrice,
    this.notes,
    this.date,
    required this.createdAt,
    this.updatedAt,
    required this.productName,
    this.productType,
  });

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      id: _parseInt(json['id']) ?? 0,
      productId: _parseInt(json['product_id']) ?? 0,
      quantity: _parseInt(json['quantity']) ?? 0,
      type: json['type']?.toString(),
      buyPrice: _parseDouble(json['buy_price']),
      notes: json['notes']?.toString(),
      date: _parseDateTime(json['date']),
      createdAt: _parseDateTime(json['created_at']) ?? DateTime.now(),
      updatedAt: _parseDateTime(json['updated_at']),
      productName: json['product_name']?.toString() ?? '',
      productType: json['product_type']?.toString(),
    );
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is String && value.isNotEmpty) {
      try {
        if (value.startsWith('0000-00-00')) return null;
        final normalized = value.contains('T') ? value : value.replaceFirst(' ', 'T');
        return DateTime.parse(normalized);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'quantity': quantity,
      'type': type.toString(),
      'buy_price': buyPrice,
      'notes': notes,
      'date': date?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'product_name': productName,
      'product_type': productType,
    };
  }
}