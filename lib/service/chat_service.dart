import 'package:chat_app/models/request/message_request_model.dart';
import 'package:chat_app/models/response/chat_response_model.dart';
import 'package:chat_app/models/response/message_response_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class ChatService {
  Future<Either<String, void>> sendMessage(MessageRequestModel message);
  Stream<List<MessageResponseModel>> getMessage(
      String senderId, String receiverId);
  Stream<List<ChatResponseModel>> fetchChatSessions();
  Future<void> updateLastMessage(String senderId, String receiverId,
      String message, String receiverName, String senderName);
}

class ChatServiceImpl implements ChatService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  ChatServiceImpl({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  })  : _firestore = firestore,
        _auth = auth;

  @override
  Future<Either<String, void>> sendMessage(MessageRequestModel message) async {
    try {
      final currentUser = _auth.currentUser!;

      List<String> ids = [currentUser.uid, message.receiverId];
      ids.sort();
      String chatRoomId = ids.join('_');

      final newMessage = MessageResponseModel(
        senderId: currentUser.uid,
        receiverId: message.receiverId,
        receiverName: message.receiverName,
        senderName: message.senderName,
        message: message.message,
        timestamp: DateTime.now().toIso8601String(),
      );

      await _firestore
          .collection('chat_sessions')
          .doc(chatRoomId)
          .collection('messages')
          .add(newMessage.toMap());

      // Update atau buat dokumen lastMessage di list_messages sender
      await updateLastMessage(currentUser.uid, message.receiverId,
          newMessage.message, message.senderName, message.receiverName);

      // Update atau buat dokumen lastMessage di list_messages receiver
      await updateLastMessage(message.receiverId, currentUser.uid,
          newMessage.message, message.receiverName, message.senderName);

      return const Right(null);
    } catch (e) {
      throw Left(e.toString());
    }
  }

  @override
  Stream<List<ChatResponseModel>> fetchChatSessions() {
    try {
      final currentUserId = _auth.currentUser!.uid;

      final getCollectionChat = _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('list_messages')
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) {
                return ChatResponseModel.fromFirestore(doc);
              }).toList());

      return getCollectionChat;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<void> updateLastMessage(String senderId, String receiverId,
      String message, String receiverName, String senderName) async {
    // Cek apakah dokumen lastMessage sudah ada
    var lastMessageSnapshot = await _firestore
        .collection('users')
        .doc(senderId)
        .collection('list_messages')
        .doc(receiverId)
        .get();

    // Jika dokumen belum ada, buat dokumen baru
    if (!lastMessageSnapshot.exists) {
      await _firestore
          .collection('users')
          .doc(senderId)
          .collection('list_messages')
          .doc(receiverId)
          .set({
        'receiverId': receiverId,
        'receiverName': receiverName,
        'senderId': senderId,
        'senderName': senderName,
        'lastMessage': message,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } else {
      // Jika dokumen sudah ada, update lastMessage dan timestamp
      await _firestore
          .collection('users')
          .doc(senderId)
          .collection('list_messages')
          .doc(receiverId)
          .update({
        'lastMessage': message,
        'timestamp': DateTime.now().toIso8601String(),
      });
    }
  }

  @override
  Stream<List<MessageResponseModel>> getMessage(
      String senderId, String receiverId) {
    try {
      List<String> ids = [senderId, receiverId];
      ids.sort();
      String chatRoomId = ids.join('_');

      final data = _firestore
          .collection('chat_sessions')
          .doc(chatRoomId)
          .collection('messages')
          .orderBy('timeStamp', descending: false)
          .snapshots();

      return data.map((snapshot) {
        return snapshot.docs.map((doc) {
          return MessageResponseModel.fromFirestore(doc);
        }).toList();
      });
    } catch (e) {
      throw e.toString();
    }
  }

  factory ChatServiceImpl.create() {
    return ChatServiceImpl(
      firestore: FirebaseFirestore.instance,
      auth: FirebaseAuth.instance,
    );
  }
}
