# Satr Project — Core Rules & Patterns

This file documents the conventions, patterns, and APIs in `lib/src/core/` so you can build features correctly without re-reading the core every time.

---

## Architecture

Clean Architecture with three layers:
- **Domain**: `UseCase` / `UseCaseWithoutParam` → returns `Result<T, Failure>`
- **Data**: Repositories call `NetworkService` / `ObjectBoxCacheService`
- **Presentation**: Cubits extending `AsyncCubit<T>` or plain `Cubit<State>`

Dependency injection via `GetIt`: `injector<Type>()`

---

## Navigation — `Go` class

All navigation is done through the static `Go` class (`lib/src/core/navigation/navigator.dart`).
Never use `Navigator` directly.

```dart
// Push a page
Go.to(SomePage());

// Push with transition
Go.to(SomePage(), transitionType: TransitionType.slide);

// Push and remove current page
Go.off(SomePage());

// Push and clear entire stack
Go.offAll(SomePage());

// Named route
Go.toNamed(NamedRoutes.home);
Go.offAllNamed(NamedRoutes.login);

// Push only if not already on that route
Go.toOrOff(SomePage());

// Go back
Go.back();
Go.back(result); // with result

// Go back to root
Go.backToInitial();

// Access context anywhere
Go.context

// Available transition types
TransitionType.slide
TransitionType.fade
TransitionType.scale
TransitionType.cupertino
```

Route names are in `RouterConstants`. Always use `NamedRoutes` enum, not raw strings.

---

## Network — `NetworkService` / `DioService`

All API calls go through `NetworkService` (injected as `injector<NetworkService>()`).

### Making a request directly

```dart
final result = await networkService.callApi<MyModel>(
  NetworkRequest(
    path: ApiEndpoints.someEndpoint,
    method: RequestMethod.post,
    body: {'key': 'value'},
    queryParameters: {'page': 1},
  ),
  mapper: (json) => MyModel.fromJson(json),
);
```

### Using `BaseCrudUseCase` (preferred for standard CRUD)

```dart
final result = await baseCrudUseCase(CrudBaseParmas<MyModel>(
  api: ApiEndpoints.someEndpoint,
  httpRequestType: HttpRequestType.get,
  mapper: (json) => MyModel.fromJson(json),

  // Optional: cache to ObjectBox
  cacheKey: 'some_cache_key',
  fromCacheJson: (json) => MyModel.fromJson(json),
  toJson: (model) => model.toJson(),

  // Optional: pagination
  queryParameters: {'page': 1, 'per_page': 10},

  // Optional: file upload
  isFromData: true,
  onSendProgress: (sent, total) {},
));
```

### API Endpoints

All endpoints are static constants on `ApiEndpoints` class (`lib/src/core/network/api_endpoints.dart`).

### Request methods

```dart
RequestMethod.get
RequestMethod.post
RequestMethod.put
RequestMethod.patch
RequestMethod.delete
```

### Token management

```dart
networkService.setToken(token);   // called automatically by UserCubit.setUserLoggedIn
networkService.removeToken();      // called automatically by UserCubit.logout
```

---

## State Management — `AsyncCubit<T>`

Extend `AsyncCubit<T>` for any cubit that loads remote data.

```dart
class MyDataCubit extends AsyncCubit<List<MyModel>> {
  MyDataCubit() : super(AsyncState.initial(data: []));

  Future<void> loadData() async {
    await executeAsyncWithBaseModel(
      operation: () => baseCrudUseCase(CrudBaseParmas<List<MyModel>>(
        api: ApiEndpoints.something,
        httpRequestType: HttpRequestType.get,
        mapper: (json) => (json as List).map((e) => MyModel.fromJson(e)).toList(),
      )),
      onSuccess: (model) {
        // model.data is List<MyModel>
      },
      onError: (msg) {},
      withInternetInterceptor: true, // auto-retry on reconnect
    );
  }
}
```

### State shape

```dart
state.status  // BaseStatus enum
state.data    // T
state.msg     // String? (error message)

// Checks
state.status.isInitial
state.status.isLoading
state.status.isSuccess
state.status.isError
state.status.isLoadingMore
```

### Manual state transitions (when not using executeAsyncWithBaseModel)

```dart
setLoading();
setLoadingMore();
setSuccess();          // keeps current data
updateData(newData);   // sets data only
setError();
updateErrorMessage('msg');
reset();
```

---

## Local Storage

Two storage layers:

### `CacheStorage` — SharedPreferences (non-sensitive)

```dart
// Write
CacheStorage.write(key: 'my_key', value: 'string_value');
CacheStorage.write(key: 'my_key', value: 42);
CacheStorage.write(key: 'my_key', value: true);

// Read
final String? value = CacheStorage.read<String>(key: 'my_key');
final int? num     = CacheStorage.read<int>(key: 'my_key');
final bool? flag   = CacheStorage.read<bool>(key: 'my_key');

// Delete one
CacheStorage.delete(key: 'my_key');

// Clear all
CacheStorage.deleteAll();
```

### `SecureStorage` — FlutterSecureStorage (sensitive: tokens, passwords)

```dart
// Write
await SecureStorage.write(key: 'token', value: jwtToken);

// Read
final String? token = await SecureStorage.read(key: 'token');

// Delete
await SecureStorage.delete(key: 'token');

// Clear all
await SecureStorage.deleteAll();
```

### `ObjectBoxCacheService` — Structured JSON cache (API responses)

```dart
// Init once at app start
await ObjectBoxCacheService.init();

// Save
ObjectBoxCacheService.save('cache_key', jsonMap);

// Read (returns decoded Map or null)
final Map<String, dynamic>? cached = ObjectBoxCacheService.read('cache_key');

// Clear
ObjectBoxCacheService.clearAll();
```

Cache is automatically managed by `BaseCrudUseCase` when you pass `cacheKey` + `fromCacheJson` + `toJson`.

---

## User State — `UserCubit`

```dart
// Access anywhere
final userCubit = UserCubit.instance;

// Check login status
userCubit.isUserLoggedIn  // bool

// Get user model
userCubit.user  // UserModel

// Log in (sets token in Dio, saves to storage)
await userCubit.setUserLoggedIn(user: userModel, token: token);

// Update user data
await userCubit.updateUser(updatedUserModel);

// Update token only
await userCubit.updateToken(newToken);

// Logout (clears storage, removes Dio token, clears ObjectBox)
await userCubit.logout();
```

---

## Error Handling

### Result pattern

```dart
final result = await someUseCase(params);

result.when(
  success: (data) { /* data is T */ },
  error: (failure) { /* failure.message is String */ },
);

// Or in AsyncCubit via executeAsyncWithBaseModel — preferred
```

### Failure types

```dart
ServerFailure  // extends Failure
// failure.message contains the server error message
```

### Exception types (thrown inside data layer, caught by interceptors)

```
ServerException, FetchDataException, BadRequestException,
UnauthorizedException, NotFoundException, ConflictException,
InternalServerErrorException, NoInternetConnectionException,
CacheException, ForbiddenException, BlockedException
```

---

## Validation — `Validators`

All validation returns `String?` (null = valid, string = error message in locale key format).

```dart
Validators.validateEmpty(value)
Validators.validateName(value)
Validators.validateEmail(value)
Validators.validatePhone(value)          // Saudi format: starts with 5, 9 digits
Validators.validateAge(value)            // 18-150
Validators.validateOtpCode(value)        // exactly 4 digits
Validators.validateChatMessage(value)    // Arabic+English letters only
Validators.validateDowry(min, max)
Validators.validateIdentityNumber(value)
Validators.validateEmail(value)
Validators.noValidate(value)             // only checks script injection
```

---

## Extensions — Quick Reference

### Sized spacing

```dart
16.szH   // SizedBox(height: 16.h)
16.szW   // SizedBox(width: 16.w)
```

### Padding / Margin on Widget

```dart
widget.paddingAll(16)
widget.paddingSymmetric(horizontal: 16, vertical: 8)
widget.paddingOnly(top: 8, bottom: 8)
widget.paddingStart(16)    // RTL-aware
widget.paddingEnd(16)

widget.marginAll(16)
widget.marginSymmetric(horizontal: 16)
```

### Alignment

```dart
widget.centerWidget
widget.startWidget
widget.endWidget
```

### List separator

```dart
[widget1, widget2].joinWith(Divider())
// → [widget1, Divider(), widget2]
```

### List indexed map

```dart
items.indexedMap((index, item) => ItemWidget(index: index, item: item))
```

### Sliver

```dart
widget.toSliver()  // SliverToBoxAdapter
```

### Context

```dart
context.width
context.height
context.theme
context.textTheme
context.hideKeyboard()
context.isKeyboardOpen
context.isDark
```

### TextStyle

```dart
style.bold
style.semiBold
style.medium
style.s16         // font size 16
style.primaryColor
style.setFontSize(14)
style.setHeight(1.5)
```

### Bool

```dart
someCondition.toNormalLang()  // "yes" / "no" locale key
```

### Null check

```dart
someObject.isNull
someObject.isNotNull
```

### Back N times

```dart
3.pop()  // Go.back() called 3 times
```

### Form field wrapper

```dart
widget.asFormField<String>(validator: (v) => Validators.validateEmpty(v))
```

---

## Notifications

Notification handling is in `NotificationService` + `NotificationRoutes`.
Notification types are in `NotificationType` enum.

To navigate from a notification:
```dart
// In NotificationRoutes, add a new case in the switch for your NotificationType
// Use Go.toNamed() or Go.to() inside
```

To show local notification:
```dart
// Called internally by NotificationService._showNotification()
// Configure in setupNotifications()
```

---

## Socket (Chat)

```dart
final socket = ClientIOImpl(
  url: wsUrl,
  roomId: roomId,
  events: EasyChatEvents(
    messageEvents: MessageEvents(
      receiveMsgEvent: 'receive_message',
      sendMsgEvent: 'send_message',
    ),
    chatEvents: ChatEvents(
      enterChatEvent: 'enter_chat',
      exitChatEvent: 'exit_chat',
    ),
    otherEvents: ['typing', 'read'],
  ),
  jsonToChatMessage: (json) => ChatMessage.fromJson(json),
  onReceiveMessage: (msg) async { /* handle message */ },
  enableOfflineState: true,
);

await socket.initSocket();
await socket.connect();

// Send message
await socket.sendMessage({'message': text, 'room_id': roomId});

// Emit any event
await socket.emitEvent(event: 'typing', data: {'room_id': roomId});

// Check connection
socket.isConnected

// Disconnect
await socket.disconnect();
```

---

## Video Calls — `ZegoService`

```dart
final zego = ZegoService(
  appId: Constants.zegoAppId,
  appSign: Constants.zegoAppSign,
  navigatorKey: Go.navigatorKey,
);

await zego.initZego();

await zego.onUserLogin(
  currentUserId: user.id.toString(),
  currentUserName: user.name,
  onCallEnd: (event, defaultAction) { defaultAction(); },
);

// Create call button
zego.zegoButton(
  inviteeId: otherUserId,
  inviteeName: otherUserName,
  callType: ZegoCallType.videoCall,
);

// Logout on app sign-out
await zego.onUserLogout();
```

---

## Helpers

```dart
// Image picker
final File? image = await getImage();
final List<File> images = await getImages();
final File? photo = await getImageFromCameraOrDevice(context);

// Share app
shareApp();

// URL launchers
launchURL('https://...');
launchWhatsApp(phone);
callPhone(phone);
sendMail(email);
launchInstagram(handle);

// Permissions
await checkPermission(Permission.camera);

// Device type
getDeviceType()  // 'ios' | 'android'

// Status bar
changeStatusbarColor(color: Colors.white, isDark: true);

// RTL alignment
getAlignment  // Alignment.centerRight (AR) or Alignment.centerLeft (EN)

// Localization helper
showByLang(ar: 'عربي', en: 'English')
```

---

## BaseModel / PaginationResponse

API responses are always wrapped:

```dart
// Single item response
BaseModel<T>.fromJson(json, jsonToModel: (j) => T.fromJson(j))
// .key   → API key
// .msg   → success message
// .data  → T

// Paginated list response
PaginationResponse<T>.fromJson(json,
  mapper: (list) => (list as List).map((e) => T.fromJson(e)).toList(),
  dataKey: 'items',  // optional, default 'data'
)
// .data       → List<T>?
// .pagination → Pagination?
//   .currentPage, .totalPages, .totalItems, .nextPageUrl
```

---

## Use Case Pattern

```dart
// With params
class MyUseCase extends UseCase<MyModel, MyParams> {
  @override
  Future<Result<MyModel, Failure>> call(MyParams param) async {
    return repository.doSomething(param);
  }
}

// Without params
class MyUseCase extends UseCaseWithoutParam<MyModel> {
  @override
  Future<Result<MyModel, Failure>> call() async {
    return repository.doSomething();
  }
}
```

---

## App Lifecycle

```dart
AppLifecycleService.currentState   // AppLifecycleState
AppLifecycleService.isInForeground // bool
AppLifecycleService.isInBackground // bool

// Wrap widget to react to lifecycle
AppLifecycleManager(
  onResumed: () {},
  onPaused: () {},
  child: MyWidget(),
)
```

---

## Conventions

- **ScreenUtil sizing**: always use `.w`, `.h`, `.sp` — never raw pixel values
- **Locale keys**: always use `LocaleKeys.*` — never hardcode strings
- **Injection**: `injector<Type>()` from GetIt
- **Enums**: use `is*` extension checks, not equality comparisons
- **Backend type**: `BackendConfiguation.type.isPhp` / `.isAsp`
- **Colors/Text styles**: extend via TextStyle extensions, not inline styles
- **Bloc logging**: handled by `AppBlocObserver`, no need to add manual logs
