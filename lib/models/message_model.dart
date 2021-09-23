import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String? id;
  final double? distance;
  final String? senderId;
  final String? message;
  final dynamic readStatus;
  final String? roomkey;
  final Timestamp? timestamp;

  Message({
    this.id,
    this.distance,
    this.senderId,
    this.message,
    this.readStatus,
    this.roomkey,
    this.timestamp,
  });

  factory Message.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Message(
      id: doc.id,
      distance: doc.data()!['distance'],
      senderId: doc.data()!['senderId'],
      message: doc.data()!['message'],
      readStatus: doc.data()!['readStatus'],
      roomkey: doc.data()!['roomkey'],
      timestamp: doc.data()!['timestamp'],
    );
  }
}
