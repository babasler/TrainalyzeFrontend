# Exercise Entity

Das Exercise-Entity repräsentiert eine Trainingsübung in der Trainalyze-App.

## 📋 Datenfelder

### Hauptklasse: `Exercise`

| Feld | Typ | Required | Beschreibung |
|------|-----|----------|--------------|
| `name` | `String` | ✅ | Name der Übung (z.B. "Bankdrücken", "Kniebeugen") |
| `type` | `ExerciseType` | ✅ | Art der Übung (siehe Enum unten) |

### Enums

#### `ExerciseType`
Kategorisierung der Übungsarten

| Wert | Beschreibung |
|------|--------------|
| `kraft` | Krafttraining (Gewichte, Widerstand) |
| `cardio` | Ausdauertraining (Laufen, Fahrrad) |
| `mobility` | Beweglichkeit/Flexibilität (Stretching, Yoga) |

#### `MuscleSymmetry`
Symmetrie der Muskelbeanspruchung

| Wert | Beschreibung |
|------|--------------|
| `unilateral` | Einseitig (linke/rechte Seite getrennt) |
| `bilateral` | Beidseitig (beide Seiten gleichzeitig) |

## 🎯 Übungstypen im Detail

### `kraft` - Krafttraining
- **Beispiele**: Bankdrücken, Kniebeugen, Kreuzheben, Bizeps-Curls
- **Merkmale**: Verwendung von Gewichten, Widerstandsbändern
- **Ziel**: Muskelaufbau, Kraftsteigerung

### `cardio` - Ausdauertraining  
- **Beispiele**: Laufen, Radfahren, Rudern, Schwimmen
- **Merkmale**: Erhöhte Herzfrequenz, längere Dauer
- **Ziel**: Herz-Kreislauf-Fitness, Fettverbrennung

### `mobility` - Beweglichkeit
- **Beispiele**: Stretching, Yoga, Pilates, Foam Rolling
- **Merkmale**: Dehnung, Bewegungsumfang
- **Ziel**: Flexibilität, Verletzungsprävention

### `unilateral` - Einseitige Übungen
- **Beispiele**: Einbeinige Kniebeugen, einseitiges Kreuzheben
- **Merkmale**: Fokus auf eine Körperseite
- **Ziel**: Balance, Symmetrie-Korrektur

## 💾 JSON-Format

```json
{
  "name": "Bankdrücken",
  "type": "kraft"
}
```

## 📱 Verwendung in der App

```dart
// Kraft-Übung erstellen
final benchPress = Exercise(
  name: 'Bankdrücken',
  type: ExerciseType.kraft,
);

// Cardio-Übung erstellen
final running = Exercise(
  name: 'Laufen',
  type: ExerciseType.cardio,
);

// Mobility-Übung erstellen
final stretching = Exercise(
  name: 'Hamstring Stretch',
  type: ExerciseType.mobility,
);
```

## 🔮 Geplante Erweiterungen

Das Exercise-Entity ist aktuell minimal gehalten. Geplante Erweiterungen:

### Zusätzliche Felder
- `id` - Eindeutige Übungs-ID
- `description` - Beschreibung der Übung
- `muscleGroups` - Beanspruchte Muskelgruppen
- `equipment` - Benötigte Ausrüstung
- `difficulty` - Schwierigkeitsgrad
- `instructions` - Ausführungsanweisungen
- `imageUrl` - Bild/GIF der Übung
- `videoUrl` - Video-Anleitung

### Erweiterte Kategorisierung
- `primaryMuscles` - Hauptmuskelgruppen
- `secondaryMuscles` - Unterstützende Muskeln  
- `equipmentNeeded` - Liste der Geräte
- `modifications` - Übungsvariationen

### Tracking-Felder
- `lastPerformed` - Letzte Ausführung
- `personalBest` - Persönliche Bestleistung
- `averageWeight` - Durchschnittsgewicht
- `totalSets` - Gesamte Sätze
- `totalReps` - Gesamte Wiederholungen

## 📊 Verwendung in Trainingsplänen

```dart
// Beispiel für erweiterte Verwendung (geplant)
final workout = [
  Exercise(name: 'Bankdrücken', type: ExerciseType.kraft),
  Exercise(name: 'Kniebeugen', type: ExerciseType.kraft),
  Exercise(name: 'Laufen', type: ExerciseType.cardio),
];

// Filtern nach Typ
final kraftUebungen = workout
  .where((exercise) => exercise.type == ExerciseType.kraft)
  .toList();
```