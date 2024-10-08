import 'package:chat_app/core/common/common.dart';
import 'package:chat_app/core/components/components.dart';
import 'package:chat_app/models/response/user_response_model.dart';
import 'package:chat_app/service/auth_local_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/logout/logout_bloc.dart';
import '../../bloc/user/user_bloc.dart';
import '../../core/constant/constant.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isObsecure = true;
  late final TextEditingController passC;
  late final TextEditingController emailC;

  @override
  void initState() {
    emailC = TextEditingController(text: '');
    passC = TextEditingController(text: '');
    context.read<UserBloc>().add(const UserEvent.getUser());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    emailC.dispose();
    passC.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget imageProfile() {
      return Container(
        padding: const EdgeInsets.all(60),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              UrlAssets.userImage,
            ),
          ),
        ),
      );
    }

    Widget detailAccount(UserResponseModel user) {
      emailC.text = user.name!;
      passC.text = user.password!;

      return Column(
        children: [
          DefaultField(
            labelText: 'Email',
            controller: emailC,
            readOnly: true,
            prefixIcon: const Icon(
              Icons.email,
              color: AppColors.whiteColor,
            ),
          ),
          const SizedBox(height: 15),
          DefaultField(
            labelText: 'Password',
            controller: passC,
            readOnly: true,
            suffixIcon: IconButton(
              onPressed: () {
                isObsecure = !isObsecure;
                setState(() {});
              },
              icon: Icon(
                isObsecure
                    ? Icons.remove_red_eye
                    : Icons.remove_red_eye_outlined,
                color: AppColors.greyColor,
              ),
            ),
            isObscure: isObsecure,
            prefixIcon: const Icon(
              Icons.password,
              color: AppColors.whiteColor,
            ),
          ),
        ],
      );
    }

    Widget buttonLogout() {
      return BlocConsumer<LogoutBloc, LogoutState>(
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
            success: (success) async {
              await AuthLocalServiceImpl().removeAuthData();
              Navigation.pushReplacement(RoutesName.login);
            },
          );
        },
        builder: (context, state) {
          return state.maybeWhen(
            loading: () => const Center(child: CircularProgressIndicator()),
            orElse: () {
              return DefaultButton(
                title: 'Logout',
                height: 50,
                backgroundColor: AppColors.secondaryColor,
                borderColor: AppColors.secondaryColor,
                iconUrl: Icons.logout,
                onTap: () {
                  context.read<LogoutBloc>().add(const LogoutEvent.logout());
                },
              );
            },
          );
        },
      );
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50),
        child: Center(
          child: SingleChildScrollView(
            child: BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                return state.maybeWhen(
                  orElse: () => const SizedBox(),
                  loaded: (user) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 30),
                        imageProfile(),
                        const SizedBox(height: 50),
                        detailAccount(user),
                        const SizedBox(height: 50),
                        buttonLogout(),
                      ],
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
