import 'package:flutter/material.dart';

import '../../core/constant/constant.dart';
import '../../models/response/user_response_model.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({
    super.key,
    required this.dataContact,
  });

  final UserResponseModel dataContact;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 1),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
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
          dataContact.name ?? '',
          style: AppText.text14.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        // subtitle: Text(
        //   dataContact.status ?? '',
        //   style: AppText.text12.copyWith(
        //     color: AppColors.greyColor,
        //     fontWeight: FontWeight.bold,
        //   ),
        // )
      ),
    );
  }
}
