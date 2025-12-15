import '../../../config/res/config_imports.dart' show injector;
import '../presentation/cubits/end_video_call.dart';

void setUpChatDependencies(){
  injector.registerLazySingleton<EndVideoCallCubit>(
        () => EndVideoCallCubit(),
  );
}