class UserModel {
  final String name;
  final String avatarUrl;

  UserModel({required this.name, required this.avatarUrl});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] ?? 'User',
      avatarUrl: json['avatarUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'avatarUrl': avatarUrl};
  }
}
