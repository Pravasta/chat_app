import 'package:chat_app/models/request/chat_request_model.dart';
import 'package:chat_app/view/pages/detail_chat_page.dart';
import 'package:chat_app/view/pages/login_page.dart';
import 'package:chat_app/view/pages/main_page.dart';
import 'package:chat_app/view/pages/register_page.dart';
import 'package:chat_app/view/pages/splash_page.dart';
import 'package:flutter/material.dart';
import '../../constant/constant.dart';
import '../common.dart';

class RoutesHandler {
  final String initialRoutes = RoutesName.initial;
  static const initialNavbarVisibility = true;

  static MaterialPageRoute get _emptyPage {
    return MaterialPageRoute(
      builder: (context) {
        return Scaffold(
          body: Center(
            child: Text(
              'Not Found',
              style: AppText.text24.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.initial:
        return MaterialPageRoute(
          builder: (context) => const SplashPage(),
          settings: settings,
        );
      case RoutesName.login:
        return MaterialPageRoute(
          builder: (context) => const LoginPage(),
          settings: settings,
        );

      case RoutesName.register:
        return MaterialPageRoute(
          builder: (context) => const RegisterPage(),
          settings: settings,
        );

      case RoutesName.mainPage:
        return MaterialPageRoute(
          builder: (context) => const MainPage(),
          settings: settings,
        );
      case RoutesName.detailChat:
        final dataChat = settings.arguments;
        if (dataChat == null || dataChat is! ChatRequestModel) {
          return _emptyPage;
        }
        return MaterialPageRoute(
          builder: (context) => DetailChatPage(
            dataChat: dataChat,
          ),
          settings: settings,
        );

      default:
        return _emptyPage;
    }
  }
}
