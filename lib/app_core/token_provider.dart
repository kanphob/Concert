import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenProvider {
  static const _tokenKey = 'access_token';
  static final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Retrieves the stored access token.
  /// Returns null if no token is saved.
  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  /// Saves a new access token.
  static Future<void> setToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  /// Clears the stored token (e.g., on forced logout).
  static Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
  }
}
