class UserModel {
  final int id;
  final String username;
  final String name;
  final String email;
  final String? lastLogin;
  final String? description;
  final String status;

  const UserModel({
    required this.id,
    required this.username,
    required this.name,
    required this.email,
    required this.lastLogin,
    required this.description,
    required this.status,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      name: json['name'],
      email: json['email'],
      lastLogin: json['last_login'],
      description: json['description'],
      status: json['status'],
    );
  }

  static dynamic checkEmpty(dynamic value){
    return value != '' ? value : null;
  }
}
