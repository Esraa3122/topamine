import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  Message(this.message, this.uId, this.uName, this.uEmail, this.date);

  factory Message.fromJson(Map<String, dynamic> jsonData) {
    return Message(
      jsonData['message'] as String,
      jsonData['createdBy'] as String,
      jsonData['name'] as String,
      jsonData['emailUser'] as String,
      (jsonData['createdAt'] as Timestamp).millisecondsSinceEpoch,
    );
  }

  final String message;
  final String uId;
  final String uName;
  final String uEmail;
  final int date;
}
