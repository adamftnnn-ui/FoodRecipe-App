class UserModel {
  final String name;
  final String avatarUrl;

  UserModel({required this.name, required this.avatarUrl});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: (json['name'] as String?) ?? 'User',
      avatarUrl: (json['avatarUrl'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'avatarUrl': avatarUrl};
  }
}
