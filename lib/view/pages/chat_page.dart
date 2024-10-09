import 'package:chat_app/models/request/chat_request_model.dart';
import 'package:chat_app/service/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/common/common.dart';
import '../../core/components/components.dart';
import '../../core/constant/constant.dart';
import '../../models/response/chat_response_model.dart';
import '../widgets/chat_card.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  Widget build(BuildContext context) {
    Widget searchFill() {
      return const DefaultField(
        hintText: 'Search (Read Only)',
        readOnly: true,
        prefixIcon: Icon(
          Icons.search,
          color: AppColors.whiteColor,
        ),
      );
    }

    Widget listChat() {
      return StreamBuilder<List<ChatResponseModel>>(
        stream: ChatServiceImpl(
                firestore: FirebaseFirestore.instance,
                auth: FirebaseAuth.instance)
            .fetchChatSessions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString(), style: AppText.text16),
              );
            }

            if (snapshot.hasData) {
              if (snapshot.data!.isNotEmpty) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final data = snapshot.data![index];

                    final displayName = data.receiverId == userId
                        ? data.receiverName
                        : data.senderName;

                    final dataChat = ChatRequestModel(
                      senderId: data.senderId,
                      receiverId: data.receiverId,
                      name: displayName,
                      senderName: data.senderName,
                      lastMessage: data.lastMessage,
                      date: data.timestamp,
                    );

                    return ChatCard(
                      dataChat: dataChat,
                      onTap: () => Navigation.pushName(
                        RoutesName.detailChat,
                        arguments: dataChat,
                      ),
                    );
                  },
                );
              } else {
                return Center(
                  child: Text('Let\'s start chatt with Friend',
                      style: AppText.text16),
                );
              }
            }
          }

          return const SizedBox();
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Chats',
          style: AppText.text18,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
        child: ListView(
          children: [
            searchFill(),
            const SizedBox(height: 10),
            listChat(),
          ],
        ),
      ),
    );
  }
}
