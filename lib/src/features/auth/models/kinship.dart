class Kinship{
  final int id;
  final String value;

  Kinship({
    required this.id,
    required this.value,
  });

  factory Kinship.fromJson(Map<String, dynamic> json) => Kinship(
      id: json['id'],
      value: json['name']
  );
}