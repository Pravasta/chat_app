part of 'push_notification_bloc.dart';

@freezed
class PushNotificationEvent with _$PushNotificationEvent {
  const factory PushNotificationEvent.started() = _Started;
  const factory PushNotificationEvent.sendNotification(
    String receiverId,
    String messages,
  ) = _SendNotification;
}
