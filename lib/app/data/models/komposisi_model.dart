// Model Komposisi untuk konsumsi API
class Komposisi {
  final int id;
  final int? shopId;
  final String namaKomposisi; // mapping dari name
  final double hargaModal; // mapping dari cost_price
  final double hargaJual; // mapping dari selling_price
  final String satuan; // mapping dari unit
  final String? createdAt;
  final String? updatedAt;
  final int stokKomposisi; // tidak ada di API create -> default 0 atau dari endpoint lain
  int quantity; // untuk kebutuhan UI / form (tidak ada di API)

  Komposisi({
    required this.id,
    required this.namaKomposisi,
    required this.hargaModal,
    required this.hargaJual,
    required this.satuan,
    this.shopId,
    this.createdAt,
    this.updatedAt,
    this.stokKomposisi = 0,
    this.quantity = 0,
  });

  factory Komposisi.fromJson(Map<String, dynamic> json) {
    return Komposisi(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      shopId: json['shop_id'] is int
          ? json['shop_id']
          : int.tryParse(json['shop_id']?.toString() ?? ''),
      namaKomposisi: json['name']?.toString() ?? '-',
      hargaModal: _toDouble(json['cost_price']),
      hargaJual: _toDouble(json['selling_price']),
      satuan: json['unit']?.toString() ?? '',
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      stokKomposisi: json['stock'] is int
          ? json['stock']
          : int.tryParse(json['stock']?.toString() ?? '0') ?? 0,
      quantity: 0,
    );
  }

  Map<String, dynamic> toJsonCreate() => {
        'name': namaKomposisi,
        'cost_price': hargaModal,
        'selling_price': hargaJual,
        'unit': satuan,
      };

  static double _toDouble(dynamic v) {
    if (v == null) return 0;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0;
  }
}

final List<Komposisi> komposisiList = [
  Komposisi(
    id: 1,
    namaKomposisi: 'Roti',
    hargaModal: 2500,
    hargaJual: 3000,
    stokKomposisi: 15,
    satuan: 'pcs',
    quantity: 2,
  ),
  Komposisi(
    id: 2,
    namaKomposisi: 'Daging Sapi',
    hargaModal: 15000,
    hargaJual: 18000,
    stokKomposisi: 25,
    satuan: 'pcs',
    quantity: 3,
  ),
  Komposisi(
    id: 3,
    namaKomposisi: 'Keju',
    hargaModal: 3000,
    hargaJual: 4000,
    stokKomposisi: 30,
    satuan: 'lembar',
    quantity: 0,
  ),
  Komposisi(
    id: 4,
    namaKomposisi: 'Selada',
    hargaModal: 500,
    hargaJual: 800,
    stokKomposisi: 50,
    satuan: 'lembar',
    quantity: 0,
  ),
  Komposisi(
    id: 5,
    namaKomposisi: 'Tomat',
    hargaModal: 1000,
    hargaJual: 1500,
    stokKomposisi: 40,
    satuan: 'slice',
    quantity: 0,
  ),
  Komposisi(
    id: 6,
    namaKomposisi: 'Saus Mentai',
    hargaModal: 2000,
    hargaJual: 3000,
    stokKomposisi: 20,
    satuan: 'sendok',
    quantity: 0,
  ),
  Komposisi(
    id: 7,
    namaKomposisi: 'Daging Ayam',
    hargaModal: 8000,
    hargaJual: 10000,
    stokKomposisi: 35,
    satuan: 'pcs',
    quantity: 0,
  ),
  Komposisi(
    id: 8,
    namaKomposisi: 'Susu',
    hargaModal: 5000,
    hargaJual: 7000,
    stokKomposisi: 25,
    satuan: 'ml',
    quantity: 0,
  ),
  Komposisi(
    id: 9,
    namaKomposisi: 'Gula Aren',
    hargaModal: 3000,
    hargaJual: 4000,
    stokKomposisi: 15,
    satuan: 'sendok',
    quantity: 0,
  ),
  Komposisi(
    id: 10,
    namaKomposisi: 'Es Batu',
    hargaModal: 500,
    hargaJual: 1000,
    stokKomposisi: 100,
    satuan: 'pcs',
    quantity: 0,
  ),
];
