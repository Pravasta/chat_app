import 'package:chat_app/service/chat_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app/models/response/message_response_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_messages_event.dart';
part 'get_messages_state.dart';
part 'get_messages_bloc.freezed.dart';

class GetMessagesBloc extends Bloc<GetMessagesEvent, GetMessagesState> {
  final ChatService _chatService;

  GetMessagesBloc(this._chatService) : super(const _Initial()) {
    on<_GetMessages>((event, emit) async {
      emit(const _Loading());
      try {
        final messagesStream =
            _chatService.getMessage(event.senderId, event.receiverId);
        emit(_Loaded(messagesStream));
      } catch (error) {
        emit(_Error(error.toString()));
      }
    });
  }
}
