class User {
  final int? id;
  final String username;


  User({
    this.id,
    required this.username,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int?,
      username: json['username'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
    };
  }

  User copyWith({
    int? id,
    String? username,
    String? email,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
    );
  }

}

class LoginRequest {
  final String username;
  final String pin;

  LoginRequest({required this.username, required this.pin});

  Map<String, dynamic> toJson() {
    return {'username': username, 'pin': pin};
  }
}

class RegisterRequest {
  final String username;
  final String pin;
  final String? email;

  RegisterRequest({required this.username, required this.pin, this.email});

}

class AuthResponse {
  final bool success;
  final String? token;
  final User? user;
  final String? message;

  AuthResponse({required this.success, this.token, this.user, this.message});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      success: json['success'] as bool? ?? true,
      token: json['token'] as String?,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'token': token,
      'user': user?.toJson(),
      'message': message,
    };
  }
}
