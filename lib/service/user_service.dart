import 'package:chat_app/models/response/user_response_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class UserService {
  Future<Either<String, UserResponseModel>> getUser();
  Future<Either<String, List<UserResponseModel>>> getAllUser();
  
}

class UserServiceImpl implements UserService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  UserServiceImpl({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
  })  : _auth = auth,
        _firestore = firestore;

  @override
  Future<Either<String, UserResponseModel>> getUser() async {
    try {
      final user = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();

      return Right(
          UserResponseModel.fromMap(user.data() as Map<String, dynamic>));
    } on FirebaseException catch (e) {
      throw e.message.toString();
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<Either<String, List<UserResponseModel>>> getAllUser() async {
    List<UserResponseModel> listUser = [];
    try {
      final currentUserId = _auth.currentUser!.uid;
      CollectionReference users = _firestore.collection('users');

      QuerySnapshot querySnapshot = await users.get();

      listUser = querySnapshot.docs
          .map((e) => UserResponseModel.fromFirestore(
              e.data() as Map<String, dynamic>, e.id))
          .where((user) => user.uid != currentUserId)
          .toList();

      return Right(listUser);
    } on FirebaseException catch (e) {
      throw e.message.toString();
    } catch (e) {
      throw e.toString();
    }
  }

  factory UserServiceImpl.create() {
    return UserServiceImpl(
      auth: FirebaseAuth.instance,
      firestore: FirebaseFirestore.instance,
    );
  }
}
