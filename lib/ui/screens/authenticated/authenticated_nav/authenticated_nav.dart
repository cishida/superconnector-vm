import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';
import 'package:superconnector_vm/core/providers/bottom_nav_provider.dart';
import 'package:superconnector_vm/core/utils/nav/super_navigator.dart';
import 'package:superconnector_vm/ui/screens/authenticated/account/account.dart';
import 'package:superconnector_vm/ui/screens/authenticated/authenticated_nav/components/bottom_nav_button.dart';
import 'package:superconnector_vm/ui/screens/authenticated/camera/camera.dart';
import 'package:superconnector_vm/ui/screens/authenticated/record/record_permission/record_permission.dart';
import 'package:superconnector_vm/ui/screens/home/home.dart';

class AuthenticatedNav extends StatefulWidget {
  const AuthenticatedNav({Key? key}) : super(key: key);

  @override
  _AuthenticatedNavState createState() => _AuthenticatedNavState();
}

class _AuthenticatedNavState extends State<AuthenticatedNav>
    with
        WidgetsBindingObserver,
        AutomaticKeepAliveClientMixin<AuthenticatedNav>,
        SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool awaitingOnboarding = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized().addObserver(this);
    super.initState();

    _tabController = TabController(
      initialIndex: 1,
      vsync: this,
      length: 3,
    );

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        FocusScope.of(context).unfocus();
      }
    });
  }

  @override
  void dispose() {
    WidgetsFlutterBinding.ensureInitialized().removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      setState(() {});
    }
  }

  // void handleRecordNavigation({
  //   required BuildContext context,
  // }) async {
  //   var cameraStatus = await Permission.camera.status;
  //   var microphoneStatus = await Permission.microphone.status;

  //   if (cameraStatus.isGranted && microphoneStatus.isGranted) {
  //     _toCamera();
  //   } else {
  //     SuperNavigator.push(
  //       context: context,
  //       widget: RecordPermission(
  //         callback: _toCamera,
  //       ),
  //       fullScreen: false,
  //     );
  //   }
  // }

  void _toCamera() {
    Provider.of<BottomNavProvider>(
      context,
      listen: false,
    ).setIndex(1);
    _tabController.animateTo(1);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final superuser = context.watch<Superuser?>();
    final bottomNavProvider = Provider.of<BottomNavProvider>(context);

    if (superuser == null || superuser.id == '') {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      bool showChatsBadge = superuser.unseenNotificationCount > 0;

      if (showChatsBadge) {
        setState(() {});
      }

      _tabController.animateTo(bottomNavProvider.pageIndex);

      return Material(
        color: ConstantColors.DARK_BLUE,
        child: DefaultTabController(
          length: 3,
          child: Column(
            children: [
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    Home(),
                    Camera(),
                    Account(),
                    // Record(
                    //   shouldGoBack: false,
                    // ),

                    // Container(),
                    // Container(),
                    // Container(),
                    // Container(),
                  ],
                ),
              ),
              // Container(
              //   height: 1.0,
              //   color: ConstantColors.DIVIDER_GRAY,
              // ),
              Container(
                height: bottomNavProvider.isSearching ? 0.0 : 80.0,
                padding: const EdgeInsets.only(
                  bottom: 24.0,
                ),
                width: MediaQuery.of(context).size.width,
                color: ConstantColors.DARK_BLUE,
                child: TabBar(
                  isScrollable: false,
                  indicatorColor: Colors.transparent,
                  automaticIndicatorColorAdjustment: false,
                  onTap: (value) {
                    // if (value == 1) {
                    //   handleRecordNavigation(context: context);
                    // } else {
                    Provider.of<BottomNavProvider>(
                      context,
                      listen: false,
                    ).setIndex(value);
                    _tabController.animateTo(value);
                    // }
                    // switch (value) {
                    //   case 1:
                    //     selectedContacts.reset();
                    //     SuperNavigator.handleContactsNavigation(
                    //       context: context,
                    //     );
                    //     break;
                    //   case 2:
                    //     SuperNavigator.handleRecordNavigation(
                    //       context: context,
                    //     );
                    //     break;
                    //   case 3:
                    //     bottomNavProvider.setIsSearching(true);
                    //     break;
                    //   case 4:
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => Account(),
                    //       ),
                    //     );
                    //     break;
                    //   default:
                    //     Provider.of<BottomNavProvider>(
                    //       context,
                    //       listen: false,
                    //     ).setIndex(value);
                    //     _tabController.animateTo(value);
                    //     break;
                    // }
                    setState(() {});
                  },
                  tabs: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: BottomNavButton(
                        title: 'camera-rolls',
                        // showBadge: false,
                        selected: _tabController.index == 0,
                      ),
                    ),
                    BottomNavButton(
                      title: 'camera',
                      selected: _tabController.index == 1,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: BottomNavButton(
                        title: 'settings',
                        selected: _tabController.index == 2,
                        imageHeight: 24.0,
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(bottom: 4.0),
                    //   child: Image.asset(
                    //     'assets/images/authenticated/bottom_nav/bottom-nav-record.png',
                    //     height: 48.0,
                    //   ),
                    // ),
                    // BottomNavButton(
                    //   title: 'search',
                    //   showBadge: showChatsBadge,
                    //   selected: _tabController.index == 3,
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
