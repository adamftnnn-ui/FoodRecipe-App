import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class UserRepository {
  final http.Client _client;

  UserRepository({http.Client? client}) : _client = client ?? http.Client();

  Future<UserModel> fetchUser() async {
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
