class Message {
  final String message;
  String? sendAt = getTime();

  Message({required this.message, this.sendAt});

  Map<String, dynamic> toJson() => {'message': message, 'sendAt': sendAt};

  static String getTime() {
    var hour = DateTime.now().hour.toString();
    var minute = DateTime.now().minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }
}
