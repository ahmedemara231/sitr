// class PackageModel {
//   int id;
//   String name;
//   String details;
//   dynamic duration;
//   String price;
//   bool isSubscribed;
//   bool isExpired;
//   DateTime createdAt;
//
//   PackageModel({
//     required this.id,
//     required this.name,
//     required this.details,
//     required this.duration,
//     required this.price,
//     required this.isSubscribed,
//     required this.isExpired,
//     required this.createdAt,
//   });
//
//   factory PackageModel.initial() {
//     return PackageModel(
//       id: 0,
//       name: '',
//       details: '',
//       duration: 0,
//       price: '',
//       isExpired: false,
//       isSubscribed: false,
//       createdAt: DateTime.now(),
//     );
//   }
//
//   factory PackageModel.fromJson(Map<String, dynamic> json) => PackageModel(
//     id: json["id"],
//     name: json["name"],
//     details: json["details"],
//     duration: json["duration"],
//     price: ((double.tryParse(json["price"].toString()) ?? 0.0))
//         .toStringAsFixed(2),
//     isSubscribed: json["is_subscribed"],
//     isExpired: json["is_expired"] ?? false,
//     createdAt: DateTime.parse(json["created_at"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "name": name,
//     "details": details,
//     "duration": duration,
//     "price": price,
//     "is_subscribed": isSubscribed,
//     "is_expired": isExpired,
//     "created_at": createdAt.toIso8601String(),
//   };
// }
