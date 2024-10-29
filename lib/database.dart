import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';




class MongoDatabase {
  static var db, userCollection;
  static bool isConnected = false;

  static Future<bool> connect() async {
    try {
      debugPrint("Attempting to connect to MongoDB...");
      db = await Db.create(MONGO_CONN_URL);
      await db.open();
      userCollection = db.collection(USER_COLLECTION);
      isConnected = true;
      debugPrint("Successfully connected to MongoDB");
      return true;
    } catch (e) {
      debugPrint("Error connecting to MongoDB: $e");
      isConnected = false;
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> getDocuments() async {
    try {
      if (!isConnected) {
        debugPrint("Warning: Database not connected. Attempting to reconnect...");
        await connect();
      }
      final users = await userCollection.find().toList();
      debugPrint("Retrieved ${users.length} documents");
      return users;
    } catch (e) {
      debugPrint("Error fetching documents: $e");
      return [];
    }
  }

  static Future<bool> insert(User user) async {
    try {
      if (!isConnected) {
        await connect();
      }
      await userCollection.insertAll([user.toMap()]);
      debugPrint("Successfully inserted user: ${user.name}");
      return true;
    } catch (e) {
      debugPrint("Error inserting user: $e");
      return false;
    }
  }

  static Future<bool> update(User user) async {
    try {
      if (!isConnected) {
        await connect();
      }
      var u = await userCollection.findOne({"_id": user.id});
      if (u == null) {
        debugPrint("User not found for update: ${user.id}");
        return false;
      }
      u["name"] = user.name;
      u["age"] = user.age;
      u["phone"] = user.phone;
      await userCollection.save(u);
      debugPrint("Successfully updated user: ${user.name}");
      return true;
    } catch (e) {
      debugPrint("Error updating user: $e");
      return false;
    }
  }

  static Future<bool> delete(User user) async {
    try {
      if (!isConnected) {
        await connect();
      }
      await userCollection.remove(where.id(user.id));
      debugPrint("Successfully deleted user: ${user.name}");
      return true;
    } catch (e) {
      debugPrint("Error deleting user: $e");
      return false;
    }
  }
}

class UserCard extends StatelessWidget {
  UserCard({required this.user, required this.onTapDelete, required this.onTapEdit});
  final User user;
  final GestureTapCallback onTapEdit, onTapDelete;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2.0,
      color: Colors.white,
      child: ListTile(
        leading: Text(
          '${user.age}',
          // style: Theme.of(context).textTheme.headline6,
        ),
        title: Text(user.name),
        subtitle: Text('${user.phone}'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              child: Icon(Icons.edit),
              onTap: onTapEdit,
            ),
            GestureDetector(
              child: Icon(Icons.delete),
              onTap: onTapDelete,
            ),
          ],
        ),
      ),
    );
  }
}


const MONGO_CONN_URL = "mongodb+srv://ganeshabsolin517:Ganesh.517@cluster0.s95ts.mongodb.net/Mongo_DB";
const USER_COLLECTION = "users";

class User {
  final ObjectId id;
  final String name;
  final int age;
  final int phone;

  const User({required this.id, required this.name, required this.age, required this.phone});

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'age': age,
      'phone': phone,
    };
  }

  User.fromMap(Map<String, dynamic> map)
      : name = map['name'],
        id = map['_id'],
        age = map['age'],
        phone = map['phone'];
}