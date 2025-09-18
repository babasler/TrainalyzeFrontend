import 'package:flutter/material.dart';

void main() {
  runApp(const TrainalyzeApp());
}

class TrainalyzeApp extends StatelessWidget {
  const TrainalyzeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trainalyze Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(title: 'Trainalyze Flutter App'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Willkommen bei Trainalyze!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Eine Basis Flutter App für iOS und Desktop',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 40),
            const Text(
              'Sie haben den Button so oft gedrückt:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 40),
            _buildPlatformInfo(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildPlatformInfo() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Plattform Informationen:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Läuft auf: ${Theme.of(context).platform.name}'),
            const SizedBox(height: 5),
            const Text('Unterstützte Plattformen:'),
            const SizedBox(height: 5),
            const Wrap(
              spacing: 8,
              children: [
                Chip(label: Text('iOS')),
                Chip(label: Text('macOS')),
                Chip(label: Text('Windows')),
                Chip(label: Text('Linux')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}