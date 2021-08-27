import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:superconnector_vm/ui/screens/landing_container/components/confirmation_code_entry.dart';
import 'package:superconnector_vm/ui/screens/landing_container/components/initial_landing.dart';
import 'package:superconnector_vm/ui/screens/landing_container/components/phone_number_entry.dart';

class LandingContainer extends StatefulWidget {
  LandingContainer({
    Key? key,
  }) : super(key: key);

  @override
  _LandingContainerState createState() => _LandingContainerState();
}

class _LandingContainerState extends State<LandingContainer> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String? _verificationId;
  final _pageController = PageController(
    initialPage: 0,
  );
  double _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _pageController.addListener(() {
      if (_pageController.page != null &&
          _pageController.page! != _currentIndex) {
        setState(() {
          _currentIndex = _pageController.page!;
        });
      }
    });
  }

  List<Widget> _buildPages() {
    List<Widget> pages = [];
    pages.add(
      InitialLanding(
        onButtonPress: _goToNextPage,
      ),
    );

    pages.add(
      PhoneNumberEntry(
        setVerificationId: (String verificationId) {
          _verificationId = verificationId;
          _goToNextPage();
        },
        goBack: _goToPreviousPage,
      ),
    );

    pages.add(
      ConfirmationCodeEntry(
        verificationId: _verificationId,
        goBack: _goToPreviousPage,
      ),
    );
    return pages;
  }

  _goToPreviousPage() {
    FocusScope.of(context).unfocus();
    _pageController.previousPage(
      duration: Duration(milliseconds: 400),
      curve: Curves.fastOutSlowIn,
    );
  }

  _goToNextPage() {
    FocusScope.of(context).unfocus();
    _pageController.nextPage(
      duration: Duration(milliseconds: 400),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: _buildPages(),
        ),
      ),
    );
  }
}
