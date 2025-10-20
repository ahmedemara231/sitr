import 'package:pagify/helpers/data_and_pagination_data.dart';

class ChatModel {
  MatchRequest? matchRequest;
  Room? room;

  ChatModel({this.matchRequest, this.room});

  ChatModel.fromJson(Map<String, dynamic> json) {
    matchRequest = json['match_request'] != null
        ? MatchRequest.fromJson(json['match_request'])
        : null;
    room = json['room'] != null ? Room.fromJson(json['room']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (matchRequest != null) {
      data['match_request'] = matchRequest!.toJson();
    }
    if (room != null) {
      data['room'] = room!.toJson();
    }
    return data;
  }
}

class MatchRequest {
  int? id;
  Type? type;
  Stage? stage;
  int? timer;
  bool? nextStageRequest;
  bool? continueStageRequest;
  String? userRequest;
  String? userRequestStatus;

  MatchRequest(
      {this.id,
        this.type,
        this.stage,
        this.timer,
        this.nextStageRequest,
        this.continueStageRequest,
        this.userRequest,
        this.userRequestStatus});

  MatchRequest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'] != null ? Type.fromJson(json['type']) : null;
    stage = json['stage'] != null ? Stage.fromJson(json['stage']) : null;
    timer = json['timer'];
    nextStageRequest = json['next_stage_request'];
    continueStageRequest = json['continue_stage_request'];
    userRequest = json['user_request'];
    userRequestStatus = json['user_request_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (type != null) {
      data['type'] = type!.toJson();
    }
    if (stage != null) {
      data['stage'] = stage!.toJson();
    }
    data['timer'] = timer;
    data['next_stage_request'] = nextStageRequest;
    data['continue_stage_request'] = continueStageRequest;
    data['user_request'] = userRequest;
    data['user_request_status'] = userRequestStatus;
    return data;
  }
}

class Type {
  String? value;
  String? title;

  Type({this.value, this.title});

  Type.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    data['title'] = title;
    return data;
  }
}

class Stage {
  String? value;
  String? text;
  String? description;

  Stage({this.value, this.text, this.description});

  Stage.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    text = json['text'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    data['text'] = text;
    data['description'] = description;
    return data;
  }
}

class Room {
  int? id;
  int? timer;
  List<Members>? members;
  Messages? messages;
  String? lastMessageBody;
  String? lastMessageCreatedDt;

  Room(
      {this.id,
        this.timer,
        this.members,
        this.messages,
        this.lastMessageBody,
        this.lastMessageCreatedDt});

  Room.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    timer = json['timer'];
    if (json['members'] != null) {
      members = <Members>[];
      json['members'].forEach((v) {
        members!.add(Members.fromJson(v));
      });
    }
    messages = json['messages'] != null
        ? Messages.fromJson(json['messages'])
        : null;
    lastMessageBody = json['last_message_body'];
    lastMessageCreatedDt = json['last_message_created_dt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['timer'] = timer;
    if (members != null) {
      data['members'] = members!.map((v) => v.toJson()).toList();
    }
    if (messages != null) {
      data['messages'] = messages!.toJson();
    }
    data['last_message_body'] = lastMessageBody;
    data['last_message_created_dt'] = lastMessageCreatedDt;
    return data;
  }
}

class Members {
  int? id;
  String? type;
  String? name;
  String? image;

  Members({this.id, this.type, this.name, this.image});

  Members.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['name'] = name;
    data['image'] = image;
    return data;
  }
}

class Messages {
  PaginationData? pagination;
  List<Data>? data;

  Messages({this.pagination, this.data});

  Messages.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? PaginationData(perPage: json['pagination']['per_page'], totalPages: json['pagination']['total_pages'])
        : null;
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // if (pagination != null) {
    //   data['pagination'] = pagination!.toJson();
    // }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

// class Pagination {
//   int? totalItems;
//   int? countItems;
//   int? perPage;
//   int? totalPages;
//   int? currentPage;
//   String? nextPageUrl;
//   String? pervPageUrl;
//
//   Pagination(
//       {this.totalItems,
//         this.countItems,
//         this.perPage,
//         this.totalPages,
//         this.currentPage,
//         this.nextPageUrl,
//         this.pervPageUrl});
//
//   Pagination.fromJson(Map<String, dynamic> json) {
//     totalItems = json['total_items'];
//     countItems = json['count_items'];
//     perPage = json['per_page'];
//     totalPages = json['total_pages'];
//     currentPage = json['current_page'];
//     nextPageUrl = json['next_page_url'];
//     pervPageUrl = json['perv_page_url'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['total_items'] = totalItems;
//     data['count_items'] = countItems;
//     data['per_page'] = perPage;
//     data['total_pages'] = totalPages;
//     data['current_page'] = currentPage;
//     data['next_page_url'] = nextPageUrl;
//     data['perv_page_url'] = pervPageUrl;
//     return data;
//   }
// }

class Data {
  int? id;
  int? senderId;
  bool? isSender;
  String? body;
  String? type;
  int? duration;
  String? name;
  String? createdAt;
  String? avatar;

  Data(
      {this.id,
        this.senderId,
        this.isSender,
        this.body,
        this.type,
        this.duration,
        this.name,
        this.createdAt,
        this.avatar});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    senderId = json['sender_id'];
    isSender = json['is_sender'];
    body = json['body'];
    type = json['type'];
    duration = json['duration'];
    name = json['name'];
    createdAt = json['created_at'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sender_id'] = senderId;
    data['is_sender'] = isSender;
    data['body'] = body;
    data['type'] = type;
    data['duration'] = duration;
    data['name'] = name;
    data['created_at'] = createdAt;
    data['avatar'] = avatar;
    return data;
  }
}
