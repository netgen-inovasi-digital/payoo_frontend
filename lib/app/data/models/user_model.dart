    // Model User untuk konsumsi API
    class User {
      final int id;
      final String name;
      final String email;
       String photo;
      final String role;
      final String phone;
      final int shopId;
      final String? createdAt;
      final String? updatedAt;

      User({
        required this.id,
        required this.name,
        required this.email,
        required this.photo,
        required this.role,
        required this.phone,
        required this.shopId,
        this.createdAt,
        this.updatedAt,
      });

      factory User.fromJson(Map<String, dynamic> json) {
        return User(
          id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
          name: json['name']?.toString() ?? '',
          phone: json['phone']?.toString() ?? '',
          email: json['email']?.toString() ?? '',
          photo: json['photo']?.toString() ?? '',
          role: json['role']?.toString() ?? '',
          shopId: json['shop_id'] is int ? json['shop_id'] : int.tryParse(json['shop_id'].toString()) ?? 0,
          createdAt: json['created_at']?.toString(),
          updatedAt: json['updated_at']?.toString(),
        );
      }

      Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'photo': photo,
        'role': role,
        'phone': phone,
        'shop_id': shopId,
        
      };
    }