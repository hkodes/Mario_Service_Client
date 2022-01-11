import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'views/splashscreen/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.

  print(
      "Handling a background message: SERVICE mARio usER APPO ${message.toString()}");
  String text = message.data['message'].toString();
  if (message.notification != null) {
    text += message.notification.toString();
  }

  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
    'channel id 1',
    'channel name 1',
    'channel desc 1',
    importance: Importance.max,
    playSound: true,
    priority: Priority.high,
  );

  var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
  var platformChannelSpecifics = new NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
    0,
    'Mario Service alert',
    text,
    platformChannelSpecifics,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await ServiceLocator.init();
  await Firebase.initializeApp();
  String a = await FirebaseMessaging.instance.getToken();
  var initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/launcher_icon');
  var initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: selectNotification);
  print("TOKEN RECEIVED FROM FIREBASE $a");
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  _requestPermission();
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    String text = message.data['message'].toString();

    if (message.notification != null) {
      text += message.notification.toString();
    }

    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'channel id 3',
      'channel name 3',
      'channel desc 3',
      importance: Importance.max,
      playSound: false,
      priority: Priority.high,
    );

    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Service Mario Alert',
      text,
      platformChannelSpecifics,
    );
    print('Got a message whilst in the foreground! user ');
    print('Message data: ${message.data}');
    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });
  // Bloc.observer = SimpleBlocObserver();
  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ],
  );

  //initilize inappbrowswer
  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);

    var swAvailable = await AndroidWebViewFeature.isFeatureSupported(
        AndroidWebViewFeature.SERVICE_WORKER_BASIC_USAGE);
    var swInterceptAvailable = await AndroidWebViewFeature.isFeatureSupported(
        AndroidWebViewFeature.SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST);

    if (swAvailable && swInterceptAvailable) {
      AndroidServiceWorkerController serviceWorkerController =
          AndroidServiceWorkerController.instance();

      serviceWorkerController.serviceWorkerClient = AndroidServiceWorkerClient(
        shouldInterceptRequest: (request) async {
          return null;
        },
      );
    }
  }
  runApp(MyApp());
}

Future selectNotification(String payload) async {
  await flutterLocalNotificationsPlugin.cancelAll();
}

Future<void> _requestPermission() async {
  try {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  } catch (e) {
    print(e);
  }
}

class MyApp extends StatelessWidget {
  static const base_gray = const Color(0xff85878b);
  static const base_light_gray = const Color(0xffdfe4ef);
  static const primary_color = const Color(0xfffc6011);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Service Mario',
      theme: ThemeData(
        primaryColor: primary_color,
        brightness: Brightness.light,
        // colorScheme:
        // ColorScheme(primary: primary_color, secondary: primary_color),
        iconTheme: IconThemeData(color: base_gray),

        textTheme: TextTheme(
          // headline1: TextStyle(color: Colors.red),
          // headline2: TextStyle(color: Colors.red),
          // headline3: TextStyle(color: Colors.red),
          // headline4: TextStyle(color: Colors.red),
          // headline5: TextStyle(color: Colors.red),
          // headline6: TextStyle(color: Colors.red),
          // caption: TextStyle(color: Colors.red),
          // bodyText1: TextStyle(color: Colors.red),
          // bodyText2: TextStyle(color: Colors.red),
          subtitle1: TextStyle(
            fontWeight: FontWeight.w400,
          ),
          // overline: TextStyle(color: Colors.red),
          // button: TextStyle(color: Colors.red)
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              decorationColor: const Color(0xff26282d),
              letterSpacing: 1.5),

          disabledBorder: new UnderlineInputBorder(
            borderSide: BorderSide(color: base_light_gray),
          ),
          enabledBorder: new UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.green),
          ),
// and:
          focusedBorder: new UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.green),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.disabled)) return Colors.grey;
                return primary_color;
              },
            ),
            minimumSize: MaterialStateProperty.resolveWith<Size>(
              (states) => Size(50, 50),
            ),
            // elevation: MaterialStateProperty.resolveWith<double>(
            //   (Set<MaterialState> states) {
            //     return 0.0;
            //   },
            // ),
            padding: MaterialStateProperty.resolveWith<EdgeInsetsGeometry>(
              (Set<MaterialState> states) {
                return const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0);
              },
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                return base_gray;
              },
            ),
          ),
        ),
        appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            // color: Colors.green,
            iconTheme: IconThemeData(color: base_gray, size: 8),
            textTheme: TextTheme(
              headline6: TextStyle(
                fontFamily: 'Metropolis',
                fontSize: 20,
                color: const Color(0xff4a4b4d),
                fontWeight: FontWeight.w700,
              ),
            ),
            titleTextStyle: TextStyle(
              fontFamily: 'Metropolis',
              fontSize: 24,
              // groundColor: Colors.orange,
              color: const Color(0xff000000),
              fontWeight: FontWeight.w700,
            ),
            centerTitle: false),
      ),
      home: SplashScreen(),
    );
  }
}
