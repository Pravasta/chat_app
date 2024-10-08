import 'package:cloud_firestore/cloud_firestore.dart';

class ChatResponseModel {
  final String lastMessage;
  final String timestamp;
  final String senderName;
  final String senderId;
  final String receiverId;
  final String receiverName;

  ChatResponseModel({
    required this.lastMessage,
    required this.timestamp,
    required this.senderName,
    required this.senderId,
    required this.receiverId,
    required this.receiverName,
  });

  // Fungsi untuk mengonversi Firestore Document menjadi ChatResponseModel
  factory ChatResponseModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return ChatResponseModel(
      lastMessage: data['lastMessage'],
      timestamp: data['timestamp'], // Konversi Firestore Timestamp ke DateTime
      senderName: data['senderName'],
      senderId: data['senderId'],
      receiverId: data['receiverId'],
      receiverName: data['receiverName'],
    );
  }

  // Fungsi untuk mengonversi ChatResponseModel ke dalam Map untuk Firestore
  Map<String, dynamic> toMap() {
    return {
      'lastMessage': lastMessage,
      'timestamp': timestamp,
      'senderName': senderName,
      'senderId': senderId,
      'receiverId': receiverId,
      'receiverName': receiverName,
    };
  }
}
