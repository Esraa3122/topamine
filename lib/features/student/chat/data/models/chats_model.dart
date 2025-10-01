import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  Message({
    required this.message,
    required this.uId,
    required this.uName,
    required this.uEmail,
    required this.date,
    this.isRead = false,
    this.readAt,
  });

  factory Message.fromJson(Map<String, dynamic> jsonData) {
    return Message(
      message: jsonData['message'] as String,
      uId: jsonData['createdBy'] as String,
      uName: jsonData['name'] as String,
      uEmail: jsonData['emailUser'] as String,
      date: (jsonData['createdAt'] as Timestamp).millisecondsSinceEpoch,
      isRead: jsonData['isRead'] as bool? ?? false,
      readAt: jsonData['readAt'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'createdBy': uId,
      'name': uName,
      'emailUser': uEmail,
      'createdAt': Timestamp.fromMillisecondsSinceEpoch(date),
      'isRead': isRead,
      'readAt': readAt,
    };
  }

  final String message;
  final String uId;
  final String uName;
  final String uEmail;
  final int date;
  final bool isRead;
  final int? readAt;
}
