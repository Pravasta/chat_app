import 'package:chat_app/core/common/common.dart';
import 'package:chat_app/core/components/components.dart';
import 'package:chat_app/core/constant/constant.dart';
import 'package:chat_app/models/request/login_model.dart';
import 'package:chat_app/service/auth_local_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/login/login_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isObsecure = true;
  late TextEditingController _emailC;
  late TextEditingController _passC;

  @override
  void initState() {
    super.initState();
    _emailC = TextEditingController(text: 'fitrayanaf11@gmail.com');
    _passC = TextEditingController(text: 'Cobacoba123');
  }

  @override
  void dispose() {
    super.dispose();
    _emailC.dispose();
    _passC.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPotrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    Widget header() {
      return Column(
        children: [
          Text(
            'Chateo',
            style: AppText.bigText.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: isPotrait ? 40 : 50,
            ),
          ),
          Text(
            'Login to use this App. you can use email and password everything',
            textAlign: TextAlign.center,
            style: AppText.text12.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.greyColor,
              fontSize: isPotrait ? 12 : 13,
            ),
          ),
        ],
      );
    }

    Widget contentField() {
      return Column(
        children: [
          DefaultField(
            labelText: 'Email',
            controller: _emailC,
            validator: (value) {
              if (value != null && value.isNotEmpty && value.contains('@')) {
                return null;
              }
              return 'Email is not Valid. Please input our email';
            },
            inputType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 10),
          DefaultField(
              labelText: 'Password',
              controller: _passC,
              isObscure: isObsecure,
              inputType: TextInputType.text,
              validator: (value) {
                if (value != null || value!.isNotEmpty) {
                  return null;
                }
                return 'Password is Empty. Please input our password';
              },
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    isObsecure = !isObsecure;
                  });
                },
                icon: Icon(
                  isObsecure
                      ? Icons.remove_red_eye
                      : Icons.remove_red_eye_outlined,
                  color: AppColors.whiteColor,
                ),
              )),
        ],
      );
    }

    Widget buttonSubmit() {
      return BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          state.maybeWhen(
            orElse: () {},
            error: (errorMessage) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  errorMessage,
                  style: AppText.text14,
                ),
              ));
            },
            success: (user) async {
              await AuthLocalServiceImpl().saveAuthData(user);
              Navigation.pushReplacement(RoutesName.mainPage);
            },
          );
        },
        builder: (context, state) {
          return state.maybeWhen(
            loading: () => const Center(child: CircularProgressIndicator()),
            orElse: () {
              return DefaultButton(
                title: 'Login',
                backgroundColor: AppColors.blueColor,
                height: 50,
                onTap: () {
                  final dataLogin = LoginRequestModel(
                    email: _emailC.text.trim(),
                    password: _passC.text.trim(),
                  );

                  if (_formKey.currentState!.validate()) {
                    if (_emailC.text.isNotEmpty && _passC.text.isNotEmpty) {
                      context
                          .read<LoginBloc>()
                          .add(LoginEvent.login(dataLogin));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          'Email or password it\'s Empty',
                          style: AppText.text14,
                        ),
                      ));
                    }
                  }
                },
              );
            },
          );
        },
      );
    }

    Widget buttonToRegister() {
      return TextButton(
        onPressed: () {
          Navigation.pushName(RoutesName.register);
        },
        child: Text(
          'Don\'t have an account ? Register',
          style: AppText.text12.copyWith(color: AppColors.greyColor),
        ),
      );
    }

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(isPotrait ? 20.0 : 30),
        child: Form(
          key: _formKey,
          child: isPotrait
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    header(),
                    const SizedBox(height: 50),
                    contentField(),
                    const SizedBox(height: 50),
                    buttonSubmit(),
                    buttonToRegister(),
                  ],
                )
              : Center(
                  child: SingleChildScrollView(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(50.0),
                                child: header(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                contentField(),
                                const SizedBox(height: 20),
                                buttonSubmit(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
