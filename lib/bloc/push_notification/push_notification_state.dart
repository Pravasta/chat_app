part of 'push_notification_bloc.dart';

@freezed
class PushNotificationState with _$PushNotificationState {
  const factory PushNotificationState.initial() = _Initial;
  const factory PushNotificationState.loading() = _Loading;
  const factory PushNotificationState.error(String error) = _Error;
  const factory PushNotificationState.success(String success) = _Success;
}
