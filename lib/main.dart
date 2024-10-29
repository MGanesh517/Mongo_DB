import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mongo/database.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(

      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Demo'),
    );
  }
}


Future<void> main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    
    // Attempt to connect to MongoDB
    bool connected = await MongoDatabase.connect();
    if (!connected) {
      debugPrint("Failed to connect to MongoDB. App will start with limited functionality.");
    }
    
    runApp(const MyApp());
  }, (error, stackTrace) {
    debugPrint('Error in runZonedGuarded: $error');
    debugPrint('Stack trace: $stackTrace');
  });
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  bool _isDatabaseConnected = false;

  @override
  void initState() {
    super.initState();
    _checkDatabaseConnection();
  }

  Future<void> _checkDatabaseConnection() async {
    bool connected = MongoDatabase.isConnected;
    if (!connected) {
      connected = await MongoDatabase.connect();
    }
    setState(() {
      _isDatabaseConnected = connected;
    });
  }

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
        centerTitle: true,
        actions: [
          Icon(
            _isDatabaseConnected ? Icons.cloud_done : Icons.cloud_off,
            color: _isDatabaseConnected ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (!_isDatabaseConnected)
              const Card(
                color: Colors.orange,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Database connection failed. Some features may be unavailable.',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            const SizedBox(height: 20),
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
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
}