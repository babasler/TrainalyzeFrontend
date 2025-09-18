# TrainalyzeFlutter

Eine Basis Flutter App für iOS und Desktop Plattformen.

## Übersicht

Diese Anwendung ist eine grundlegende Flutter-App, die für folgende Plattformen entwickelt wurde:
- **iOS** - iPhone und iPad
- **macOS** - Desktop-Anwendung für Mac
- **Windows** - Desktop-Anwendung für Windows
- **Linux** - Desktop-Anwendung für Linux

## Funktionen

- ✅ Multi-Platform Unterstützung (iOS, macOS, Windows, Linux)
- ✅ Deutsche Benutzeroberfläche
- ✅ Material Design 3
- ✅ Plattform-Informationen Anzeige
- ✅ Einfacher Counter als Demo-Funktionalität

## Voraussetzungen

- Flutter SDK (>=3.0.0)
- Dart SDK
- Für iOS: Xcode und iOS Simulator
- Für macOS: Xcode
- Für Windows: Visual Studio mit C++ Build Tools
- Für Linux: GTK development libraries

## Installation

1. Repository klonen:
   ```bash
   git clone https://github.com/babasler/TrainalyzeFlutter.git
   cd TrainalyzeFlutter
   ```

2. Dependencies installieren:
   ```bash
   flutter pub get
   ```

3. Flutter Doctor ausführen um Setup zu überprüfen:
   ```bash
   flutter doctor
   ```

## Ausführen der App

### iOS
```bash
flutter run -d ios
```

### macOS
```bash
flutter run -d macos
```

### Windows
```bash
flutter run -d windows
```

### Linux
```bash
flutter run -d linux
```

## Tests ausführen

```bash
flutter test
```

## Build für Production

### iOS
```bash
flutter build ios
```

### macOS
```bash
flutter build macos
```

### Windows
```bash
flutter build windows
```

### Linux
```bash
flutter build linux
```

## Projektstruktur

```
├── lib/
│   └── main.dart          # Haupt-App-Code
├── test/
│   └── widget_test.dart   # Widget Tests
├── ios/                   # iOS spezifische Konfiguration
├── macos/                 # macOS spezifische Konfiguration
├── windows/               # Windows spezifische Konfiguration
├── linux/                 # Linux spezifische Konfiguration
├── pubspec.yaml           # Dependencies und Metadaten
└── analysis_options.yaml  # Dart/Flutter Linter Konfiguration
```

## Beitragen

1. Fork das Repository
2. Erstelle einen Feature Branch (`git checkout -b feature/neue-funktion`)
3. Committe deine Änderungen (`git commit -am 'Neue Funktion hinzugefügt'`)
4. Push zu dem Branch (`git push origin feature/neue-funktion`)
5. Erstelle einen Pull Request

## Lizenz

Dieses Projekt steht unter der MIT Lizenz.