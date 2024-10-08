class ModelChat {
  final String imageUrl;
  final String name;
  final String? lastMessage;
  final String? date;
  final String? status;
  final String? countMessage;

  ModelChat({
    required this.imageUrl,
    required this.name,
    this.lastMessage,
    this.date,
    this.status,
    this.countMessage,
  });
}
