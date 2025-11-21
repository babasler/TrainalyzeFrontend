import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trainalyzefrontend/entities/exercise/exercise.dart';
import 'package:trainalyzefrontend/enviroment/env.dart';
import 'package:trainalyzefrontend/services/auth/jwt_service.dart';

class ExerciseService {
  final String exerciseURL = '${AppConfig.baseUrl}/exercise';

  ExerciseService();

  Future<bool> saveExercise(Exercise exercise) async {
    try {
      final url = Uri.parse('$exerciseURL/create');

      // JWT-Headers abrufen (enthält Authorization und Content-Type)
      final headers = await JwtService.getAuthHeaders();
      print("Saving Exercise: ${exercise.toJson()}");

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(exercise.toJson()),
      );

      if (response.statusCode == 200) {
        return true; // Erfolgreich gespeichert
      } else {
        return false; // Fehler beim Speichern
      }
    } catch (e) {
      return false;
    }
  }

  Future<List<ExerciseInputDTO>> fetchExercises() async {
    try {
      final url = Uri.parse('$exerciseURL/get');

      // JWT-Headers abrufen (enthält Authorization und Content-Type)
      final headers = await JwtService.getAuthHeaders();

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        return responseData.map((data) => ExerciseInputDTO.fromJson(data)).toList();
      } else {
        return []; // Fehler beim Abrufen
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<String>> fetchExerciseNames() async {
    try {
      final url = Uri.parse('$exerciseURL/get/names');

      // JWT-Headers abrufen (enthält Authorization und Content-Type)
      final headers = await JwtService.getAuthHeaders();

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        return responseData.map((data) => data.toString()).toList();
      } else {
        return []; // Fehler beim Abrufen
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<String>> fetchExerciseByType(String type) async {
    try {
      final url = Uri.parse('$exerciseURL/get/type/$type');

      // JWT-Headers abrufen (enthält Authorization und Content-Type)
      final headers = await JwtService.getAuthHeaders();

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        return responseData.map((data) => data.toString()).toList();
      } else {
        return []; // Fehler beim Abrufen
      }
    } catch (e) {
      return [];
    }
  }

  Future<bool> doesExerciseExist(String name) async {
    try {
      final url = Uri.parse('$exerciseURL/exists/$name');

      // JWT-Headers abrufen (enthält Authorization und Content-Type)
      final headers = await JwtService.getAuthHeaders();

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        bool exists = jsonDecode(response.body);
        return exists;
      } else {
        return false; // Fehler beim Abrufen
      }
    } catch (e) {
      return false;
    }
  }
}
