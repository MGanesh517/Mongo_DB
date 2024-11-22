// // counter_model.dart
// import 'package:mongo_dart/mongo_dart.dart';

// class Counter {
//   final ObjectId id;
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










import 'package:flutter/material.dart';
import 'package:mongo/database.dart'; // Replace with your own MongoDB connection details
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  _CounterPageState createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  List<Map<String, dynamic>> _userList = []; // List to store retrieved users

  @override
  void initState() {
    super.initState();
    retrieveUsers(); // Retrieve users when the page loads
  }

  // Function to insert login details into the database
  Future<void> submitLogin() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    var db = await mongo.Db.create(MONGO_CONN_URL);
    await db.open();

    var usersCollection = db.collection(USER_COLLECTION);

    await usersCollection.insertOne({
      'username': username,
      'password': password, // For security, don't store passwords as plain text (hash them).
      'timestamp': DateTime.now().toIso8601String(),
    });

    await db.close();

    // Clear the text fields and give feedback
    _usernameController.clear();
    _passwordController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Login details saved!')),
    );

    // After inserting, retrieve updated data
    retrieveUsers();
  }

  // Function to retrieve users from the database
  Future<void> retrieveUsers() async {
    var db = await mongo.Db.create(MONGO_CONN_URL);
    await db.open();

    var usersCollection = db.collection(USER_COLLECTION);

    // Fetch all users from the collection
    var users = await usersCollection.find().toList();

    setState(() {
      _userList = users;
    });

    await db.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: submitLogin,
                child: const Text('Submit'),
              ),
              const SizedBox(height: 32),
              const Text('Retrieved Users:'),
              Expanded(
                child: _userList.isEmpty
                    ? const Center(child: Text('No users found.'))
                    : ListView.builder(
                        itemCount: _userList.length,
                        itemBuilder: (context, index) {
                          final user = _userList[index];
                          return ListTile(
                            title: Text(user['username'] ?? 'Unknown'),
                            subtitle: Text(user['timestamp'] ?? 'No timestamp'),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




//
// import 'dart:async';
// import 'dart:developer';
//
// import 'package:notification_listener_service/notification_event.dart';
// import 'package:notification_listener_service/notification_listener_service.dart';

//
// class CounterPage extends StatefulWidget {
//   const CounterPage({super.key});
//
//   @override
//   State<CounterPage> createState() => _CounterPageState();
// }
//
// class _CounterPageState extends State<CounterPage> {
//   StreamSubscription<ServiceNotificationEvent>? _subscription;
//   List<ServiceNotificationEvent> events = [];
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           // title: const Text('Plugin example app'),
//         ),
//         body: Center(
//           child: Column(
//             children: [
//               SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     TextButton(
//                       onPressed: () async {
//                         final res = await NotificationListenerService
//                             .requestPermission();
//                         log("Is enabled: $res");
//                       },
//                       child: const Text("Request Permission"),
//                     ),
//                     const SizedBox(height: 20.0),
//                     TextButton(
//                       onPressed: () async {
//                         final bool res = await NotificationListenerService
//                             .isPermissionGranted();
//                         log("Is enabled: $res");
//                       },
//                       child: const Text("Check Permission"),
//                     ),
//                     const SizedBox(height: 20.0),
//                     TextButton(
//                       onPressed: () {
//                         _subscription = NotificationListenerService
//                             .notificationsStream
//                             .listen((event) {
//                           log("$event");
//                           setState(() {
//                             events.add(event);
//                           });
//                         });
//                       },
//                       child: const Text("Start Stream"),
//                     ),
//                     const SizedBox(height: 20.0),
//                     TextButton(
//                       onPressed: () {
//                         _subscription?.cancel();
//                       },
//                       child: const Text("Stop Stream"),
//                     ),
//                   ],
//                 ),
//               ),
//               Expanded(
//                 child: ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: events.length,
//                   itemBuilder: (_, index) => Padding(
//                     padding: const EdgeInsets.only(bottom: 8.0),
//                     child: ListTile(
//                       onTap: () async {
//                         try {
//                           await events[index]
//                               .sendReply("This is an auto response");
//                         } catch (e) {
//                           log(e.toString());
//                         }
//                       },
//                       trailing: events[index].hasRemoved!
//                           ? const Text(
//                               "Removed",
//                               style: TextStyle(color: Colors.red),
//                             )
//                           : const SizedBox.shrink(),
//                       leading: events[index].appIcon == null
//                           ? const SizedBox.shrink()
//                           : Image.memory(
//                               events[index].appIcon!,
//                               width: 35.0,
//                               height: 35.0,
//                             ),
//                       title: Text(events[index].title ?? "No title"),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             events[index].content ?? "no content",
//                             style: const TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                           const SizedBox(height: 8.0),
//                           events[index].canReply!
//                               ? const Text(
//                                   "Replied with: This is an auto reply",
//                                   style: TextStyle(color: Colors.purple),
//                                 )
//                               : const SizedBox.shrink(),
//                           events[index].largeIcon != null
//                               ? Image.memory(
//                                   events[index].largeIcon!,
//                                 )
//                               : const SizedBox.shrink(),
//                         ],
//                       ),
//                       isThreeLine: true,
//                     ),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       );
//
//   }
// }