# API Dokumentation

Diese Dokumentation beschreibt die Backend-Integration und API-Endpunkte der Trainalyze-App.

## 🌐 Basis-Konfiguration

### Umgebungsvariablen
```dart
// env.dart
class Env {
  static const bool isDevelopment = true;
  static const String apiBaseUrl = 'https://api.trainalyze.com';
  static const String developmentApiUrl = 'http://localhost:3000';
}
```

### AuthService
Zentrale Authentifizierung mit JWT-Token Management

```dart
class AuthService {
  static String get baseUrl => Env.isDevelopment 
    ? Env.developmentApiUrl 
    : Env.apiBaseUrl;
}
```

## 🔐 Authentifizierung

### Login
**POST** `/auth/login`

```dart
// Request
{
  "username": "maxmustermann",
  "pin": "1234"
}

// Response
{
  "success": true,
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": 1,
    "username": "maxmustermann",
    "email": "max@example.com"
  },
  "message": "Login erfolgreich"
}
```

### Registrierung
**POST** `/auth/register`

```dart
// Request
{
  "username": "neuernutzer",
  "pin": "5678",
  "email": "neu@example.com" // optional
}

// Response
{
  "success": true,
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": 2,
    "username": "neuernutzer",
    "email": "neu@example.com"
  },
  "message": "Registrierung erfolgreich"
}
```

### Token Refresh
**POST** `/auth/refresh`

```dart
// Headers
{
  "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}

// Response
{
  "success": true,
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "message": "Token erneuert"
}
```

## 👤 Benutzer-Endpunkte

### Aktueller Benutzer
**GET** `/user/me`

```dart
// Headers
{
  "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}

// Response
{
  "id": 1,
  "username": "maxmustermann",
  "email": "max@example.com",
  "created_at": "2025-09-25T10:30:00.000Z",
  "updated_at": "2025-09-25T14:22:00.000Z"
}
```

### Profil aktualisieren
**PUT** `/user/profile`

```dart
// Request
{
  "email": "neuemail@example.com",
  "weight": 75.5,
  "height": 180.0,
  "age": 28,
  "gender": "male"
}

// Response
{
  "success": true,
  "user": {
    "id": 1,
    "username": "maxmustermann",
    "email": "neuemail@example.com"
  },
  "message": "Profil aktualisiert"
}
```

## 🏋️ Übungs-Endpunkte

### Alle Übungen
**GET** `/exercises`

```dart
// Query Parameters
?type=kraft&limit=50&offset=0

// Response
{
  "exercises": [
    {
      "id": 1,
      "name": "Bankdrücken",
      "type": "kraft",
      "muscle_groups": ["chest", "triceps"],
      "equipment": ["barbell", "bench"]
    }
  ],
  "total": 150,
  "page": 1,
  "limit": 50
}
```

### Neue Übung
**POST** `/exercises`

```dart
// Request
{
  "name": "Neue Übung",
  "type": "kraft",
  "muscle_groups": ["biceps"],
  "equipment": ["dumbbell"]
}

// Response
{
  "success": true,
  "exercise": {
    "id": 151,
    "name": "Neue Übung",
    "type": "kraft"
  }
}
```

## 📊 Trainings-Endpunkte

### Trainingseinheit starten
**POST** `/workouts/start`

```dart
// Request
{
  "workout_plan_id": 1, // optional
  "notes": "Heute Fokus auf Oberkörper"
}

// Response
{
  "success": true,
  "workout": {
    "id": 42,
    "user_id": 1,
    "start_time": "2025-09-25T16:00:00.000Z",
    "status": "active"
  }
}
```

### Satz hinzufügen
**POST** `/workouts/{workoutId}/sets`

```dart
// Request
{
  "exercise_id": 1,
  "reps": 12,
  "weight": 80.0,
  "set_number": 1
}

// Response
{
  "success": true,
  "set": {
    "id": 123,
    "exercise_id": 1,
    "reps": 12,
    "weight": 80.0,
    "timestamp": "2025-09-25T16:05:00.000Z"
  }
}
```

### Training beenden
**POST** `/workouts/{workoutId}/finish`

```dart
// Request
{
  "end_time": "2025-09-25T17:30:00.000Z",
  "notes": "Gutes Training!"
}

// Response
{
  "success": true,
  "workout": {
    "id": 42,
    "duration_minutes": 90,
    "total_sets": 15,
    "status": "completed"
  }
}
```

## 📈 Statistik-Endpunkte

### Fortschritt abrufen
**GET** `/statistics/progress`

```dart
// Query Parameters
?exercise_id=1&period=30d&type=weight

// Response
{
  "exercise": {
    "id": 1,
    "name": "Bankdrücken"
  },
  "progress": [
    {
      "date": "2025-09-01",
      "max_weight": 75.0,
      "total_reps": 36,
      "total_sets": 3
    }
  ],
  "trend": "increasing",
  "improvement": 5.2
}
```

## 🏥 Gesundheitsdaten

### Gewicht eintragen
**POST** `/health/weight`

```dart
// Request
{
  "weight": 75.5,
  "date": "2025-09-25",
  "notes": "Nach dem Training"
}

// Response
{
  "success": true,
  "entry": {
    "id": 45,
    "weight": 75.5,
    "date": "2025-09-25",
    "bmi": 23.2
  }
}
```

### Gewichtsverlauf
**GET** `/health/weight/history`

```dart
// Query Parameters
?from=2025-08-01&to=2025-09-25&limit=100

// Response
{
  "entries": [
    {
      "id": 45,
      "weight": 75.5,
      "date": "2025-09-25",
      "bmi": 23.2
    }
  ],
  "average": 76.1,
  "trend": "decreasing",
  "change": -1.3
}
```

## 🛠️ HTTP Client

### AuthService Methoden

```dart
class AuthService {
  // Sichere GET-Anfrage mit automatischem Token
  static Future<Map<String, dynamic>> secureGet(String endpoint);
  
  // Sichere POST-Anfrage mit automatischem Token
  static Future<Map<String, dynamic>> securePost(
    String endpoint, 
    Map<String, dynamic> data
  );
  
  // Sichere PUT-Anfrage mit automatischem Token
  static Future<Map<String, dynamic>> securePut(
    String endpoint, 
    Map<String, dynamic> data
  );
  
  // Sichere DELETE-Anfrage mit automatischem Token  
  static Future<Map<String, dynamic>> secureDelete(String endpoint);
}
```

### Error Handling

```dart
// Standard Error Response
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Ungültige Eingabedaten",
    "details": {
      "pin": "PIN muss 4 Ziffern haben"
    }
  }
}

// HTTP Status Codes
200 - OK
201 - Created  
400 - Bad Request (Validation Error)
401 - Unauthorized (Token invalid/expired)
403 - Forbidden (Access denied)
404 - Not Found
429 - Too Many Requests
500 - Internal Server Error
```

## 🚀 Development Mode

### Mock Responses
In Development Mode werden Fake-Daten zurückgegeben:

```dart
// Development Login Response
{
  "success": true,
  "token": "dev_token_eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9",
  "user": {
    "id": 1,
    "username": "dev_user",
    "email": "dev@example.com"
  },
  "message": "Development Login"
}
```

### API Mocking
```dart
if (Env.isDevelopment) {
  return _developmentLogin(username, pin);
} else {
  return _productionLogin(username, pin);
}
```

## 📋 Request/Response Standards

### Headers
```dart
{
  "Content-Type": "application/json",
  "Authorization": "Bearer {token}",
  "X-App-Version": "1.0.0",
  "X-Platform": "flutter",
  "Accept": "application/json"
}
```

### Pagination
```dart
// Request
?page=2&limit=20&sort=created_at&order=desc

// Response
{
  "data": [...],
  "pagination": {
    "current_page": 2,
    "total_pages": 15,
    "total_items": 300,
    "items_per_page": 20,
    "has_next": true,
    "has_previous": true
  }
}
```

### Timestamps
- Alle Zeitstempel in **UTC** im **ISO 8601** Format
- Format: `2025-09-25T16:30:00.000Z`
- Lokale Umwandlung im Frontend

## 🔧 Integration Guide

### 1. Service Setup
```dart
// Authentifizierung initialisieren
await AuthService.initializeAuth();

// Token prüfen
final isValid = await JwtService.isTokenValid();
```

### 2. API Call
```dart
// GET Request
final response = await AuthService.secureGet('/user/me');

// POST Request  
final response = await AuthService.securePost('/exercises', {
  'name': 'Neue Übung',
  'type': 'kraft'
});
```

### 3. Error Handling
```dart
try {
  final response = await AuthService.secureGet('/exercises');
  // Success handling
} catch (e) {
  if (e.toString().contains('401')) {
    // Token expired, redirect to login
    context.go('/login');
  } else {
    // Other error handling
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Fehler: $e'))
    );
  }
}
```