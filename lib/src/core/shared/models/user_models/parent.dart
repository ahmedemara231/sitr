class Parent{
  final String? id;
  final String? name;
  final String? kinship;

  Parent({
    required this.id,
    required this.name,
    required this.kinship,
  });

  factory Parent.fromJson(Map<String, dynamic> json) => Parent(
      id: json['id'],
      name: json['name'],
      kinship: json['kinship']
  );
}