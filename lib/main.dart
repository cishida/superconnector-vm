import 'package:camera/camera.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
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
  await Firebase.initializeApp();
  cameras = await availableCameras();

  runApp(
    SuperconnectorMessenger(),
  );
}

class SuperconnectorMessenger extends StatefulWidget {
  @override
  _SuperconnectorMessengerState createState() =>
      _SuperconnectorMessengerState();
}

class _SuperconnectorMessengerState extends State<SuperconnectorMessenger> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final AuthServiceType initialAuthServiceType = AuthServiceType.firebase;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarBrightness: Brightness.dark));
    // FlutterStatusbarcolor.setStatusBarColor(ConstantColors.DARK_BLUE);
    // _firebaseMessaging.requestNotificationPermissions();

    FirebaseAnalytics analytics = FirebaseAnalytics();

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
                    FirebaseAnalyticsObserver(analytics: analytics),
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
