import 'package:chat_app/service/user_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app/models/response/user_response_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_list_user_event.dart';
part 'get_list_user_state.dart';
part 'get_list_user_bloc.freezed.dart';

class GetListUserBloc extends Bloc<GetListUserEvent, GetListUserState> {
  final UserService _userService;

  GetListUserBloc(this._userService) : super(const _Initial()) {
    on<_GetListUsers>((event, emit) async {
      emit(const _Loading());

      final result = await _userService.getAllUser();

      result.fold(
        (l) => emit(_Error(l)),
        (r) => emit(_Success(r)),
      );
    });
  }
}
