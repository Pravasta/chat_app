class ChatRequestModel {
  final String senderId;
  final String receiverId;
  final String name;
  final String senderName;
  final String? lastMessage;
  final String? date;

  ChatRequestModel({
    required this.senderId,
    required this.receiverId,
    required this.name,
    required this.senderName,
    this.lastMessage,
    this.date,
  });
}
