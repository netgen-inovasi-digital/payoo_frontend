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
      costPrice: json['cost_price'],
      sellingPrice: json['selling_price'],
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
}
