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
        name: json['category_name'] ?? '',
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

// Dummy data for Produk model
final List<Produk> produkList = [
  Produk(
    id: 1,
    name: 'Classic Burger',
    description: 'Burger klasik dengan daging sapi, selada, tomat, dan saus spesial. Cita rasa autentik dengan bahan-bahan segar pilihan.',
    photo: 'https://static.vecteezy.com/system/resources/previews/027/145/340/non_2x/delicious-double-size-burger-isolated-on-transparent-background-png.png',
    costPrice: 15000,
    sellingPrice: 25000,
    shop: Shop(id: 1, name: 'Burger Shop'),
    kategori: Kategori(id: 1, name: 'Makanan'),
    compositions: [
      
    ],
    createdAt: DateTime.now().subtract(Duration(days: 30)),
    updatedAt: DateTime.now(),
    
  ),
  Produk(
    id: 2,
    name: 'Beef Mentai',
    description: 'Burger daging sapi dengan saus mentai yang creamy dan gurih. Paduan sempurna rasa Jepang dan Western.',
    photo: 'https://i.gojekapi.com/darkroom/gofood-indonesia/v2/images/uploads/28a86197-a2fb-44b0-8944-73d683dc2c9b_Go-Biz_20220324_115050.jpeg',
    costPrice: 16000,
    sellingPrice: 25000,
    shop: Shop(id: 1, name: 'Burger Shop'),
    kategori: Kategori(id: 1, name: 'Makanan'),
    createdAt: DateTime.now().subtract(const Duration(days: 25)),
    updatedAt: DateTime.now(),
  ),
  Produk(
    id: 3,
    name: 'Cheeseburger Universal (Double)',
    description: 'Double cheeseburger dengan keju leleh yang melimpah. Daging sapi double dengan rasa yang tak terlupakan.',
    photo: 'https://static.vecteezy.com/system/resources/previews/027/143/844/non_2x/delicious-cheese-burger-on-transparent-background-png.png',
    costPrice: 18000,
    sellingPrice: 28000,
    shop: Shop(id: 1, name: 'Burger Shop'),
    kategori: Kategori(id: 1, name: 'Makanan'),
    createdAt: DateTime.now().subtract(const Duration(days: 20)),
    updatedAt: DateTime.now(),
  ),
  Produk(
    id: 4,
    name: 'Chicken Burger',
    description: 'Burger ayam crispy dengan tekstur renyah di luar dan juicy di dalam. Disajikan dengan sayuran segar.',
    photo: 'https://static.vecteezy.com/system/resources/thumbnails/032/325/117/small_2x/fried-chicken-burger-isolated-on-transparent-background-file-cut-out-ai-generated-png.png',
    costPrice: 12000,
    sellingPrice: 20000,
    shop: Shop(id: 1, name: 'Burger Shop'),
    kategori: Kategori(id: 1, name: 'Makanan'),
    createdAt: DateTime.now().subtract(const Duration(days: 15)),
    updatedAt: DateTime.now(),
  ),
  Produk(
    id: 5,
    name: 'Chicken Mentai',
    description: 'Burger ayam dengan saus mentai yang creamy. Kombinasi unik antara ayam crispy dan saus khas Jepang.',
    photo: 'https://static.vecteezy.com/system/resources/thumbnails/054/398/311/small/truffle-chicken-mentai-sauce-with-egg-png.png',
    costPrice: 13000,
    sellingPrice: 20000,
    shop: Shop(id: 1, name: 'Burger Shop'),
    kategori: Kategori(id: 1, name: 'Makanan'),
    createdAt: DateTime.now().subtract(const Duration(days: 10)),
    updatedAt: DateTime.now(),
  ),
  Produk(
    id: 6,
    name: 'Es Susu Gula Aren',
    description: 'Minuman segar es susu dengan gula aren alami. Manis alami dengan cita rasa tradisional Indonesia.',
    photo: 'https://waroengsteakandshake.com/img/img_menu/Caramel_Latte_Ice1.png',
    costPrice: 7000,
    sellingPrice: 12000,
    shop: Shop(id: 1, name: 'Burger Shop'),
    kategori: Kategori(id: 2, name: 'Minuman'),
    createdAt: DateTime.now().subtract(const Duration(days: 5)),
    updatedAt: DateTime.now(),
  ),
];