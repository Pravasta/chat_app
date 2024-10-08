import 'package:chat_app/service/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app/models/request/register_request_model.dart';
import 'package:chat_app/models/response/user_response_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_event.dart';
part 'register_state.dart';
part 'register_bloc.freezed.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthService _service;

  RegisterBloc(this._service) : super(const _Initial()) {
    on<_Register>((event, emit) async {
      emit(const _Loading());

      final result = await _service.register(event.data);

      result.fold(
        (l) => emit(_Error(l)),
        (r) => emit(_Success(r)),
      );
    });
  }
}
