import 'package:flutter/material.dart';

import '../../core/constant/constant.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.isSender,
    required this.time,
    required this.message,
  });

  final bool isSender;
  final String time;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        child: Container(
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: isSender ? AppColors.blueColor : AppColors.primaryColor,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(15),
                topRight: const Radius.circular(15),
                bottomLeft: isSender == false
                    ? const Radius.circular(0)
                    : const Radius.circular(15),
                bottomRight: isSender == true
                    ? const Radius.circular(0)
                    : const Radius.circular(15),
              ),
            ),
            child: Column(
              crossAxisAlignment:
                  isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: AppText.text14,
                ),
                const SizedBox(height: 10),
                Text(
                  time,
                  style: AppText.text10,
                ),
              ],
            )),
      ),
    );
  }
}
