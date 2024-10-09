import 'package:chat_app/bloc/push_notification/push_notification_bloc.dart';
import 'package:chat_app/bloc/send_message/send_message_bloc.dart';
import 'package:chat_app/core/common/common.dart';
import 'package:chat_app/core/components/components.dart';
import 'package:chat_app/core/extension/date_extension.dart';
import 'package:chat_app/models/request/chat_request_model.dart';
import 'package:chat_app/models/request/message_request_model.dart';
import 'package:chat_app/models/response/message_response_model.dart';
import 'package:chat_app/view/widgets/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/get_messages/get_messages_bloc.dart';
import '../../core/constant/constant.dart';

class DetailChatPage extends StatefulWidget {
  const DetailChatPage({
    super.key,
    required this.dataChat,
  });

  final ChatRequestModel dataChat;

  @override
  State<DetailChatPage> createState() => _DetailChatPageState();
}

class _DetailChatPageState extends State<DetailChatPage> {
  late TextEditingController messageC;

  @override
  void initState() {
    context.read<GetMessagesBloc>().add(GetMessagesEvent.getMessages(
        widget.dataChat.senderId, widget.dataChat.receiverId));
    messageC = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    messageC.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar() {
      return AppBar(
        leading: BackButton(
          onPressed: () => Navigation.pop(),
          color: AppColors.whiteColor,
        ),
        title: Text(
          widget.dataChat.name,
          style: AppText.text16,
        ),
      );
    }

    Widget content() {
      return BlocBuilder<GetMessagesBloc, GetMessagesState>(
        builder: (context, state) {
          return state.maybeWhen(
            orElse: () => const SizedBox(),
            loading: () => const Center(child: CircularProgressIndicator()),
            loaded: (messageStream) {
              return StreamBuilder<List<MessageResponseModel>>(
                stream: messageStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      final messages = snapshot.data!;

                      return ListView.builder(
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final data = messages[index];

                          return ChatBubble(
                            isSender: data.senderId == widget.dataChat.senderId,
                            time: DateTime.parse(data.timestamp)
                                .getFormattedTime(),
                            message: data.message,
                          );
                        },
                      );
                    }
                  }

                  return const SizedBox();
                },
              );
            },
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      appBar: appBar(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: content(),
      ),
      bottomNavigationBar: Container(
        color: AppColors.primaryColor,
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Expanded(
              child: DefaultField(
                controller: messageC,
                hintText: 'Write in this',
              ),
            ),
            const SizedBox(width: 15),
            InkWell(
              onTap: () {
                final message = MessageRequestModel(
                  receiverId: widget.dataChat.receiverId,
                  message: messageC.text,
                  receiverName: widget.dataChat.name,
                  senderName: widget.dataChat.senderName,
                );

                context
                    .read<SendMessageBloc>()
                    .add(SendMessageEvent.sendMessage(message));

                context.read<PushNotificationBloc>().add(
                    PushNotificationEvent.sendNotification(
                        widget.dataChat.receiverId, messageC.text));

                messageC.clear();
              },
              child: Image.asset(
                UrlAssets.sendImage,
                scale: 2.5,
              ),
            )
          ],
        ),
      ),
    );
  }
}
