class Message {
  final String message;
  final String sendAt = getTime();

  Message({required this.message});

  Map<String, dynamic> toJson() => {'message': message, 'sendAt': sendAt};

  static String getTime() {
    var hour = DateTime.now().hour.toString();
    var minute = DateTime.now().minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }
}
