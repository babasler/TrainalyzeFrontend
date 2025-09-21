import 'package:flutter/material.dart';
import 'router/router.dart';

void main() {
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
