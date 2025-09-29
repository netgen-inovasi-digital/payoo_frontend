import 'package:payoo/app/data/models/kategori_model.dart';
import 'package:payoo/app/data/models/komposisi_model.dart';

class Shop {
  final int id;
  final String name;

  Shop({
    required this.id,
    required this.name,
  });
}

class Produk {
  final int id;
  final String name;
  final String description;
  final String photo;
  final int costPrice;
  final int sellingPrice;
  final int stock;
  final Shop shop;
  final Kategori kategori;
  final List<Komposisi> compositions;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  Produk({
    required this.id,
    required this.name,
    this.description = '',
    required this.photo,
    required this.costPrice,
    required this.sellingPrice,
    required this.stock,
    required this.shop,
    required this.kategori,
    this.notes = '',
    this.compositions = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory Produk.fromJson(Map<String, dynamic> json) {
    return Produk(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      photo: json['photo'],
      costPrice: _parseInt(json['cost_price']) ?? 0,
      sellingPrice: _parseInt(json['selling_price']) ?? 0,
      stock: _parseInt(json['stock']) ?? 0,
      notes: json['notes'],
      shop: Shop(
        id: json['shop_id'],
        name: '',
      ),
      kategori: Kategori(
        id: json['category_id'],
        name: json['category_name'] ?? '', shopId: json['shop_id'],
      ),
      compositions: (json['compositions'] as List<dynamic>?)
              ?.map((item) => Komposisi.fromJson(item))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
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
}
