import 'dart:convert';

import 'package:chat_app/core/constant/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;

abstract class NotificationService {
  Future<String> getAccessToken();
  Future<Either<String, String>> sendNotificationToSelectedUser(
      String receiverId, String message);
  Future showNotification(
      {int id = 0, String? title, String? body, String? payLoad});
  Future<void> firebaseBackgroundHandler(RemoteMessage message);
  Future<void> initialized();
}

class NotificationServiceImpl implements NotificationService {
  final http.Client _client;
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  NotificationServiceImpl({
    required http.Client client,
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
  })  : _client = client,
        _auth = auth,
        _firestore = firestore;

  @override
  Future<String> getAccessToken() async {
    List<String> scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
    ];

    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(Variable.serviceAccountJson),
      scopes,
    );

    // get access token
    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(Variable.serviceAccountJson),
      scopes,
      client,
    );

    client.close();

    return credentials.accessToken.data;
  }

  @override
  Future<void> initialized() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    const initializationSettingsAndroid = AndroidInitializationSettings('logo');
    final initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {
          // showNotification(id: id, title: title, body: body, payLoad: payload);
        });

    final initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {});

    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((message) {
      print(message.notification?.body);
      print(message.notification?.title);
    });

    FirebaseMessaging.onMessage.listen(firebaseBackgroundHandler);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(firebaseBackgroundHandler);
  }

  @override
  Future showNotification(
      {int id = 0, String? title, String? body, String? payLoad}) async {
    return flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails('com.pravasta.chat_app', 'app',
            importance: Importance.max),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  @override
  Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
    showNotification(
      title: message.notification!.title,
      body: message.notification!.body,
    );
  }

  @override
  Future<Either<String, String>> sendNotificationToSelectedUser(
    String receiverId,
    String message,
  ) async {
    try {
      final String serverKey = await getAccessToken();
      String endpointFirebaseMessaging =
          'https://fcm.googleapis.com/v1/projects/chat-app-b182e/messages:send';

      final otherUser =
          await _firestore.collection('users').doc(receiverId).get();
      final currentUser = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();

      final String token = otherUser['fcm_token'];
      print('Token Other : $token');

      final Map<String, dynamic> messages = {
        'message': {
          'token': token,
          'notification': {
            "title": currentUser['name'],
            "body": message,
          },
          'data': {
            "sender_id": currentUser['uid'], // ID pengirim
            "receiver_id": receiverId, // ID penerima
            "message": message, // Isi pesan
            "timestamp": DateTime.now().toIso8601String(),
          }
        }
      };

      final response = await _client.post(
        Uri.parse(endpointFirebaseMessaging),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $serverKey"
        },
        body: jsonEncode(messages),
      );

      if (response.statusCode == 200) {
        return const Right('Notification Send');
      } else {
        return const Left('Failed send Notification');
      }
    } catch (e) {
      throw e.toString();
    }
  }

  factory NotificationServiceImpl.create() {
    return NotificationServiceImpl(
      client: http.Client(),
      firestore: FirebaseFirestore.instance,
      auth: FirebaseAuth.instance,
    );
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  NotificationServiceImpl(
    client: http.Client(),
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  ).firebaseBackgroundHandler(message);
}
