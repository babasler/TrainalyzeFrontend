import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trainalyzefrontend/entities/profile/bodyweight.dart';
import 'package:trainalyzefrontend/entities/profile/profile.dart';
import 'package:trainalyzefrontend/entities/profile/profileToProfileOutputMapper.dart';
import 'package:trainalyzefrontend/enviroment/env.dart';
import 'package:trainalyzefrontend/services/auth/jwt_service.dart';

class ProfileService {
  final String profileURL = '${AppConfig.baseUrl}/profile';

  ProfileService();

  Future<Profile> fetchProfile() async {
    try {
      final url = Uri.parse('$profileURL/current');

      // JWT-Headers abrufen (enthält Authorization und Content-Type)
      final headers = await JwtService.getAuthHeaders();

      final response = await http.get(url, headers: headers);

      // Jetzt mit detaillierten Logs
      print('Profile fetch response: ${response.statusCode}');
      print('Profile fetch body: ${response.body}');

      if (response.statusCode == 200) {
        return Profile.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load profile');
      }
    } catch (e) {
      // Original-Fehler wird weitergegeben
      throw Exception('Failed to load profile: $e');
    }
  }

  Future<bool> updateProfile(Profile profile) async {
    print("Updating profile: ${profile.toJson()}");

    ProfileOutputDTO dto =
        mapProfileToProfileOutputDTO(profile); 
    print("Mapped DTO: ${dto.toJson()}");
    try {
      final url = Uri.parse('$profileURL/update');

      // JWT-Headers abrufen (enthält Authorization und Content-Type)
      final headers = await JwtService.getAuthHeaders();

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(dto.toJson()),
      );
      print('Profile update response: ${response.statusCode}');
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> safeBodyWeight(BodyWeight bodyWeight) async {
    print("Sending Bodyweight: ${bodyWeight.toJson()}");
    try {
      final url = Uri.parse('$profileURL/bodyweight/add');

      // JWT-Headers abrufen (enthält Authorization und Content-Type)
      final headers = await JwtService.getAuthHeaders();

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(bodyWeight.toJson()),
      );
      
      print('Weight update response: ${response.statusCode}');
      print('Weight update body: ${response.body}');
      
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Exception: $e');
      return false;
    }
  }
}
