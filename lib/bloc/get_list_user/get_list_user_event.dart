part of 'get_list_user_bloc.dart';

@freezed
class GetListUserEvent with _$GetListUserEvent {
  const factory GetListUserEvent.started() = _Started;
  const factory GetListUserEvent.getListUsers() = _GetListUsers;
}
