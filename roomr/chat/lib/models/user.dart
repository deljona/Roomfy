class User {
  final String name;
  final String username;

  User({required this.name, required this.username});

  Map<String, dynamic> toJson() => {'name': name, 'username': username};
}
