import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/connection/connection.dart';
import 'package:superconnector_vm/core/models/selected_contacts.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/utils/constants/strings.dart';
import 'package:superconnector_vm/core/utils/nav/super_navigator.dart';
import 'package:superconnector_vm/ui/components/app_bars/custom_app_bar.dart';
import 'package:superconnector_vm/ui/components/buttons/new_connection_button.dart';
import 'package:superconnector_vm/ui/components/dialogs/super_dialog.dart';
import 'package:superconnector_vm/ui/screens/authenticated/components/connections/connection_tile.dart';
import 'package:superconnector_vm/ui/screens/authenticated/components/connections/connections_list.dart';
import 'package:superconnector_vm/ui/screens/home/components/home_title_bar.dart';

class Home extends StatefulWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isShowingDialog = false;
  late final FirebaseMessaging _messaging;

  // bool _isValidContact(Contact contact) {
  //   bool hasName = contact.displayName != null && contact.displayName != '';
  //   bool hasNumber = contact.phones != null && contact.phones!.isNotEmpty;

  //   return hasName && hasNumber;
  // }

  // Would love to sync contacts early but would required contact access
  // Future<void> _syncContacts() async {
  //   Iterable<Contact> contacts = await ContactsService.getContacts();
  //   contacts = contacts.where((contact) {
  //     return _isValidContact(contact);
  //   });

  //   final superuser = Provider.of<Superuser?>(context, listen: false);
  //   if (superuser != null) {
  //     SupercontactService().syncContacts(
  //       superuser,
  //       contacts.toList(),
  //     );
  //   }
  // }

  @override
  initState() {
    super.initState();
    // registerNotification();
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
  }

  void registerNotification() async {
    _messaging = FirebaseMessaging.instance;

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    NotificationSettings settings = await _messaging.getNotificationSettings();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print(
          'OnMessageListen Message title: ${message.notification?.title}, body: ${message.notification?.body}, data: ${message.data}',
        );
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }

  Future goToOnboardingStage(
    HomeOnboardingStage stage,
    Superuser superuser,
  ) async {
    superuser.homeOnboardingStage = stage;
    await superuser.update();
  }

  Future _showOnboardingDialog({
    required String title,
    required String subtitle,
    required Widget overlayWidget,
    required Function onTap,
  }) async {
    if (_isShowingDialog) {
      return;
    }

    setState(() {
      _isShowingDialog = true;
    });

    Function nextStep = () async {
      Navigator.of(context).pop();
      await onTap();
      setState(() {
        _isShowingDialog = false;
      });
    };

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Listener(
          onPointerUp: (e) => nextStep(),
          child: Stack(
            children: [
              overlayWidget,
              SuperDialog(
                title: title,
                subtitle: subtitle,
                primaryActionTitle: 'Continue',
                primaryAction: () {},
              ),
            ],
          ),
        );
      },
    );
  }

  Future _startOnboarding(
    Superuser superuser,
  ) async {
    switch (superuser.homeOnboardingStage) {
      case HomeOnboardingStage.connect:
        await _showOnboardingDialog(
          title: ConstantStrings.ONBOARDING_CONNECT_TITLE,
          subtitle: ConstantStrings.ONBOARDING_CONNECT_SUBTITLE,
          onTap: () => goToOnboardingStage(
            HomeOnboardingStage.connections,
            superuser,
          ),
          overlayWidget: Positioned(
            right: 16.0,
            bottom: 16.0,
            child: NewConnectionButton(
              isInverted: true,
              onPressed: () {
                SuperNavigator.handleContactsNavigation(
                  context: context,
                );
              },
            ),
          ),
        );
        break;
      case HomeOnboardingStage.connections:
        await _showOnboardingDialog(
          title: ConstantStrings.ONBOARDING_CONNECTIONS_TITLE,
          subtitle: ConstantStrings.ONBOARDING_CONNECTIONS_SUBTITLE,
          onTap: () => goToOnboardingStage(
            HomeOnboardingStage.completed,
            superuser,
          ),
          overlayWidget: Consumer<List<Connection>>(
            builder: (context, connections, child) {
              if (connections.length == 0) {
                return Container();
              }

              return Positioned(
                top: 60.0,
                left: 0.0,
                right: 0.0,
                child: Card(
                  elevation: 0.0,
                  margin: const EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                  child: ConnectionTile(
                    shouldIgnoreTaps: true,
                    connection: connections[0],
                  ),
                ),
              );
            },
          ),
        );
        break;
      // case HomeOnboardingStage.search:
      //   await _showOnboardingDialog(
      //     title: ConstantStrings.ONBOARDING_SEARCH_TITLE,
      //     subtitle: ConstantStrings.ONBOARDING_SEARCH_SUBTITLE,
      //     onTap: () => goToOnboardingStage(
      //       HomeOnboardingStage.completed,
      //       superuser,
      //     ),
      //     overlayWidget: Positioned(
      //       right: 76.0,
      //       top: 13.0,
      //       child: Image.asset(
      //         'assets/images/authenticated/search-icon-white.png',
      //         width: 26.0,
      //       ),
      //     ),
      //   );
      //   break;
      // case HomeOnboardingStage.settings:
      //   await _showOnboardingDialog(
      //     title: ConstantStrings.ONBOARDING_SETTINGS_TITLE,
      //     subtitle: ConstantStrings.ONBOARDING_SETTINGS_SUBTITLE,
      //     onTap: () => goToOnboardingStage(
      //       HomeOnboardingStage.newVM,
      //       superuser,
      //     ),
      //     overlayWidget: Positioned(
      //       right: 9.0,
      //       top: 4.0,
      //       child: SuperuserImage(
      //         url: superuser.photoUrl,
      //         radius: 21.0,
      //       ),
      //     ),
      //   );
      //   break;
      // case HomeOnboardingStage.newVM:
      //   await _showOnboardingDialog(
      //     title: ConstantStrings.ONBOARDING_NEW_VM_TITLE,
      //     subtitle: ConstantStrings.ONBOARDING_NEW_VM_SUBTITLE,
      //     onTap: () => goToOnboardingStage(
      //       HomeOnboardingStage.completed,
      //       superuser,
      //     ),
      //     overlayWidget: Positioned(
      //       right: 16.0,
      //       bottom: 16.0,
      //       child: NewConnectionButton(
      //         isInverted: true,
      //         onPressed: () {
      //           SuperNavigator.handleContactsNavigation(
      //             context: context,
      //           );
      //         },
      //       ),
      //     ),
      //   );
      //   break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    Superuser? superuser = Provider.of<Superuser?>(context);

    if (superuser == null) {
      return Container();
    }

    // var selectedContacts = Provider.of<SelectedContacts>(
    //   context,
    // );

    // Start onboarding cards after building
    // will use the stage a user left off at
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) async {
      // _startOnboarding(superuser);
    });

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomAppBar(
            backgroundColor: Colors.white,
          ),
          // floatingActionButton: NewConnectionButton(
          //   onPressed: () {
          //     selectedContacts.reset();
          //     SuperNavigator.handleContactsNavigation(context: context);
          //   },
          // ),
          body: Column(
            children: [
              HomeTitleBar(
                superuser: superuser,
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: ConnectionList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
