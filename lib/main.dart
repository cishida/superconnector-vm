import 'package:camera/camera.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/services/auth/auth_service.dart';
import 'package:superconnector_vm/core/services/auth/auth_service_adapter.dart';
import 'package:superconnector_vm/theme/app_theme.dart';
import 'package:superconnector_vm/ui/screens/auth/auth_widget.dart';
import 'package:superconnector_vm/ui/screens/auth/auth_widget_builder.dart';

List<CameraDescription> cameras = [];
void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await Firebase.initializeApp();
  cameras = await availableCameras();

  runApp(
    SuperconnectorVM(),
  );
}

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print("Handling a background message: ${message.messageId}");
// }

class SuperconnectorVM extends StatefulWidget {
  @override
  _SuperconnectorVMState createState() => _SuperconnectorVMState();
}

class _SuperconnectorVMState extends State<SuperconnectorVM> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final AuthServiceType initialAuthServiceType = AuthServiceType.firebase;
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  // late final FirebaseMessaging _messaging;

  @override
  void initState() {
    // registerNotification();
    // checkForInitialMessage();

    // For handling notification when the app is in background
    // but not terminated
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   print(
    //     'Background: Message title: ${message.notification?.title}, body: ${message.notification?.body}, data: ${message.data}',
    //   );
    // });

    super.initState();
  }

  // void registerNotification() async {
  //   await Firebase.initializeApp();
  //   _messaging = FirebaseMessaging.instance;

  //   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  //   NotificationSettings settings = await _messaging.requestPermission(
  //     alert: true,
  //     badge: true,
  //     provisional: false,
  //     sound: true,
  //   );

  //   print('User granted permission: ${settings.authorizationStatus}');

  //   if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  //     print('User granted permission');

  //     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //       print(
  //         'OnMessageListen Message title: ${message.notification?.title}, body: ${message.notification?.body}, data: ${message.data}',
  //       );
  //     });
  //   } else {
  //     print('User declined or has not accepted permission');
  //   }
  // }

  // For handling notification when the app is in terminated state
  checkForInitialMessage() async {
    await Firebase.initializeApp();
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      print(
        'Initial Message: Message title: ${initialMessage.notification?.title}, body: ${initialMessage.notification?.body}, data: ${initialMessage.data}',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarBrightness: Brightness.dark));
    // FlutterStatusbarcolor.setStatusBarColor(ConstantColors.DARK_BLUE);
    // _firebaseMessaging.requestNotificationPermissions();

    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          print('Initialization error with firebase');
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
            providers: [
              Provider<AuthService>(
                create: (_) => AuthServiceAdapter(
                  initialAuthServiceType: initialAuthServiceType,
                ),
                dispose: (_, AuthService authService) => authService.dispose(),
              ),
              Provider<FirebaseAnalytics>(
                create: (_) => analytics,
              ),
            ],
            child: AuthWidgetBuilder(
              builder: (
                BuildContext context,
                AsyncSnapshot<SuperFirebaseUser> userSnapshot,
              ) {
                // final superuser = context.watch<Superuser?>();
                return MaterialApp(
                  title: 'Superconnector',
                  theme: appTheme(),
                  home: AuthWidget(userSnapshot: userSnapshot),
                  navigatorObservers: [
                    observer,
                  ],
                );
              },
            ),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
