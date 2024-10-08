import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class MessageResponseModel {
  final String senderId;
  final String receiverId;
  final String message;
  final String timestamp;
  final String receiverName;
  final String senderName;
  MessageResponseModel({
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    required this.receiverName,
    required this.senderName,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'timeStamp': timestamp,
      'receiverName': receiverName,
      'senderName': senderName,
    };
  }

  factory MessageResponseModel.fromMap(Map<String, dynamic> map) {
    return MessageResponseModel(
      senderId: map['senderId'] as String,
      receiverId: map['receiverId'] as String,
      message: map['message'] as String,
      timestamp: map['timeStamp'] as String,
      receiverName: map['receiverName'] as String,
      senderName: map['senderName'] as String,
    );
  }

  factory MessageResponseModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) {
      throw Exception('Document data is null');
    }

    return MessageResponseModel(
      senderId: data['senderId']?.toString() ?? '', // Handle null case
      receiverId: data['receiverId']?.toString() ?? '', // Handle null case
      message: data['message']?.toString() ?? '', // Handle null case
      timestamp: data['timeStamp']?.toString() ?? '', // Handle null case
      receiverName: data['receiverName']?.toString() ?? '', // Handle null case
      senderName: data['senderName']?.toString() ?? '', // Handle null case
    );
  }

  static List<MessageResponseModel> fromQuerySnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return MessageResponseModel.fromFirestore(doc);
    }).toList();
  }

  String toJson() => json.encode(toMap());

  factory MessageResponseModel.fromJson(String source) =>
      MessageResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
