import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_base/src/features/connection_requests/data/models/message_request_model.dart';

void main() {
  test('maps the message request and required sender data', () {
    final MessageRequestModel request = MessageRequestModel.fromJson(const {
      'id': 91,
      'status': 'pending',
      'created_at': '2026-07-27T12:30:00Z',
      'can_accept': false,
      'accept_block_reason': 'active_current_chat',
      'sender': {
        'id': 42,
        'name': 'User name',
        'nick_name': 'Display name',
        'avatar': 'https://example.com/avatar.jpg',
        'age': 29,
        'city': 'Riyadh',
        'is_promoted': true,
      },
    });

    expect(request.id, 91);
    expect(request.status, 'pending');
    expect(request.canAccept, isFalse);
    expect(request.acceptBlockReason, 'active_current_chat');
    expect(request.sender.id, 42);
    expect(request.sender.displayName, 'Display name');
    expect(request.sender.isPromoted, isTrue);
    expect(request.toJson()['sender'], request.sender.toJson());
  });

  test('uses the sender name when the nickname is empty', () {
    final MessageRequestUserModel sender =
        MessageRequestUserModel.fromJson(const {
      'id': 42,
      'name': 'User name',
    });

    expect(sender.displayName, 'User name');
    expect(sender.age, 0);
    expect(sender.city, isEmpty);
  });
}
