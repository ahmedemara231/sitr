import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/socket_service/client_io.dart';
import '../../data/socket_events.dart';

class SocketCubit extends Cubit<SocketHelper?> {
  SocketCubit() : super(null);

  void setSocket(SocketHelper socket) => emit(socket);

  void updateTimer({required int timer, required int roomId}) {
    log('the timer is from cubit $timer');
    log('the room id is from cubit $roomId');
    state?.emitEvent(
        event: SocketEvents.timer,
        data: {
          'timer' : timer,
          'room_id' : roomId
        }
    );
  }

  void fireShouldUpdate({required int roomId, required int matchRequestId, required int receiverId}) {
    state?.emitEvent(
      event: SocketEvents.updateChat,
      data: {
        'room_id' : roomId,
        'match_request_id': matchRequestId,
        'receiver_id': receiverId,
      },
    );
  }
}
