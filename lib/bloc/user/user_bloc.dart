import 'package:chat_app/service/user_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app/models/response/user_response_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_event.dart';
part 'user_state.dart';
part 'user_bloc.freezed.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserService _userService;

  UserBloc(this._userService) : super(const _Initial()) {
    on<_GetUser>((event, emit) async {
      emit(const _Loading());

      final result = await _userService.getUser();

      result.fold(
        (l) => emit(_Error(l)),
        (r) => emit(_Loaded(r)),
      );
    });
  }
}
