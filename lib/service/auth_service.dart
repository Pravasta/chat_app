import 'package:chat_app/models/request/login_model.dart';
import 'package:chat_app/models/response/user_response_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../models/request/register_request_model.dart';

abstract class AuthService {
  Future<Either<String, UserResponseModel>> register(RegisterRequestModel data);
  Future<Either<String, UserResponseModel>> login(LoginRequestModel data);
  Future<Either<String, bool>> logout();
  Future<void> setUser(UserResponseModel user);
  Future<void> updateFcmUser(UserResponseModel user);
}

class AuthServiceImpl implements AuthService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final FirebaseMessaging _messaging;

  AuthServiceImpl({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
    required FirebaseMessaging messaging,
  })  : _auth = auth,
        _firestore = firestore,
        _messaging = messaging;

  @override
  Future<Either<String, UserResponseModel>> register(
      RegisterRequestModel data) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: data.email,
        password: data.password,
      );

      final user = UserResponseModel(
        name: data.name,
        email: data.email,
        password: data.password,
        uid: credential.user!.uid,
      );

      await setUser(user);

      return Right(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return const Left('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        return const Left('The account already exists for that email.');
      } else {
        return Left(e.message.toString());
      }
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<Either<String, UserResponseModel>> login(
      LoginRequestModel data) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: data.email,
        password: data.password,
      );

      final fcmToken = await _messaging.getToken();

      final UserResponseModel user = UserResponseModel(
        email: credential.user!.email,
        password: data.password,
        uid: credential.user!.uid,
        name: credential.user?.displayName,
        fcmToken: fcmToken,
      );

      await updateFcmUser(user);

      return Right(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return const Left('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        return const Left('Wrong password provided for that user.');
      } else {
        return Left(e.message.toString());
      }
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<Either<String, bool>> logout() async {
    try {
      await _auth.signOut();
      return const Right(true);
    } on FirebaseException catch (e) {
      throw e.message.toString();
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<void> setUser(UserResponseModel user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set(user.toMap());
    } on FirebaseException catch (e) {
      throw e.toString();
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<void> updateFcmUser(UserResponseModel user) async {
    try {
      await _firestore.collection('users').doc(user.uid).update({
        'fcm_token': user.fcmToken,
      });
    } on FirebaseException catch (e) {
      throw e.toString();
    } catch (e) {
      throw e.toString();
    }
  }

  factory AuthServiceImpl.create() {
    return AuthServiceImpl(
      auth: FirebaseAuth.instance,
      firestore: FirebaseFirestore.instance,
      messaging: FirebaseMessaging.instance,
    );
  }
}
