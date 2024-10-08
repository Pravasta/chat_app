import 'package:chat_app/service/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app/models/request/login_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../models/response/user_response_model.dart';

part 'login_event.dart';
part 'login_state.dart';
part 'login_bloc.freezed.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthService _authService;

  LoginBloc(this._authService) : super(const _Initial()) {
    on<_Login>((event, emit) async {
      emit(const _Loading());

      final result = await _authService.login(event.data);

      result.fold(
        (l) => emit(_Error(l)),
        (r) => emit(_Success(r)),
      );
    });
  }
}
