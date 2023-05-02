class Message {
  final String message;
  final String senderUsername;

  Message({required this.message, required this.senderUsername});

  factory Message.fromJson(Map<String, dynamic> message) {
    return Message(
      message: message['message'],
      senderUsername: message['senderUsername'],
    );
  }
}
