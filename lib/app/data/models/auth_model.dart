class UserModel {
	final int id;
	final String name;
	final String email;
	final String phone;
	final String? photo;
	final String role;
	final String createdAt;
	final String updatedAt;

	UserModel({
		required this.id,
		required this.name,
		required this.email,
		required this.phone,
		this.photo,
		required this.role,
		required this.createdAt,
		required this.updatedAt,
	});

	factory UserModel.fromJson(Map<String, dynamic> json) {
		return UserModel(
			id: json['id'],
			name: json['name'],
			email: json['email'],
			phone: json['phone'],
			photo: json['photo'],
			role: json['role'],
			createdAt: json['created_at'],
			updatedAt: json['updated_at'],
		);
	}
}

class AuthData {
	final String token;
	final UserModel user;

	AuthData({required this.token, required this.user});

	factory AuthData.fromJson(Map<String, dynamic> json) {
		return AuthData(
			token: json['token'],
			user: UserModel.fromJson(json['user']),
		);
	}
}

class AuthResponse {
	final String status;
	final String message;
	final AuthData data;

	AuthResponse({required this.status, required this.message, required this.data});

	factory AuthResponse.fromJson(Map<String, dynamic> json) {
		return AuthResponse(
			status: json['status'],
			message: json['message'],
			data: AuthData.fromJson(json['data']),
		);
	}
}
