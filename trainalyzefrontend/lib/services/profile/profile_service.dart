import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trainalyzefrontend/enviroment/env.dart';
import 'package:trainalyzefrontend/services/auth/jwt_service.dart';

import '../../entities/profile/Profile.dart';

class ProfileService {
  final String profileURL = '${AppConfig.baseUrl}/profile';

  ProfileService();

  Future<Profile> fetchProfile() async {
    try {
      final url = Uri.parse('$profileURL/current');

      // JWT-Headers abrufen (enthält Authorization und Content-Type)
      final headers = await JwtService.getAuthHeaders();

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        return Profile.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load profile');
      }
    } catch (e) {
      throw Exception('Failed to load profile');
    }
  }

  Future<bool> updateProfile(Profile profile) async {
    try {
      final url = Uri.parse('$profileURL/update');

      // JWT-Headers abrufen (enthält Authorization und Content-Type)
      final headers = await JwtService.getAuthHeaders();

      final response = await http.put(
        url,
        headers: headers,
        body: jsonEncode(profile.toJson()),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
