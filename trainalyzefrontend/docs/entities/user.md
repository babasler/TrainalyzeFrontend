# User Entity

Das User-Entity repräsentiert einen Benutzer in der Trainalyze-App.

## 📋 Datenfelder

### Hauptklasse: `User`

| Feld | Typ | Required | Beschreibung |
|------|-----|----------|--------------|
| `id` | `int?` | ❌ | Eindeutige Benutzer-ID (auto-increment) |
| `username` | `String` | ✅ | Eindeutiger Benutzername für Login |
| `email` | `String?` | ❌ | E-Mail-Adresse (optional) |
| `createdAt` | `DateTime?` | ❌ | Zeitpunkt der Registrierung |
| `updatedAt` | `DateTime?` | ❌ | Zeitpunkt der letzten Aktualisierung |

### Zusatzklassen

#### `LoginRequest`
Login-Daten für Authentifizierung

| Feld | Typ | Required | Beschreibung |
|------|-----|----------|--------------|
| `username` | `String` | ✅ | Benutzername |
| `pin` | `String` | ✅ | 4-stellige PIN |

#### `RegisterRequest`
Registrierungsdaten für neue Benutzer

| Feld | Typ | Required | Beschreibung |
|------|-----|----------|--------------|
| `username` | `String` | ✅ | Gewünschter Benutzername |
| `pin` | `String` | ✅ | 4-stellige PIN |
| `email` | `String?` | ❌ | Optionale E-Mail-Adresse |

#### `AuthResponse`
Antwort nach Login/Registrierung

| Feld | Typ | Required | Beschreibung |
|------|-----|----------|--------------|
| `success` | `bool` | ✅ | Status der Authentifizierung |
| `token` | `String?` | ❌ | JWT-Token bei erfolgreichem Login |
| `user` | `User?` | ❌ | Benutzer-Objekt bei Erfolg |
| `message` | `String?` | ❌ | Fehler- oder Erfolgsmeldung |

## 🔧 Methoden

### `User`
- `fromJson(Map<String, dynamic> json)` - JSON zu User-Objekt
- `toJson()` - User-Objekt zu JSON
- `copyWith({...})` - Erstellt Kopie mit geänderten Feldern
- `toString()` - String-Repräsentation
- `operator ==` - Gleichheitsvergleich
- `hashCode` - Hash-Funktion

## 💾 JSON-Format

### User-Objekt
```json
{
  "id": 1,
  "username": "maxmustermann",
  "email": "max@example.com",
  "created_at": "2025-09-25T10:30:00.000Z",
  "updated_at": "2025-09-25T14:22:00.000Z"
}
```

### Login-Request
```json
{
  "username": "maxmustermann",
  "pin": "1234"
}
```

### Auth-Response
```json
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

## 🔒 Sicherheit

- **PIN**: 4-stellig, numerisch
- **JWT-Token**: Enthält Benutzer-ID und Ablaufzeit
- **Passwort-Hash**: Server-seitig mit bcrypt
- **Token-Validation**: Automatische Ablaufprüfung

## 📱 Verwendung in der App

```dart
// Login
final loginRequest = LoginRequest(
  username: 'maxmustermann',
  pin: '1234',
);

// User erstellen
final user = User(
  username: 'maxmustermann',
  email: 'max@example.com',
);

// JSON-Verarbeitung
final userJson = user.toJson();
final userFromJson = User.fromJson(jsonData);
```