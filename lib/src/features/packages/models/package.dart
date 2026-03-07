class Package{
  final int id;
  final String name;
  final PackageType type;
  final String image;
  final int duration;
  final num price;
  final bool hasActivePackage;
  final int packageId;

  Package({
    required this.id,
    required this.name,
    required this.type,
    required this.image,
    required this.duration,
    required this.price,
    required this.hasActivePackage,
    required this.packageId,
});

  factory Package.initial() => Package(
    id: 0,
    name: '',
    type: PackageType.initial(),
    image: '',
    duration: 0,
    price: 0,
    hasActivePackage: false,
    packageId: 0,
  );

  // factory Package.fromJson(Map<String, dynamic> json) => Package(
  //   json['id'], // the user package id in body in renew
  //   json['name'],
  //   PackageType.fromJson(json['type']),
  //   json['image'],
  //   json['duration'],
  //   json['price'],
  //   json['has_active_package']??true,
  //     json['package_id'] ?? 0 // sent as package id in renew
  // );

  factory Package.fromJson(Map<String, dynamic> json) => Package(
    id: json['id'], // user package id
    name: json['name'],
    type: PackageType.fromJson(json['type']),
    image: json['image'],
    duration: json['duration'],
    price: json['price'],
    hasActivePackage: json['has_active_package']??true,
    packageId: json['package_id'] ?? 0 // package id
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type.toJson(),
    'image': image,
    'duration': duration,
    'price': price,
    'has_active_package': hasActivePackage,
    'package_id': packageId,
  };
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

  Map<String, dynamic> toJson() => {
    'value': value,
    'title': title,
  };
}