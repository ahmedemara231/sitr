class AuthModel {
  // Define your model properties here
  final String id;

  AuthModel({required this.id});

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      id: json['id'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'id': id};
}
