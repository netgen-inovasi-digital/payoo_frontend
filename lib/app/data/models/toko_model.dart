// Model Toko untuk konsumsi API
import 'package:payoo/app/data/models/user_model.dart';

class Toko {
  final int id;
  final int userId;
  final String name;
  final String email;
  final String address;
  final String phone;
  String photo;
  final User user;
  final String? createdAt;
  final String? updatedAt;

  Toko({
    required this.id,
    required this.userId,
    required this.name,
    required this.email,
    required this.address,
    required this.phone,
    required this.user,
    required this.photo,
    this.createdAt,
    this.updatedAt,
  });

  factory Toko.fromJson(Map<String, dynamic> json) {
    return Toko(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      userId: json['user_id'] is int
          ? json['user_id']
          : int.tryParse(json['user_id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      photo: json['photo']?.toString() ?? '',
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      user: User(
        id: json['user']?['id'] ?? 0,
        name: json['user']?['name'] ?? '',
        email: json['user']?['email'] ?? '',
        photo: json['user']?['photo'] ?? '',
        role: json['user']?['role'] ?? '',
        phone: json['user']?['phone'] ?? '',
        shopId: json['user']?['shop_id'] ?? 0,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'name': name,
        'email': email,
        'address': address,
        'phone': phone,
        'photo': photo,
        'user' : user.toJson(),
      };
}
