# Backend Handoff: `chat_request_sent`

## Required Change

Add a new chat eligibility reason:

```json
"chat_request_sent"
```

Use this reason when the current user has already sent the initial chat request message to the target user.

## Expected API Shape

For any endpoint that returns user chat eligibility, return:

```json
{
  "can_chat": false,
  "reason": "chat_request_sent"
}
```

The `check-chat-eligibility` endpoint should also return the same shape inside `data` when a chat request was already sent:

```json
{
  "key": "success",
  "msg": "Success",
  "data": {
    "can_chat": false,
    "reason": "chat_request_sent"
  }
}
```

The app still supports the old boolean `data: true` response for eligible users, but the object response is preferred so the UI can show the exact reason.

## Client Flow

When the sender taps Send Chat Request, the app:

1. Calls `check-chat-eligibility`.
2. Calls `start-chat` to get/create the room.
3. Initializes a socket connection from the chat button.
4. Sends a socket `send-message` event to the room with:

```json
{
  "room_id": 123,
  "receiver_id": 456,
  "body": "{sender_name} is trying to contact you",
  "type": "text"
}
```

After this message is sent, backend should treat the sender as not eligible to send another chat request to the same target and return `reason: "chat_request_sent"`.
