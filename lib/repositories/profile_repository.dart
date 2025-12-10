import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/user_model.dart';

/// Repository untuk profil user.
///
/// Mengambil data user dari REST API publik (JSONPlaceholder).
/// Jika gagal, fallback ke data lokal supaya aplikasi tetap stabil.
class ProfileRepository {
  final http.Client _client;

  ProfileRepository({http.Client? client}) : _client = client ?? http.Client();

  Future<UserModel> fetchUserProfile() async {
    final Uri uri = Uri.parse('https://jsonplaceholder.typicode.com/users/1');

    try {
      final http.Response response = await _client
          .get(uri)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            json.decode(response.body) as Map<String, dynamic>;

        final String name = (data['name'] as String?) ?? 'User';
        final String email = (data['email'] as String?) ?? 'user@example.com';

        final String avatarUrl =
            'https://i.pravatar.cc/150?u=${Uri.encodeComponent(email)}';

        return UserModel(name: name, avatarUrl: avatarUrl);
      } else {
        return _fallbackUser();
      }
    } catch (_) {
      return _fallbackUser();
    }
  }

  UserModel _fallbackUser() {
    return UserModel(name: 'Adam', avatarUrl: 'assets/images/avatar.jpg');
  }
}
