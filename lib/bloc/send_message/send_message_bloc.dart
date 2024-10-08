import 'package:chat_app/models/request/message_request_model.dart';
import 'package:chat_app/service/chat_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'send_message_event.dart';
part 'send_message_state.dart';
part 'send_message_bloc.freezed.dart';

class SendMessageBloc extends Bloc<SendMessageEvent, SendMessageState> {
  final ChatService _chatService;

  SendMessageBloc(this._chatService) : super(const _Initial()) {
    on<_SendMessage>((event, emit) async {
      emit(const _Loading());

      final result = await _chatService.sendMessage(event.message);

      result.fold(
        (l) => emit(_Error(l)),
        (r) => emit(const _Success()),
      );
    });
  }
}
