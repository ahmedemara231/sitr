class Social {
  final String link;
  final String name;
  final String icon;

  Social({
    required this.link,
    required this.name,
    required this.icon,
  });

  factory Social.fromJson(Map<String, dynamic> json) {
    return Social(
      link: json['link'] ?? '',
      name: json['name'] ?? '',
      icon: json['icon'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'link': link,
      'name': name,
      'icon': icon,
    };
  }
}
