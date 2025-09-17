class Kategori {
  final int id;
  final String name;
  final int shopId;
  final String? createdAt;
  final String? updatedAt;

  Kategori({
    required this.id,
    required this.name,
    required this.shopId,
    this.createdAt,
    this.updatedAt,
  });

  /// Factory untuk parsing dari JSON fleksibel
  factory Kategori.fromJson(Map<String, dynamic> json) {
    return Kategori(
      id: _asInt(json['id']),
      name: (json['name'] ?? json['category_name'] ?? '').toString(),
      shopId: _asInt(json['shop_id']),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  /// Payload untuk create
  Map<String, dynamic> toJsonCreate() => {
        'name': name,
        'shop_id': shopId,
      };

  /// Payload untuk update (semua field opsional; kirim yang diubah saja)
  Map<String, dynamic> toJsonUpdate({String? newName}) => {
        if (newName != null) 'name': newName,
      };

  static int _asInt(dynamic v) {
    if (v is int) return v;
    return int.tryParse(v?.toString() ?? '') ?? 0;
  }
}
