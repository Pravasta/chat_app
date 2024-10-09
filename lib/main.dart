import 'package:chat_app/bloc/get_list_user/get_list_user_bloc.dart';
import 'package:chat_app/bloc/get_messages/get_messages_bloc.dart';
import 'package:chat_app/bloc/login/login_bloc.dart';
import 'package:chat_app/bloc/logout/logout_bloc.dart';
import 'package:chat_app/bloc/push_notification/push_notification_bloc.dart';
import 'package:chat_app/bloc/register/register_bloc.dart';
import 'package:chat_app/bloc/user/user_bloc.dart';
import 'package:chat_app/service/auth_service.dart';
import 'package:chat_app/service/chat_service.dart';
import 'package:chat_app/service/user_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/send_message/send_message_bloc.dart';
import 'core/common/common.dart';
import 'core/constant/constant.dart';
import 'firebase_options.dart';
import 'service/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => RegisterBloc(AuthServiceImpl.create()),
        ),
        BlocProvider(
          create: (_) => LoginBloc(AuthServiceImpl.create()),
        ),
        BlocProvider(
          create: (_) => LogoutBloc(AuthServiceImpl.create()),
        ),
        BlocProvider(
          create: (_) => UserBloc(UserServiceImpl.create()),
        ),
        BlocProvider(
          create: (_) => GetListUserBloc(UserServiceImpl.create()),
        ),
        BlocProvider(
          create: (_) => SendMessageBloc(ChatServiceImpl.create()),
        ),
        BlocProvider(
          create: (_) => GetMessagesBloc(ChatServiceImpl.create()),
        ),
        BlocProvider(
          create: (_) => PushNotificationBloc(NotificationServiceImpl.create()),
        ),
      ],
      child: MaterialApp(
        title: 'Chat App',
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        theme: AppTheme.darkTheme,
        initialRoute: RoutesName.initial,
        onGenerateRoute: RoutesHandler.onGenerateRoute,
      ),
    );
  }
}
