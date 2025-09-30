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
  final int productId; // Changed from compositionId to match API response
  int quantity;
  final StockType type;
  final double? buyPrice; // Add buy_price field
  final String? notes; // Add notes field
  final DateTime? date; // Make nullable for cases like "0000-00-00 00:00:00"
  final DateTime createdAt;
  final DateTime? updatedAt; // Make nullable

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
  });

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      id: _parseInt(json['id']) ?? 0,
      productId: _parseInt(json['product_id']) ?? 0, // Use product_id from API
      quantity: _parseInt(json['quantity']) ?? 0,
      type: StockType.fromString(json['type']?.toString() ?? 'in'),
      buyPrice: _parseDouble(json['buy_price']),
      notes: json['notes']?.toString(),
      date: _parseDateTime(json['date']),
      createdAt: _parseDateTime(json['created_at']) ?? DateTime.now(),
      updatedAt: _parseDateTime(json['updated_at']),
    );
  }

  // Helper method untuk parsing int dengan null safety
  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }

  // Helper method untuk parsing double dengan null safety
  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value);
    }
    return null;
  }

  // Helper method untuk parsing DateTime dengan null safety
  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is String && value.isNotEmpty) {
      try {
        // Handle invalid dates like "0000-00-00 00:00:00"
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
    };
  }
}

enum StockType {
  stockIn,
  stockOut;
  
  static StockType fromString(String? value) {
    if (value == null) return StockType.stockIn; // Default fallback
    switch (value.toLowerCase()) {
      case 'in':
        return StockType.stockIn;
      case 'out':
        return StockType.stockOut;
      default:
        return StockType.stockIn; // Default fallback instead of throwing
    }
  }
  
  @override
  String toString() {
    return this == StockType.stockIn ? 'in' : 'out';
  }
}