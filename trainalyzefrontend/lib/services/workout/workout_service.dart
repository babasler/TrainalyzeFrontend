// lib/services/workout_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trainalyzefrontend/enviroment/env.dart';
import '../../entities/workout/workout.dart';
import '../auth/jwt_service.dart';

class WorkoutService {
  final String workoutUrl = '${AppConfig.baseUrl}/trainalyze/workout';

  Future<String> createWorkout(Workout workout) async {
    try {
      final headers = await JwtService.getAuthHeaders();

      final response = await http.post(
        Uri.parse('$workoutUrl/create'),
        headers: headers,
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

  Future<List<Workout>> getAllWorkouts() async {
    try {
      final headers = await JwtService.getAuthHeaders();

      final response = await http.get(
        Uri.parse('$workoutUrl/get/all'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Workout.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load workouts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading workouts: $e');
    }
  }
}