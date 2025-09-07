class ProfileDataModelItem{
  final String title;
  final String value;
  final String imageUrl;

  ProfileDataModelItem({
    required this.title,
    required this.imageUrl,
    required this.value
  });

  factory ProfileDataModelItem.fromJson(Map<String, dynamic> json) => ProfileDataModelItem(
      title: json['title'],
      imageUrl: json['imageUrl'],
      value: json['value']
  );
}