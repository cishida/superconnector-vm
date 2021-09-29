import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/selected_contacts.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/services/superuser/superuser_service.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';
import 'package:superconnector_vm/core/utils/nav/authenticated_controller.dart';
import 'package:superconnector_vm/core/utils/nav/super_navigator.dart';
import 'package:superconnector_vm/ui/screens/authenticated/account/account.dart';
import 'package:superconnector_vm/ui/screens/authenticated/authenticated_nav/components/bottom_nav_button.dart';
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
      vsync: this,
      length: 5,
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final superuser = context.watch<Superuser?>();
    final authenticatedController =
        Provider.of<AuthenticatedController>(context);
    var selectedContacts = Provider.of<SelectedContacts>(
      context,
    );
    SuperuserService _superuserService = SuperuserService();

    if (superuser == null || superuser.id == '') {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      bool showChatsBadge = superuser.unseenNotificationCount > 0;

      if (showChatsBadge) {
        setState(() {});
      }

      _tabController.animateTo(authenticatedController.pageIndex);

      return Material(
        color: Colors.white,
        child: DefaultTabController(
          length: 5,
          child: Column(
            children: [
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    Home(),
                    Container(),
                    Container(),
                    Container(),
                    Container(),
                  ],
                ),
              ),
              Container(
                height: 1.0,
                color: ConstantColors.DIVIDER_GRAY,
              ),
              Container(
                height: authenticatedController.isSearching ? 0.0 : 92.0,
                padding: const EdgeInsets.only(
                  bottom: 24.0,
                ),
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: TabBar(
                  isScrollable: false,
                  indicatorColor: Colors.transparent,
                  automaticIndicatorColorAdjustment: false,
                  onTap: (value) {
                    switch (value) {
                      case 1:
                        selectedContacts.reset();
                        SuperNavigator.handleContactsNavigation(
                          context: context,
                        );
                        break;
                      case 3:
                        authenticatedController.setIsSearching(true);
                        break;
                      case 4:
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Account(),
                          ),
                        );
                        break;
                      default:
                        Provider.of<AuthenticatedController>(
                          context,
                          listen: false,
                        ).setIndex(value);
                        _tabController.animateTo(value);
                        break;
                    }
                    setState(() {});
                  },
                  tabs: [
                    BottomNavButton(
                      title: 'home',
                      selected: _tabController.index == 0,
                    ),
                    BottomNavButton(
                      title: 'connect',
                      selected: _tabController.index == 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Image.asset(
                        'assets/images/authenticated/bottom_nav/bottom-nav-record.png',
                        height: 48.0,
                      ),
                    ),
                    BottomNavButton(
                      title: 'search',
                      showBadge: showChatsBadge,
                      selected: _tabController.index == 3,
                    ),
                    BottomNavButton(
                      title: 'settings',
                      showBadge: false,
                      selected: _tabController.index == 4,
                    ),
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