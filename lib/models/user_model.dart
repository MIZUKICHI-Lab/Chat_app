import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  String email;
  String name;
  String image;
  Timestamp date;
  String uid;

  UserModel(
      {this.id,
      required this.email,
      required this.name,
      required this.image,
      required this.date,
      required this.uid});

  factory UserModel.fromJson(DocumentSnapshot<Map<String, dynamic>> doc) {
    return UserModel(
      id: doc.id,
      email: doc.data()!['email'],
      name: doc.data()!['name'],
      image: doc.data()!['image'],
      date: doc.data()!['date'],
      uid: doc.data()!['uid'],
    );
  }
}
