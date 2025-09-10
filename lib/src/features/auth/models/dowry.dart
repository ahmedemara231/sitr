class Dowry{
  final String from;
  final String to;

  Dowry({required this.from, required this.to});

  factory Dowry.fromJson(Map<String, dynamic> json) => Dowry(from: json['from'], to: json['to']);
}