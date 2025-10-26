// class MessageModel {
//   int? id;
//   int? senderId;
//   bool? isSender;
//   String? body;
//   String? type;
//   int? duration;
//   String? name;
//   String? createdAt;
//   String? avatar;
//
//   MessageModel(
//       {this.id,
//         this.senderId,
//         this.isSender,
//         this.body,
//         this.type,
//         this.duration,
//         this.name,
//         this.createdAt,
//         this.avatar});
//
//   MessageModel.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     senderId = json['sender_id'];
//     isSender = json['is_sender'];
//     body = json['body'];
//     type = json['type'];
//     duration = json['duration'];
//     name = json['name'];
//     createdAt = json['created_at'];
//     avatar = json['avatar'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['sender_id'] = senderId;
//     data['is_sender'] = isSender;
//     data['body'] = body;
//     data['type'] = type;
//     data['duration'] = duration;
//     data['name'] = name;
//     data['created_at'] = createdAt;
//     data['avatar'] = avatar;
//     return data;
//   }
// }
