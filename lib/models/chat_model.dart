import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  String? id;
  String? name;
  String? imageUrl;
  List<dynamic>? memberId;
  dynamic memberInfo;
  dynamic readStatus;
  List<dynamic>? block;
  String? recentMessages;
  String? recentSender;
  Timestamp? recentTimestamp;
  bool? group;

  ChatModel({
    this.id,
    this.name,
    this.imageUrl,
    this.memberId,
    this.memberInfo,
    this.readStatus,
    this.block,
    this.recentMessages,
    this.recentSender,
    this.recentTimestamp,
    this.group,
  });

  factory ChatModel.fromJson(DocumentSnapshot<Map<String, dynamic>> doc) {
    return ChatModel(
      id: doc.id,
      name: doc.data()!['name'],
      imageUrl: doc.data()!['imageUrl'],
      memberId: doc.data()!['memberId'],
      memberInfo: doc.data()!['memberInfo'],
      readStatus: doc.data()!['readStatus'],
      block: doc.data()!['block'],
      recentMessages: doc.data()!['recentMessage'],
      recentSender: doc.data()!['recentSender'],
      recentTimestamp: doc.data()!['recentTimestamp'],
      group: doc.data()!['group'],
    );
  }
}
