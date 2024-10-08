class MessageRequestModel {
  final String receiverId;
  final String receiverName;
  final String senderName;
  final String message;

  MessageRequestModel({
    required this.receiverId,
    required this.receiverName,
    required this.senderName,
    required this.message,
  });
}
