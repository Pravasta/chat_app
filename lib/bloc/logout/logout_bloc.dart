import 'package:chat_app/service/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'logout_event.dart';
part 'logout_state.dart';
part 'logout_bloc.freezed.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final AuthService _authService;

  LogoutBloc(this._authService) : super(const _Initial()) {
    on<_Logout>((event, emit) async {
      emit(const _Loading());

      final result = await _authService.logout();

      result.fold(
        (l) => emit(_Error(l)),
        (r) => emit(_Success(r)),
      );
    });
  }
}
