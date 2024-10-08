import 'dart:convert';

class UserResponseModel {
  final String? uid;
  final String? name;
  final String? email;
  final String? password;
  final String? fcmToken;
  final List<String>? chats;
  UserResponseModel({
    this.uid,
    this.name,
    this.email,
    this.password,
    this.fcmToken,
    this.chats,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'email': email,
      'password': password,
      'fcmToken': fcmToken,
      'chats': chats,
    };
  }

  factory UserResponseModel.fromFirestore(
      Map<String, dynamic> data, String documentId) {
    return UserResponseModel(
      uid: documentId,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      password: data['password'] ?? '',
      fcmToken: data['fcm_token'] ?? '',
      chats: List<String>.from(
        data['chats'] ?? [],
      ),
    );
  }

  factory UserResponseModel.fromMap(Map<String, dynamic> map) {
    return UserResponseModel(
      uid: map['uid'] != null ? map['uid'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      password: map['password'] != null ? map['password'] as String : null,
      fcmToken: map['fcmToken'] != null ? map['fcmToken'] as String : null,
      chats: map['chats'] != null
          ? List<String>.from((map['chats'] as List<String>))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserResponseModel.fromJson(String source) =>
      UserResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
