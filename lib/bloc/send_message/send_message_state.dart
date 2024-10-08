part of 'send_message_bloc.dart';

@freezed
class SendMessageState with _$SendMessageState {
  const factory SendMessageState.initial() = _Initial;
  const factory SendMessageState.loading() = _Loading;
  const factory SendMessageState.error(String error) = _Error;
  const factory SendMessageState.success() = _Success;
}
