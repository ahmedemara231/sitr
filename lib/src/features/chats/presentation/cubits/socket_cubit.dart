import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/socket_service/client_io.dart';

class SocketCubit extends Cubit<SocketHelper?> {
  SocketCubit() : super(null);

  void setSocket(SocketHelper socket) => emit(socket);
}
