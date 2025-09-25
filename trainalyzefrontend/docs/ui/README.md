# UI Components - Dokumentation

Diese Dokumentation beschreibt die UI-Komponenten und das Design-System der Trainalyze-App.

## 🎨 Design-System

### Farbschema (AppColors)

```dart
class AppColors {
  static const Color primary = Color(0xFF9C27B0);      // Lila
  static const Color background = Color(0xFF121212);    // Dunkelgrau
  static const Color surface = Color(0xFF1E1E1E);      // Oberflächen
  static const Color textPrimary = Color(0xFFFFFFFF);  // Weiß
  static const Color textSecondary = Color(0xB3FFFFFF); // Semi-transparent Weiß
}
```

### Responsive Design (AppResponsive)

```dart
class AppResponsive {
  static DeviceType getDeviceType(BuildContext context);
  static double getSidebarWidth(BuildContext context);
  static double getLogoSize(BuildContext context);
  static bool shouldUseCompactSidebar(BuildContext context);
}
```

## 📱 Komponenten-Übersicht

| Komponente | Status | Beschreibung | Dokumentation |
|------------|--------|--------------|---------------|
| [PinInput](./components/pin-input.md) | ✅ | 4-stellige PIN-Eingabe | [pin-input.md](./components/pin-input.md) |
| [Sidebar](./components/sidebar.md) | ✅ | Responsive Navigation | [sidebar.md](./components/sidebar.md) |
| [InformationChart](./components/information-chart.md) | ✅ | Dashboard-Diagramme | [information-chart.md](./components/information-chart.md) |
| [ProfileCard](./components/profile-card.md) | ✅ | Benutzerprofile | [profile-card.md](./components/profile-card.md) |

## 🎭 Seiten-Komponenten

### Authentifizierung
- **LoginPage** - Benutzeranmeldung mit PIN
- **RegisterPage** - Benutzerregistrierung

### Dashboard
- **DashboardPage** - Hauptübersicht
- **StatisticsPage** - Trainingsstatistiken

### Training
- **NewWorkoutPage** - Neues Training erstellen
- **InTrainingPage** - Aktives Training
- **NewExercisePage** - Neue Übung hinzufügen
- **NewPlanPage** - Trainingsplan erstellen

### Profil
- **ProfilePage** - Benutzereinstellungen und Körperdaten

## 🧩 Widget-Hierarchie

```
MaterialApp
├── GoRouter
│   ├── LayoutPage (Wrapper)
│   │   ├── Sidebar (Navigation)
│   │   └── Body (Content)
│   │       ├── DashboardPage
│   │       ├── ProfilePage
│   │       ├── StatisticsPage
│   │       └── ...
│   ├── LoginPage (Standalone)
│   └── RegisterPage (Standalone)
```

## 🎨 Design-Prinzipien

### Material Design 3
- **Adaptive Design** - Responsive für alle Bildschirmgrößen
- **Dark Theme** - Dunkles Design als Standard
- **Purple Accent** - Lila als Primärfarbe
- **Consistent Spacing** - 8px Grid-System

### Accessibility
- **Kontrast** - WCAG 2.1 AA konform
- **Touch Targets** - Mindestens 48px
- **Screen Reader** - Semantically korrekte Labels
- **Keyboard Navigation** - Tab-Order optimiert

### Animation
- **Material Motion** - Smooth Transitions
- **Loading States** - Progress Indicators
- **Micro-interactions** - Button Feedback
- **Page Transitions** - Slide/Fade Effekte

## 📐 Layout-Breakpoints

| Breakpoint | Breite | Device | Sidebar | Layout |
|------------|--------|--------|---------|---------|
| **Compact** | < 600px | Phone | Hidden | Stack |
| **Medium** | 600-840px | Tablet Portrait | Drawer | Stack |
| **Expanded** | > 840px | Tablet/Desktop | Fixed | Row |

## 🎪 Beispiel-Widgets

### Custom Button
```dart
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  onPressed: onPressed,
  child: Text('Button Text'),
)
```

### Card Container
```dart
Container(
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: AppColors.primary.withOpacity(0.3),
    ),
  ),
  child: child,
)
```

### Input Field
```dart
TextField(
  style: TextStyle(color: AppColors.textPrimary),
  decoration: InputDecoration(
    labelText: 'Label',
    labelStyle: TextStyle(color: AppColors.textSecondary),
    border: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.primary),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.primary, width: 2),
    ),
  ),
)
```

## 🔧 Development Guidelines

### Widget-Erstellung
1. **Single Responsibility** - Ein Widget, eine Aufgabe
2. **Composition over Inheritance** - Widgets kombinieren
3. **Immutable** - StatelessWidget bevorzugen
4. **Performance** - const Konstruktoren nutzen

### Styling
1. **Theme-basiert** - AppColors verwenden
2. **Responsive** - AppResponsive nutzen
3. **Consistent** - Wiederverwendbare Styles
4. **Accessible** - Labels und Semantics

### Testing
1. **Widget Tests** - UI-Logik testen
2. **Golden Tests** - Visuelle Regression
3. **Integration Tests** - User Flows
4. **Accessibility Tests** - Screen Reader kompatibel

## 📋 Component Checklist

Für jede neue UI-Komponente:

- [ ] Design-System konform (AppColors)
- [ ] Responsive (AppResponsive)
- [ ] Accessible (Semantics, Labels)
- [ ] Material 3 Guidelines
- [ ] Performance optimiert (const)
- [ ] Widget Tests
- [ ] Dokumentation
- [ ] Storybook/Demo
- [ ] Dark Mode kompatibel
- [ ] Animation/Transition

## 🚀 Kommende Features

### Geplante Komponenten
- **ExerciseCard** - Übungsanzeige
- **WorkoutTimer** - Timer für Trainings
- **ProgressChart** - Fortschrittsanzeige
- **ExerciseSelector** - Übungsauswahl
- **WeightPicker** - Gewichts-Eingabe
- **RepsPicker** - Wiederholungs-Eingabe

### Design-Updates
- **Light Theme** - Heller Modus optional
- **Custom Icons** - Trainalyze-spezifische Icons
- **Animation Library** - Erweiterte Animationen
- **Component Library** - Storybook Integration