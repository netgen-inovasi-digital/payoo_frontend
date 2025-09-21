class Stock {
  final int id;
  final int compositionId;
   int quantity;
  final StockType type;
  final DateTime date;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  Stock({
    required this.id,
    required this.compositionId,
    required this.quantity,
    required this.type,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
  });
  
  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      id: json['id'],
      compositionId: json['composition_id'],
      quantity: json['quantity'],
      type: StockType.fromString(json['type']),
      date: DateTime.parse(json['date']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'composition_id': compositionId,
      'quantity': quantity,
      'type': type.toString(),
      'date': date.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

enum StockType {
  stockIn,
  stockOut;
  
  static StockType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'in':
        return StockType.stockIn;
      case 'out':
        return StockType.stockOut;
      default:
        throw FormatException('Unknown stock type: $value');
    }
  }
  
  @override
  String toString() {
    return this == StockType.stockIn ? 'in' : 'out';
  }
}