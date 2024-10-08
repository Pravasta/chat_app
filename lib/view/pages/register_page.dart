import 'package:chat_app/core/common/common.dart';
import 'package:chat_app/models/request/register_request_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/register/register_bloc.dart';
import '../../core/components/components.dart';
import '../../core/constant/constant.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isObsecure = true;
  late TextEditingController _nameC;
  late TextEditingController _emailC;
  late TextEditingController _passC;

  @override
  void initState() {
    super.initState();
    _nameC = TextEditingController(text: 'Pravasta');
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
    Widget header() {
      return Column(
        children: [
          Text(
            'Chateo',
            style: AppText.bigText.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 40,
            ),
          ),
          Text(
            'With register you can have an account for create memories with our friend',
            textAlign: TextAlign.center,
            style: AppText.text12.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.greyColor,
              fontSize: 12,
            ),
          ),
        ],
      );
    }

    Widget contentField() {
      return Column(
        children: [
          DefaultField(
            labelText: 'Name',
            controller: _nameC,
            validator: (value) {
              if (value != null && value.isNotEmpty) {
                return null;
              }
              return 'Name is not Valid. Please input our name';
            },
            inputType: TextInputType.text,
          ),
          const SizedBox(height: 10),
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
      return BlocConsumer<RegisterBloc, RegisterState>(
        listener: (context, state) {
          state.maybeWhen(
            orElse: () {},
            error: (errorMessage) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(errorMessage, style: AppText.text14),
              ));
            },
            success: (user) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Success', style: AppText.text14),
              ));
              Navigation.pushReplacement(RoutesName.login);
            },
          );
        },
        builder: (context, state) {
          return state.maybeWhen(
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            orElse: () {
              return DefaultButton(
                title: 'Register',
                backgroundColor: AppColors.blueColor,
                height: 50,
                onTap: () {
                  final dataRegister = RegisterRequestModel(
                    name: _nameC.text.trim(),
                    email: _emailC.text.trim(),
                    password: _passC.text.trim(),
                  );

                  if (_formKey.currentState!.validate()) {
                    if (_emailC.text.isNotEmpty &&
                        _passC.text.isNotEmpty &&
                        _nameC.text.isNotEmpty) {
                      context
                          .read<RegisterBloc>()
                          .add(RegisterEvent.register(dataRegister));
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

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                header(),
                const SizedBox(height: 50),
                contentField(),
                const SizedBox(height: 50),
                buttonSubmit(),
              ],
            )),
      ),
    );
  }
}
