part of 'get_messages_bloc.dart';

@freezed
class GetMessagesState with _$GetMessagesState {
  const factory GetMessagesState.initial() = _Initial;
  const factory GetMessagesState.loading() = _Loading;
  const factory GetMessagesState.error(String error) = _Error;
  const factory GetMessagesState.loaded(
      Stream<List<MessageResponseModel>> messageStream) = _Loaded;
}
