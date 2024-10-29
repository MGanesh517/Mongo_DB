// import 'package:flutter/material.dart';
// import 'package:mongo/database.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({required Key key}) : super(key: key);

//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//         future: MongoDatabase.getDocuments(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Container(
//               color: Colors.white,
//               child: const LinearProgressIndicator(
//                 backgroundColor: Colors.black,
//               ),
//             );
//           } else {
//             if (snapshot.hasError) {
//               return Container(
//                 color: Colors.white,
//                 child: Center(
//                   child: Text(
//                     'Something went wrong, try again.',
//                     // style: Theme.of(context).textTheme.headline6,
//                   ),
//                 ),
//               );
//             } else {
//               return Scaffold(
//                 appBar: AppBar(
//                   title: Text('MongoDB Flutter'),
//                 ),
//                 body: ListView.builder(
//                   itemBuilder: (context, index) {
//                     return Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: UserCard(
//                         user: User.fromMap(snapshot.data[index]),
//                         onTapDelete: () async {
//                           _deleteUser(User.fromMap(snapshot.data[index]));
//                         },
//                         onTapEdit: () async {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (BuildContext context) {
//                                 return AddUserPage();
//                               },
//                               settings: RouteSettings(
//                                 arguments: User.fromMap(snapshot.data[index]),
//                               ),
//                             ),
//                           ).then((value) => setState(() {}));
//                         },
//                       ),
//                     );
//                   },
//                   itemCount: snapshot.data.length,
//                 ),
//                 floatingActionButton: FloatingActionButton(
//                   onPressed: () {
//                     Navigator.push(context,
//                         MaterialPageRoute(builder: (BuildContext context) {
//                       return AddUserPage();
//                     })).then((value) => setState(() {}));
//                   },
//                   child: Icon(Icons.add),
//                 ),
//               );
//             }
//           }
//         });
//   }

//   _deleteUser(User user) async {
//     await MongoDatabase.delete(user);
//     setState(() {});
//   }
// }