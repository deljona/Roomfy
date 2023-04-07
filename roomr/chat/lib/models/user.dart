class User {
  final String name;
  final String username;
  final String tag;

  User({required this.name, required this.username, required this.tag});

  Map<String, dynamic> toJson() =>
      {'name': name, 'username': username, 'tag': tag};
}
