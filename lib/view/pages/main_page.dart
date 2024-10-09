import 'package:chat_app/service/notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../bloc/user/user_bloc.dart';
import 'chat_page.dart';
import 'contact_page.dart';
import 'profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 1;

  @override
  void initState() {
    context.read<UserBloc>().add(const UserEvent.getUser());
    NotificationServiceImpl(
      client: http.Client(),
      firestore: FirebaseFirestore.instance,
      auth: FirebaseAuth.instance,
    ).initialized();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> listBottomNavbar = [
      {'icon': Icons.group, 'label': 'Contact'},
      {'icon': Icons.chat, 'label': 'Chat'},
      {'icon': Icons.person, 'label': 'Profile'}
    ];

    final List<Widget> listPage = [
      const ContactPage(),
      BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          return state.maybeWhen(
            orElse: () {
              return const SizedBox();
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            loaded: (user) {
              return ChatPage(userId: user.uid!);
            },
          );
        },
      ),
      const ProfilePage(),
    ];

    return Scaffold(
      body: listPage.elementAt(currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        iconSize: 28,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        onTap: (value) {
          currentIndex = value;
          setState(() {});
        },
        items: listBottomNavbar
            .map(
              (e) => BottomNavigationBarItem(
                icon: Icon(e['icon']),
                label: e['label'],
              ),
            )
            .toList(),
      ),
    );
  }
}
