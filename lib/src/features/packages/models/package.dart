class Package{
  final int id;
  final String name;
  final PackageType type;
  final String image;
  final int duration;
  final num price;
  final bool canSubscribe;

  Package(this.id, this.name, this.type, this.image, this.duration, this.price, this.canSubscribe,);

  factory Package.initial() => Package(
    0,
    '',
    PackageType.initial(),
    '',
    0,
    0.0,
    false
  );

  factory Package.fromJson(Map<String, dynamic> json) => Package(
    json['id'],
    json['name'],
    PackageType.fromJson(json['type']),
    json['image'],
    json['duration'],
    json['price'],
    json['can_subscribe']??true
  );
}

class PackageType{
  final String value;
  final String title;

  PackageType(this.value, this.title);

  factory PackageType.initial() => PackageType(
    '',''
  );

  factory PackageType.fromJson(Map<String, dynamic> json) => PackageType(
    json['value'],
    json['title'],
  );
}