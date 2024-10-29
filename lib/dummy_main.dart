// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:mongo_dart/mongo_dart.dart' as mongo;


// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(

//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const MyHomePage(title: 'Demo'),
//     );
//   }
// }


// class Counter {
//   final mongo.ObjectId id;
//   final int count;
//   final DateTime timestamp;

//   Counter({
//     required this.id,
//     required this.count,
//     required this.timestamp,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       '_id': id,
//       'count': count,
//       'timestamp': timestamp,
//     };
//   }

//   factory Counter.fromMap(Map<String, dynamic> map) {
//     return Counter(
//       id: map['_id'],
//       count: map['count'],
//       timestamp: map['timestamp'],
//     );
//   }
// }


// const MONGO_CONN_URL = "mongodb+srv://ganeshabsolin517:Ganesh.517@cluster0.s95ts.mongodb.net/Mongo_DB";
// const USER_COLLECTION = "users";

// class MongoDatabase {
//   static var db, userCollection, counterCollection;
//   static bool isConnected = false;

//   static Future<bool> connect() async {
//     try {
//       debugPrint("Attempting to connect to MongoDB...");
//       db = await mongo.Db.create(MONGO_CONN_URL);
//       await db.open();
//       userCollection = db.collection(USER_COLLECTION);
//       counterCollection = db.collection('counters');
//       isConnected = true;
//       debugPrint("Successfully connected to MongoDB");
//       return true;
//     } catch (e) {
//       debugPrint("Error connecting to MongoDB: $e");
//       isConnected = false;
//       return false;
//     }
//   }

//   static Future<bool> saveCounter(int count) async {
//     try {
//       if (!isConnected) {
//         await connect();
//       }
//       final counter = Counter(
//         id: mongo.ObjectId(),
//         count: count,
//         timestamp: DateTime.now(),
//       );
//       await counterCollection.insertOne(counter.toMap());
//       debugPrint("Successfully saved counter: $count");
//       return true;
//     } catch (e) {
//       debugPrint("Error saving counter: $e");
//       return false;
//     }
//   }

//   static Future<List<Counter>> getCounterHistory() async {
//     try {
//       if (!isConnected) {
//         await connect();
//       }
//       final counters = await counterCollection
//           .find()
//           .sortBy('timestamp', descending: true)
//           .toList();
//       return counters.map((doc) => Counter.fromMap(doc)).toList();
//     } catch (e) {
//       debugPrint("Error fetching counter history: $e");
//       return [];
//     }
//   }
// }


// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//   bool _isDatabaseConnected = false;
//   bool _isSaving = false;

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
//       _isDatabaseConnected = connected;
//     });
//   }

//   Future<void> _incrementCounter() async {
//     setState(() {
//       _counter++;
//       _isSaving = true;
//     });

//     if (_isDatabaseConnected) {
//       await MongoDatabase.saveCounter(_counter);
//     }

//     setState(() {
//       _isSaving = false;
//     });
//   }

//   Future<void> _showCounterHistory() async {
//     if (!_isDatabaseConnected) {
//       Get.snackbar(
//         'Error',
//         'Database not connected',
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       return;
//     }

//     final counters = await MongoDatabase.getCounterHistory();

//     Get.bottomSheet(
//       Container(
//         height: MediaQuery.of(context).size.height / 2,
//         decoration: BoxDecoration(
//           color: Theme.of(context).scaffoldBackgroundColor,
//           borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
//         ),
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               'Counter History',
//               style: Theme.of(context).textTheme.titleLarge,
//             ),
//             const SizedBox(height: 16),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: counters.length,
//                 itemBuilder: (context, index) {
//                   final counter = counters[index];
//                   return Card(
//                     child: ListTile(
//                       leading: CircleAvatar(
//                         child: Text('${counter.count}'),
//                       ),
//                       title: Text(
//                         'Count: ${counter.count}',
//                         style: const TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       subtitle: Text(
//                         'Time: ${DateFormat('MMM dd, yyyy HH:mm:ss').format(counter.timestamp)}',
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//     );
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
//             _isDatabaseConnected ? Icons.cloud_done : Icons.cloud_off,
//             color: _isDatabaseConnected ? Colors.green : Colors.red,
//           ),
//           const SizedBox(width: 16),
//         ],
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             if (!_isDatabaseConnected)
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
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton.icon(
//               onPressed: _showCounterHistory,
//               icon: const Icon(Icons.history),
//               label: const Text('View History'),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _isSaving ? null : _incrementCounter,
//         tooltip: 'Increment',
//         child: _isSaving
//             ? const SizedBox(
//                 width: 24,
//                 height: 24,
//                 child: CircularProgressIndicator(strokeWidth: 2),
//               )
//             : const Icon(Icons.add),
//       ),
//     );
//   }
// }