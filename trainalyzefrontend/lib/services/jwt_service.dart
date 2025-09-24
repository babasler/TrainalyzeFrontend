import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class JwtService {
  static const String _tokenKey = 'jwt_token';
  static const String _userKey = 'user_data';

  /// Speichert JWT Token in SharedPreferences
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  /// Holt JWT Token aus SharedPreferences
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// Löscht JWT Token und User-Daten
  static Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }

  /// Prüft ob Token vorhanden und gültig ist
  static Future<bool> isTokenValid() async {
    final token = await getToken();
    if (token == null) return false;

    try {
      // Token-Gültigkeit prüfen (einfache Implementierung)
      final parts = token.split('.');
      if (parts.length != 3) return false;

      final payload = json.decode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );

      final exp = payload['exp'];
      if (exp == null) return true; // Kein Expiry = immer gültig

      final now = DateTime.now().millisecondsSinceEpoch / 1000;
      return exp > now;
    } catch (e) {
      print('Token validation error: $e');
      return false;
    }
  }

  /// User-Daten speichern
  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(userData));
  }

  /// Holt User-Daten
  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(_userKey);
    if (userData == null) return null;

    try {
      return json.decode(userData) as Map<String, dynamic>;
    } catch (e) {
      print('Error parsing user data: $e');
      return null;
    }
  }

  /// Extrahiert User-Daten aus JWT Token
  static Map<String, dynamic>? getUserFromToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      final payload = json.decode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );

      return payload;
    } catch (e) {
      print('Error extracting user from token: $e');
      return null;
    }
  }

  /// Authorization Header für API-Calls
  static Future<Map<String, String>> getAuthHeaders() async {
    final token = await getToken();
    if (token == null) return {};

    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }
}
