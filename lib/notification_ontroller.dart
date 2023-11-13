import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
//import 'package:hiz_app/Application/General/general_provider.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
  NotificationController notificationController = Get.put(NotificationController());
  notificationController.getNotification(message);
}

//TODO: changes
class NotificationController extends GetxController {
  GetStorage box = GetStorage('notificstions');
  RxInt _notificationsNumber = 0.obs;
  get notificationsNumber => this._notificationsNumber.value;
  set notificationsNumber(value) => this._notificationsNumber.value = value;

  setNotifications(value) {
    notificationsNumber = value;
    box.write('notificationsNumber', value);
  }

  RxInt _messagesNumber = 0.obs;
  get messagesNumber => this._messagesNumber.value;
  set messagesNumber(value) => this._messagesNumber.value = value;

  setMessages(value) {
    messagesNumber = value;
    box.write('messagesNumber', value);
  }

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  Future<String?> getToken({required Function(String) refreshToken}) async {
    String? token;
    try {
      token = (await firebaseMessaging.getToken(
        vapidKey: "BGpdLRs......",
      ))!;
    } catch (e) {
      print(e);
    }
    if (refreshToken != null)
      firebaseMessaging.onTokenRefresh.listen((token) => refreshToken);
    return token;
  }

  void fireBase() async {
    firebaseMessaging.getInitialMessage();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      getNotification(message);
    });
  }

  getNotification(RemoteMessage message) {
    print('Message');
    if (message.notification != null) {
      bool isNotification = true;
      try {
        if (message.data['type'] == 'message') {
          isNotification = false;
        }
      } catch (e) {}
      String payload;
      if (isNotification) {
        setNotifications(notificationsNumber + 1);
        payload = 'notifications $notificationsNumber';
      } else {
        setMessages(messagesNumber + 1);
        payload = 'messages $messagesNumber';
      }
      showNotification(
        title: message.notification!.title.toString(),
        summaryText: '',
        payload: payload,
        lines: [message.notification!.body.toString()],
        id: notificationsNumber + messagesNumber,
      );
    }
  }

  showNotification({
    required String title,
    required String summaryText,
    required String payload,
    required List<String> lines,
    required int id,
  }) async {
    var android = AndroidNotificationDetails('channelId', 'channelName', importance: Importance.max,
      priority: Priority.max,
      groupKey: 'my group',
      setAsGroupSummary: true,
      enableVibration: true,
      groupAlertBehavior: GroupAlertBehavior.all,
      styleInformation: InboxStyleInformation(
        lines,
        contentTitle: title,
        summaryText: summaryText,
      ),
    );
    var ios = DarwinNotificationDetails();
    var platform = NotificationDetails(android: android, iOS: ios);
    await flutterLocalNotificationsPlugin.show(id, title, lines[0], platform, payload: payload);
  }

  onInitAsync() async {
    await box.initStorage;
    if (box.hasData('notificationsNumber')) {
      notificationsNumber = box.read('notificationsNumber') ?? 0;
    } else {
      notificationsNumber = 0;
    }
    setNotifications(notificationsNumber);
    if (box.hasData('messagesNumber')) {
      messagesNumber = box.read('messagesNumber') ?? 0;
    } else {
      messagesNumber = 0;
    }
    setMessages(messagesNumber);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
    var android = AndroidInitializationSettings('@mipmap/logo');
    var ios = DarwinInitializationSettings ();
    var initSettings = InitializationSettings(android: android, iOS: ios);
    flutterLocalNotificationsPlugin.initialize(
      initSettings,
      /*onSelectNotification: (payload) {
        print(Get.context);
        if (payload!.split(' ')[0] == 'messages') {
          setMessages(0);
          box.write('messagesNumber', 0);
          //Provider.of<GeneralProvider>(Get.context, listen: false).changeCurrentIndex(2);
        } else {
          setNotifications(0);
          box.write('notificationsNumber', 0);
          //Provider.of<GeneralProvider>(Get.context, listen: false).changeCurrentIndex(1);
        }
        return;
      },*/
    );

    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
    fireBase();
  }

  @override
  void onInit() {
    onInitAsync();
    super.onInit();
  }
}

