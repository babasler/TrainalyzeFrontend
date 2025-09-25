import 'package:flutter/material.dart';
import 'router/router.dart';
import 'enviroment/env.dart';
import 'services/jwt_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Im Development-Modus: Token beim App-Start löschen für frischen Login
  if (AppConfig.isDevelopmentMode) {
    await JwtService.deleteToken();
    print('🔄 Dev-Modus: Gespeicherte Tokens gelöscht - frischer Start!');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter.router,
      title: 'Trainalyze',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.deepPurple),
    );
  }
}
