import '../../config/res/config_imports.dart';
import 'data/chat_notification_service.dart';

void setChatNotificationDependencies() => injector.registerLazySingleton<ChatNotificationService>(
      () => ChatNotificationServiceImpl(),
);