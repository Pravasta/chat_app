import 'package:chat_app/service/notification_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'push_notification_event.dart';
part 'push_notification_state.dart';
part 'push_notification_bloc.freezed.dart';

class PushNotificationBloc
    extends Bloc<PushNotificationEvent, PushNotificationState> {
  final NotificationService _notificationService;

  PushNotificationBloc(this._notificationService) : super(const _Initial()) {
    on<_SendNotification>((event, emit) async {
      emit(const _Loading());

      final result = await _notificationService.sendNotificationToSelectedUser(
          event.receiverId, event.messages);

      result.fold(
        (l) => emit(_Error(l)),
        (r) => emit(_Success(r)),
      );
    });
  }
}
