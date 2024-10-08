part of 'get_list_user_bloc.dart';

@freezed
class GetListUserState with _$GetListUserState {
  const factory GetListUserState.initial() = _Initial;
  const factory GetListUserState.loading() = _Loading;
  const factory GetListUserState.error(String errorMessage) = _Error;
  const factory GetListUserState.success(List<UserResponseModel> users) =
      _Success;
}
