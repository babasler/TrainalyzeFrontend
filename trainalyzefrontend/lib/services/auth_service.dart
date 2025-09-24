import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trainalyzefrontend/enviroment/env.dart';
import 'package:trainalyzefrontend/services/jwt_service.dart';

class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? error;
  final int? statusCode;

  ApiResponse({required this.success, this.data, this.error, this.statusCode});
}

class AuthService {
  static const String _loginEndpoint = '/auth/login';
  static const String _registerEndpoint = '/auth/register';
  // static const String _refreshEndpoint = '/auth/refresh';

  /// Login mit Username und PIN
  static Future<ApiResponse<Map<String, dynamic>>> login({
    required String username,
    required String pin,
  }) async {
    // Development-Modus: Lokale Überprüfung ohne Backend
    if (AppConfig.isDevelopmentMode) {
      return _developmentLogin(username, pin);
    }

    try {
      final url = Uri.parse('${AppConfig.baseUrl}$_loginEndpoint');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'username': username, 'pin': pin}),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        // JWT Token speichern
        if (responseData['token'] != null) {
          await JwtService.saveToken(responseData['token']);
        }

        // User-Daten speichern
        if (responseData['user'] != null) {
          await JwtService.saveUserData(responseData['user']);
        }

        return ApiResponse(
          success: true,
          data: responseData,
          statusCode: response.statusCode,
        );
      } else {
        return ApiResponse(
          success: false,
          error: responseData['message'] ?? 'Login fehlgeschlagen',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return ApiResponse(
        success: false,
        error: 'Netzwerkfehler: ${e.toString()}',
      );
    }
  }

  /// Registrierung mit Username und PIN
  static Future<ApiResponse<Map<String, dynamic>>> register({
    required String username,
    required String pin,
  }) async {
    // Development-Modus: Lokale Registrierung ohne Backend
    if (AppConfig.isDevelopmentMode) {
      return _developmentRegister(username, pin);
    }

    try {
      final url = Uri.parse('${AppConfig.baseUrl}$_registerEndpoint');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'username': username, 'pin': pin}),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Automatisch einloggen nach erfolgreicher Registrierung
        if (responseData['token'] != null) {
          await JwtService.saveToken(responseData['token']);
        }

        if (responseData['user'] != null) {
          await JwtService.saveUserData(responseData['user']);
        }

        return ApiResponse(
          success: true,
          data: responseData,
          statusCode: response.statusCode,
        );
      } else {
        return ApiResponse(
          success: false,
          error: responseData['message'] ?? 'Registrierung fehlgeschlagen',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return ApiResponse(
        success: false,
        error: 'Netzwerkfehler: ${e.toString()}',
      );
    }
  }

  /// Logout - Token löschen
  static Future<void> logout() async {
    await JwtService.deleteToken();
  }

  /// Prüft ob User eingeloggt ist
  static Future<bool> isLoggedIn() async {
    return await JwtService.isTokenValid();
  }

  /// Sichere HTTP GET-Anfrage mit JWT
  static Future<ApiResponse<Map<String, dynamic>>> secureGet(
    String endpoint,
  ) async {
    try {
      final headers = await JwtService.getAuthHeaders();
      final url = Uri.parse('${AppConfig.baseUrl}$endpoint');

      final response = await http.get(url, headers: headers);

      return _handleResponse(response);
    } catch (e) {
      return ApiResponse(
        success: false,
        error: 'Netzwerkfehler: ${e.toString()}',
      );
    }
  }

  /// Sichere HTTP POST-Anfrage mit JWT
  static Future<ApiResponse<Map<String, dynamic>>> securePost(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      final headers = await JwtService.getAuthHeaders();
      final url = Uri.parse('${AppConfig.baseUrl}$endpoint');

      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(data),
      );

      return _handleResponse(response);
    } catch (e) {
      return ApiResponse(
        success: false,
        error: 'Netzwerkfehler: ${e.toString()}',
      );
    }
  }

  /// Sichere HTTP PUT-Anfrage mit JWT
  static Future<ApiResponse<Map<String, dynamic>>> securePut(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      final headers = await JwtService.getAuthHeaders();
      final url = Uri.parse('${AppConfig.baseUrl}$endpoint');

      final response = await http.put(
        url,
        headers: headers,
        body: json.encode(data),
      );

      return _handleResponse(response);
    } catch (e) {
      return ApiResponse(
        success: false,
        error: 'Netzwerkfehler: ${e.toString()}',
      );
    }
  }

  /// Sichere HTTP DELETE-Anfrage mit JWT
  static Future<ApiResponse<Map<String, dynamic>>> secureDelete(
    String endpoint,
  ) async {
    try {
      final headers = await JwtService.getAuthHeaders();
      final url = Uri.parse('${AppConfig.baseUrl}$endpoint');

      final response = await http.delete(url, headers: headers);

      return _handleResponse(response);
    } catch (e) {
      return ApiResponse(
        success: false,
        error: 'Netzwerkfehler: ${e.toString()}',
      );
    }
  }

  /// Behandelt HTTP-Antworten
  static ApiResponse<Map<String, dynamic>> _handleResponse(
    http.Response response,
  ) {
    try {
      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResponse(
          success: true,
          data: responseData,
          statusCode: response.statusCode,
        );
      } else if (response.statusCode == 401) {
        // Token abgelaufen - User ausloggen
        JwtService.deleteToken();
        return ApiResponse(
          success: false,
          error: 'Session abgelaufen. Bitte erneut einloggen.',
          statusCode: response.statusCode,
        );
      } else {
        return ApiResponse(
          success: false,
          error: responseData['message'] ?? 'Unbekannter Fehler',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return ApiResponse(
        success: false,
        error: 'Fehler beim Verarbeiten der Antwort: ${e.toString()}',
        statusCode: response.statusCode,
      );
    }
  }

  /// Aktueller User aus dem Token
  static Future<Map<String, dynamic>?> getCurrentUser() async {
    return await JwtService.getUserData();
  }

  // ============================================================================
  // DEVELOPMENT MODE METHODEN (nur für lokale Entwicklung ohne Backend)
  // ============================================================================

  /// Development-Modus Login (akzeptiert beliebige Daten)
  static Future<ApiResponse<Map<String, dynamic>>> _developmentLogin(
    String username,
    String pin,
  ) async {
    // Kurze Verzögerung simulieren
    await Future.delayed(const Duration(milliseconds: 500));

    // Dummy JWT Token für Dev-Modus erstellen
    final devToken = _createDevToken(username);

    // Dummy User-Daten
    final userData = {
      'id': 1,
      'username': username,
      'email': '${username}@dev.local',
      'created_at': DateTime.now().toIso8601String(),
    };

    // Token und User-Daten speichern
    await JwtService.saveToken(devToken);
    await JwtService.saveUserData(userData);

    return ApiResponse(
      success: true,
      data: {
        'token': devToken,
        'user': userData,
        'message': 'Development login successful',
      },
      statusCode: 200,
    );
  }

  /// Development-Modus Registrierung (akzeptiert beliebige Daten)
  static Future<ApiResponse<Map<String, dynamic>>> _developmentRegister(
    String username,
    String pin,
  ) async {
    // Kurze Verzögerung simulieren
    await Future.delayed(const Duration(milliseconds: 800));

    // Dummy JWT Token für Dev-Modus erstellen
    final devToken = _createDevToken(username);

    // Dummy User-Daten
    final userData = {
      'id': DateTime.now().millisecondsSinceEpoch,
      'username': username,
      'email': '${username}@dev.local',
      'created_at': DateTime.now().toIso8601String(),
    };

    // Token und User-Daten speichern
    await JwtService.saveToken(devToken);
    await JwtService.saveUserData(userData);

    return ApiResponse(
      success: true,
      data: {
        'token': devToken,
        'user': userData,
        'message': 'Development registration successful',
      },
      statusCode: 201,
    );
  }

  /// Erstellt einen einfachen Dev-Token (NICHT für Produktion verwenden!)
  static String _createDevToken(String username) {
    final header = base64Encode(
      utf8.encode(json.encode({'typ': 'JWT', 'alg': 'HS256'})),
    );

    final payload = base64Encode(
      utf8.encode(
        json.encode({
          'sub': username,
          'username': username,
          'iat': DateTime.now().millisecondsSinceEpoch ~/ 1000,
          'exp':
              DateTime.now()
                  .add(const Duration(days: 30))
                  .millisecondsSinceEpoch ~/
              1000,
          'dev_mode': true,
        }),
      ),
    );

    final signature = base64Encode(utf8.encode('dev_signature'));

    return '$header.$payload.$signature';
  }
}
