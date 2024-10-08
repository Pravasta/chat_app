part of 'get_messages_bloc.dart';

@freezed
class GetMessagesEvent with _$GetMessagesEvent {
  const factory GetMessagesEvent.started() = _Started;
  const factory GetMessagesEvent.getMessages(
      String senderId, String receiverId) = _GetMessages;
}
