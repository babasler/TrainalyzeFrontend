// lib/services/workout_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/workout_dto.dart';
import '../auth/jwt_service.dart';

class WorkoutService {
  final String baseUrl = 'http://your-server:8084/trainalyze/workout';

  Future<String> createWorkout(WorkoutDTO workout) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/create'),
        headers: {
          'Content-Type': 'application/json',
          if (jwtToken != null) 'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode(workout.toJson()),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['message'] ?? 'Workout created successfully';
      } else {
        throw Exception('Failed to create workout: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating workout: $e');
    }
  }

  Future<List<WorkoutDTO>> getAllWorkouts() async {
    try {
      final headers = await JwtService.getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/get/all'),
        headers: headers,
        }
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => WorkoutDTO.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load workouts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading workouts: $e');
    }
  }

  Future<WorkoutDTO?> getWorkoutByName(String name) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get?name=$name'),
        headers: {
          'Content-Type': 'application/json',
          if (jwtToken != null) 'Authorization': 'Bearer $jwtToken',
        },
      );

      if (response.statusCode == 200) {
        return WorkoutDTO.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to load workout: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading workout: $e');
    }
  }
}