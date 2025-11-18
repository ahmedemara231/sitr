class IntroModel {
  final int id;
  final String title;
  final String description;
  final String image;

  IntroModel({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
  });

  factory IntroModel.fromJson(Map<String, dynamic> json) {
    return IntroModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      image: json['image'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "image": image,
    };
  }
}
