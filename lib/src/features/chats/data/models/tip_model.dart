class TipModel{
  final String title;
  final String tips;

  TipModel({
    required this.title,
    required this.tips,
  });

  factory TipModel.fromJson(Map<String, dynamic> json) => TipModel(
      title: json['title'],
      tips: json['description']
  );
}