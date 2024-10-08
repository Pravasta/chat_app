import 'package:chat_app/core/common/common.dart';
import 'package:chat_app/core/components/components.dart';
import 'package:chat_app/models/request/chat_request_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/get_list_user/get_list_user_bloc.dart';
import '../../bloc/user/user_bloc.dart';
import '../../core/constant/constant.dart';
import '../widgets/contact_card.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  void initState() {
    context.read<UserBloc>().add(const UserEvent.getUser());
    context.read<GetListUserBloc>().add(const GetListUserEvent.getListUsers());
    super.initState();
  }

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
      return BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          final currentUser = state.maybeWhen(
            orElse: () {},
            loaded: (user) => user,
          );

          return BlocBuilder<GetListUserBloc, GetListUserState>(
            builder: (context, state) {
              return state.maybeWhen(
                orElse: () => const SizedBox(),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (errorMessage) {
                  return Center(
                    child: Text(errorMessage, style: AppText.text18),
                  );
                },
                success: (users) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      // final List<String> status = ['Online', 'Offline'];

                      final user = users[index];

                      final dataContact = ChatRequestModel(
                        senderName: currentUser!.name!,
                        senderId: currentUser.uid!,
                        receiverId: user.uid!,
                        name: user.name!,
                      );

                      return GestureDetector(
                        onTap: () {
                          Navigation.pushName(
                            RoutesName.detailChat,
                            arguments: dataContact,
                          );
                        },
                        child: ContactCard(dataContact: user),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Contacts',
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
