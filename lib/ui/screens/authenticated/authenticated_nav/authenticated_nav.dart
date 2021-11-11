import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';
import 'package:superconnector_vm/core/providers/bottom_nav_provider.dart';
import 'package:superconnector_vm/ui/screens/authenticated/account/account.dart';
import 'package:superconnector_vm/ui/screens/authenticated/authenticated_nav/components/authenticated_nav_tab_bar.dart';
import 'package:superconnector_vm/ui/screens/authenticated/camera/camera.dart';
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

  void _changeTab(int value) {
    Provider.of<BottomNavProvider>(
      context,
      listen: false,
    ).setIndex(value);
    _tabController.animateTo(value);
    setState(() {});
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
                  ],
                ),
              ),
              Container(
                height: bottomNavProvider.isSearching ? 0.0 : 80.0,
                padding: const EdgeInsets.only(
                  bottom: 24.0,
                ),
                width: MediaQuery.of(context).size.width,
                color: ConstantColors.DARK_BLUE,
                child: AuthenticatedNavTabBar(
                  changeTab: _changeTab,
                  showBadge: showChatsBadge,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
