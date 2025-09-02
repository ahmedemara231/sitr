class Package{
  final int id;
  final String name;
  final PackageType type;
  final String image;
  final int duration;
  final double price;

  Package(this.id, this.name, this.type, this.image, this.duration, this.price);

  factory Package.initial() => Package(
    0,
    '',
    PackageType.initial(),
    '',
    0,
    0.0,
  );

  factory Package.fromJson(Map<String, dynamic> json) => Package(
    json['id'],
    json['name'],
    json['type']['key'],
    json['image'],
    json['duration'],
    json['price'],
  );
}

class PackageType{
  final String key;
  final String value;
  final String title;

  PackageType(this.key, this.value, this.title);

  factory PackageType.initial() => PackageType(
    '','',''
  );

  factory PackageType.fromJson(Map<String, dynamic> json) => PackageType(
    json['key'],
    json['value'],
    json['title'],
  );
}