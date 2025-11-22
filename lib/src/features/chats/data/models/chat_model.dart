import 'package:easy_chat/models/chat_message.dart';
import 'package:pagify/helpers/data_and_pagination_data.dart';

import '../../../../core/network/log_interceptor.dart';
import '../../../../core/shared/models/user_models/user_model.dart';

class ChatModel {
  final MatchRequest? matchRequest;
  final Room? room;

  ChatModel({this.matchRequest, this.room});

  ChatModel.fromJson(Map<String, dynamic> json)
      : matchRequest = json['match_request'] != null
      ? MatchRequest.fromJson(json['match_request'])
      : null,
        room = json['room'] != null ? Room.fromJson(json['room']) : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (matchRequest != null) data['match_request'] = matchRequest!.toJson();
    if (room != null) data['room'] = room!.toJson();
    return data;
  }

  ChatModel copyWith({
    MatchRequest? matchRequest,
    Room? room,
  }) {
    return ChatModel(
      matchRequest: matchRequest ?? this.matchRequest,
      room: room ?? this.room,
    );
  }
}

class MatchRequest {
  final int? id;
  final Type? type;
  final Stage? stage;
  final int? timer;
  final String? userRequest;
  final String? userRequestStatus;

  MatchRequest({
    this.id,
    this.type,
    this.stage,
    this.timer,
    this.userRequest,
    this.userRequestStatus,
  });

  MatchRequest.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        type = json['type'] != null ? Type.fromJson(json['type']) : null,
        stage = json['stage'] != null ? Stage.fromJson(json['stage']) : null,
        timer = json['timer'],
        userRequest = json['user_request'],
        userRequestStatus = json['user_request_status'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    if (type != null) data['type'] = type!.toJson();
    if (stage != null) data['stage'] = stage!.toJson();
    data['timer'] = timer;
    data['user_request'] = userRequest;
    data['user_request_status'] = userRequestStatus;
    return data;
  }

  MatchRequest copyWith({
    int? id,
    Type? type,
    Stage? stage,
    int? timer,
    String? userRequest,
    String? userRequestStatus,
  }) {
    return MatchRequest(
      id: id ?? this.id,
      type: type ?? this.type,
      stage: stage ?? this.stage,
      timer: timer ?? this.timer,
      userRequest: userRequest ?? this.userRequest,
      userRequestStatus: userRequestStatus ?? this.userRequestStatus,
    );
  }
}

class Type {
  final String? value;
  final String? title;

  Type({this.value, this.title});

  Type.fromJson(Map<String, dynamic> json)
      : value = json['value'],
        title = json['title'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['value'] = value;
    data['title'] = title;
    return data;
  }

  Type copyWith({
    String? value,
    String? title,
  }) {
    return Type(
      value: value ?? this.value,
      title: title ?? this.title,
    );
  }
}

class Stage {
  final String? value;
  final String? text;
  final String? description;

  Stage({this.value, this.text, this.description});

  Stage.fromJson(Map<String, dynamic> json)
      : value = json['value'],
        text = json['text'],
        description = json['description'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['value'] = value;
    data['text'] = text;
    data['description'] = description;
    return data;
  }

  Stage copyWith({
    String? value,
    String? text,
    String? description,
  }) {
    return Stage(
      value: value ?? this.value,
      text: text ?? this.text,
      description: description ?? this.description,
    );
  }
}

class Room {
  final int? id;
  final int? timer;
  final List<Members>? members;
  final Messages? messages;
  final String? lastMessageBody;
  final String? lastMessageCreatedDt;

  Room({
    this.id,
    this.timer,
    this.members,
    this.messages,
    this.lastMessageBody,
    this.lastMessageCreatedDt,
  });

  Room.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        timer = json['timer'],
        members = json['members'] != null
            ? (json['members'] as List)
            .map((v) => Members.fromJson(v))
            .toList()
            : null,
        messages =
        json['messages'] != null ? Messages.fromJson(json['messages']) : null,
        lastMessageBody = json['last_message_body'],
        lastMessageCreatedDt = json['last_message_created_dt'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['timer'] = timer;
    if (members != null) data['members'] = members!.map((v) => v.toJson()).toList();
    data['last_message_body'] = lastMessageBody;
    data['last_message_created_dt'] = lastMessageCreatedDt;
    return data;
  }

  Room copyWith({
    int? id,
    int? timer,
    List<Members>? members,
    Messages? messages,
    String? lastMessageBody,
    String? lastMessageCreatedDt,
  }) {
    return Room(
      id: id ?? this.id,
      timer: timer ?? this.timer,
      members: members ?? this.members,
      messages: messages ?? this.messages,
      lastMessageBody: lastMessageBody ?? this.lastMessageBody,
      lastMessageCreatedDt:
      lastMessageCreatedDt ?? this.lastMessageCreatedDt,
    );
  }
}

class Members {
  final int? id;
  final String? type;
  final String? name;
  final String? image;

  Members({this.id, this.type, this.name, this.image});

  Members.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        type = json['type'],
        name = json['name'],
        image = json['image'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['type'] = type;
    data['name'] = name;
    data['image'] = image;
    return data;
  }

  Members copyWith({
    int? id,
    String? type,
    String? name,
    String? image,
  }) {
    return Members(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      image: image ?? this.image,
    );
  }
}

class Messages {
  final PaginationData? pagination;
  final List<ChatMessages>? data;

  Messages({this.pagination, this.data});

  Messages.fromJson(Map<String, dynamic> json)
      : pagination = json['pagination'] != null
      ? PaginationData(
    perPage: json['pagination']['per_page'],
    totalPages: json['pagination']['total_pages'],
  )
      : null,
        data = json['data'] != null
            ? (json['data'] as List)
            .map((v) {
              logDebug('the v is $v');
              return ChatMessages(
                message: Message(
                    id: json['id'],
                    type: json['type'],
                    body: json['body']
                ),
                sender: Sender(
                    id: json['sender_id'],
                    name: json['sender_name'],
                    image: json['avatar'],
                    isFromMe: (json['sender_id'] == UserModel.currentUser?.id)? true : false
                ),
                time: json['created_dt'],
                // messageState: MessageState.sent
              );
        }
        ).toList()
            : null;

  Messages copyWith({
    PaginationData? pagination,
    List<ChatMessages>? data,
  }) {
    return Messages(
      pagination: pagination ?? this.pagination,
      data: data ?? this.data,
    );
  }
}

class Data {
  final int? id;
  final int? senderId;
  final bool? isSender;
  final String? body;
  final String? type;
  final int? duration;
  final String? name;
  final String? createdAt;
  final String? avatar;

  Data({
    this.id,
    this.senderId,
    this.isSender,
    this.body,
    this.type,
    this.duration,
    this.name,
    this.createdAt,
    this.avatar,
  });

  Data.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        senderId = json['sender_id'],
        isSender = json['is_sender'],
        body = json['body'],
        type = json['type'],
        duration = json['duration'],
        name = json['name'],
        createdAt = json['created_at'],
        avatar = json['avatar'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
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

  Data copyWith({
    int? id,
    int? senderId,
    bool? isSender,
    String? body,
    String? type,
    int? duration,
    String? name,
    String? createdAt,
    String? avatar,
  }) {
    return Data(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      isSender: isSender ?? this.isSender,
      body: body ?? this.body,
      type: type ?? this.type,
      duration: duration ?? this.duration,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      avatar: avatar ?? this.avatar,
    );
  }
}
