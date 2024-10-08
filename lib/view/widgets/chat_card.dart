import 'package:chat_app/core/extension/date_extension.dart';
import 'package:chat_app/models/request/chat_request_model.dart';
import 'package:flutter/material.dart';

import '../../core/constant/constant.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({
    super.key,
    required this.dataChat,
    required this.onTap,
  });

  final ChatRequestModel dataChat;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 1),
      child: ListTile(
        onTap: onTap,
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Image.network(
            'https://picsum.photos/id/870/200/300',
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          dataChat.name,
          style: AppText.text14.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          dataChat.lastMessage ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppText.text12.copyWith(
            color: AppColors.greyColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Column(
          children: [
            Text(
              DateTime.parse(dataChat.date!).getFormattedTime(),
              style: AppText.text12.copyWith(
                color: AppColors.greyColor,
              ),
            ),
            // const SizedBox(height: 2),
            // (dataChat.countMessage == null || dataChat.countMessage == '0')
            //     ? Text(
            //         '',
            //         style: AppText.text12.copyWith(
            //           color: AppColors.secondaryColor,
            //           fontWeight: FontWeight.bold,
            //         ),
            //       )
            //     : Container(
            //         padding: const EdgeInsets.all(6),
            //         decoration: const BoxDecoration(
            //           color: AppColors.greyColor,
            //           shape: BoxShape.circle,
            //         ),
            //         child: Text(
            //           (dataChat.countMessage) ?? '',
            //           style: AppText.text12.copyWith(
            //             color: AppColors.secondaryColor,
            //             fontWeight: FontWeight.bold,
            //           ),
            //         ),
            //       )
          ],
        ),
      ),
    );
  }
}
