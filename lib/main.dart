// ignore_for_file: prefer_const_constructors
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:todo_app_riverpod/utils/general_providers.dart';
import 'package:todo_app_riverpod/view/signin_page.dart';
import 'package:todo_app_riverpod/view/todo_edit_page.dart';
import 'package:todo_app_riverpod/view_model/controller/theme_controller.dart';
import 'package:todo_app_riverpod/utils/dark_theme.dart';
import 'package:todo_app_riverpod/utils/light_theme.dart';
import 'package:todo_app_riverpod/utils/page_route.dart';
import 'package:todo_app_riverpod/view/top_page.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message ${message.messageId}");
}

/// Create a [AndroidNotificationChannel] for heads up notifications
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  importance: Importance.high,
  enableVibration: true,
  playSound: true,
  description:
      'This channel is used for important notifications.', // description
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  // await DotEnv.load(fileName: '.env');

  //カレンダーを日本語表記にするために'initializeDateFormatting().then((_) =>'
  initializeDateFormatting().then((_) => runApp(ProviderScope(child: MyApp())));
}

class MyApp extends HookConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeSelectorProvider);
    //FCMトークンの取得
    FirebaseMessaging.instance.getToken().then((token) {
      print(token);
    });

    useEffect(() {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        if (notification != null && android != null) {
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                // channel.description,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: 'launch_background',
              ),
            ),
          );
        }
      });
    }, const []);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: themeMode == ThemeMode.dark ? darkThemeData : lightThemeData,
      darkTheme: themeMode == ThemeMode.light ? lightThemeData : darkThemeData,
      routes: <String, WidgetBuilder>{
        Const.routeNameUpsertTodo: (BuildContext context) => TodoEditPage(),
      },
      home: StreamBuilder(
        stream: ref.watch(firebaseAuthProvider).authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            return RoutePage();
          } else {
            return SignInPage();
          }
        },
      ),
    );
  }
}
