import 'dart:async';

import 'package:chat_app/service/auth_local_service.dart';
import 'package:chat_app/view/pages/login_page.dart';
import 'package:chat_app/view/pages/main_page.dart';
import 'package:flutter/material.dart';

import '../../core/constant/constant.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    final isPotrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return FutureBuilder(
        future: Future.delayed(
          const Duration(seconds: 3),
          () => AuthLocalServiceImpl().isLogin(),
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == true) {
              return const MainPage();
            } else {
              return const LoginPage();
            }
          } else {
            return Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(40.0),
                child: isPotrait
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(UrlAssets.introImage),
                          const SizedBox(height: 10),
                          Text(
                            'Connect easily with your family and friends over countries',
                            style: AppText.text24.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(UrlAssets.introImage),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Connect easily with your family and friends over countries',
                              style: AppText.text24.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
              ),
            );
          }
        });
  }
}
