

// Direct database Connect



// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:mongo/database.dart';


// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(

//       debugShowCheckedModeBanner: false,
//       title: 'Mongo_DB',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const MyHomePage(title: 'Demo'),
//     );
//   }
// }


// Future<void> main() async {
//   await runZonedGuarded(() async {
//     WidgetsFlutterBinding.ensureInitialized();
    
//     // Attempt to connect to MongoDB
//     bool connected = await MongoDatabase.connect();
//     if (!connected) {
//       debugPrint("Failed to connect to MongoDB. App will start with limited functionality.");
//     }
    
//     runApp(const MyApp());
//   }, (error, stackTrace) {
//     debugPrint('Error in runZonedGuarded: $error');
//     debugPrint('Stack trace: $stackTrace');
//   });
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int counter = 0;
//   bool isDatabaseConnected = false;

//   @override
//   void initState() {
//     super.initState();
//     _checkDatabaseConnection();
//   }

//   Future<void> _checkDatabaseConnection() async {
//     bool connected = MongoDatabase.isConnected;
//     if (!connected) {
//       connected = await MongoDatabase.connect();
//     }
//     setState(() {
//       isDatabaseConnected = connected;
//     });
//   }

//   void incrementCounter() {
//     setState(() {
//       counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(widget.title),
//         centerTitle: true,
//         actions: [
//           Icon(
//             isDatabaseConnected ? Icons.cloud_done : Icons.cloud_off,
//             color: isDatabaseConnected ? Colors.green : Colors.red,
//           ),
//           const SizedBox(width: 16),
//         ],
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             if (!isDatabaseConnected)
//               const Card(
//                 color: Colors.orange,
//                 child: Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Text(
//                     'Database connection failed. Some features may be unavailable.',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ),
//             const SizedBox(height: 20),
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }






////// Button Connect



import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mongo/Routes/routes_list.dart';
import 'package:mongo/database.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        getPages: AppPages.pages,

      debugShowCheckedModeBanner: false,
      title: 'Mongo_DBx',
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
  bool isDatabaseConnected = false;

  Future<void> connectToDatabase() async {
    bool connected = await MongoDatabase.connect();
    setState(() {
      isDatabaseConnected = connected;
      Get.toNamed('/counterScreen');
    });
    if (!connected) {
      debugPrint("Failed to connect to MongoDB.");
    }
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
            isDatabaseConnected ? Icons.cloud_done : Icons.cloud_off,
            color: isDatabaseConnected ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Visibility(
              visible: !isDatabaseConnected,
              child: const Text('Press the button to connect to the database:')),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: connectToDatabase,
              child: Text(isDatabaseConnected ? 'Connected' : 'Press To Connect'),
            ),
            const SizedBox(height: 20),
            Text(
              isDatabaseConnected ? 'Connected to Database' : 'Not Connected',
              style: TextStyle(
                color: isDatabaseConnected ? Colors.green : Colors.red,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}