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