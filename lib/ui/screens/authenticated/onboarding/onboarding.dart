import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/connection/connection.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/models/video/video.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';
import 'package:superconnector_vm/core/utils/constants/strings.dart';
import 'package:superconnector_vm/ui/screens/authenticated/onboarding/components/onboarding_footer.dart';
import 'package:superconnector_vm/ui/screens/authenticated/onboarding/components/onboarding_info.dart';
import 'package:superconnector_vm/ui/screens/authenticated/onboarding/onboarding_background/onboarding_background.dart';
import 'package:superconnector_vm/ui/screens/authenticated/onboarding/onboarding_notifications/onboarding_notification.dart';
import 'package:superconnector_vm/ui/screens/authenticated/onboarding/onboarding_welcome/onboarding_welcome.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final CollectionReference connectionCollection =
      FirebaseFirestore.instance.collection('connections');
  final CollectionReference videoCollection =
      FirebaseFirestore.instance.collection('videos');
  final CollectionReference exampleVideoCollection =
      FirebaseFirestore.instance.collection('exampleVideos');

  @override
  Widget build(BuildContext context) {
    Superuser? superuser = context.watch<Superuser?>();

    if (superuser == null) {
      return Container();
    }

    return OnboardingPages(
      completePages: () async {
        var batch = FirebaseFirestore.instance.batch();

        var newConnectionDoc = connectionCollection.doc();
        Connection connection = Connection(
          id: newConnectionDoc.id,
          userIds: [
            superuser.id,
            ConstantStrings.SUPERCONNECTOR_ID,
          ],
          isExampleConversation: true,
          created: DateTime.now(),
          mostRecentActivity: DateTime.now(),
        );

        batch.set(
          newConnectionDoc,
          connection.toJson(),
        );

        var newVideoDoc = videoCollection.doc();
        var exampleVideoSnap = await exampleVideoCollection.get();

        exampleVideoSnap.docs.forEach((exampleVideo) {
          Video video = Video(
            assetId: exampleVideo['assetId'],
            connectionId: newConnectionDoc.id,
            uploadId: exampleVideo["uploadId"],
            superuserId: ConstantStrings.SUPERCONNECTOR_ID,
            playbackIds: [exampleVideo["playbackIds"].first],
            status: 'ready',
            caption: '',
            created: DateTime.now(),
            duration: 4.133333,
            views: 0,
            deleted: false,
          );

          batch.set(
            newVideoDoc,
            video.toJson(),
          );
        });

        batch.commit();
        superuser.onboarded = true;
        superuser.update();
      },
    );
  }
}

class OnboardingPages extends StatefulWidget {
  const OnboardingPages({
    Key? key,
    required this.completePages,
  }) : super(key: key);

  final Function completePages;

  @override
  _OnboardingPagesState createState() => _OnboardingPagesState();
}

class _OnboardingPagesState extends State<OnboardingPages> {
  final _pageController = PageController(
    initialPage: 0,
  );
  // final _pageController = PageController(
  //   initialPage: 0,
  // );
  double _currentIndex = 0;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // late List<Map<String, dynamic>> _onboardingPageMaps;
  bool _attemptedSubmission = false;

  List<Map<String, dynamic>> _getOnboardingPageMaps() {
    return [
      {
        'title': 'Welcome',
        'subtitle':
            'Superconnector helps you video\nmessage (VM) your extended family.\nVMs are a minute or less so they’re\nshort and sweet.',
        'widget': OnboardingWelcome(),
      },
      {
        'title': 'Account Info',
        'subtitle':
            'This helps set up your account and\nlabel your VMs. You can use VMs as a\nfaster, more convenient alternative to\nvideo calls.',
        'widget': OnboardingBackground(
          formKey: _formKey,
          attemptedSubmission: _attemptedSubmission,
        ),
      },
      {
        'title': 'Notifications',
        'subtitle':
            'These tell you when someone VMs you\nso you can reply quickly.',
        'widget': OnboardingNotifications(),
      },
    ];
  }

  @override
  void initState() {
    super.initState();

    /// Attach a listener which will update the state and refresh the page index
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
    _getOnboardingPageMaps().forEach((pageMap) {
      pages.add(
        Column(
          children: [
            Expanded(
              child: pageMap['widget'],
            ),
            OnboardingInfo(
              title: pageMap['title'],
              subtitle: pageMap['subtitle'],
            ),
          ],
        ),
      );
    });
    return pages;
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
    Superuser? superuser = context.watch<Superuser?>();

    if (superuser == null) {
      return Container();
    }

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: ConstantColors.DARK_BLUE,
        toolbarHeight: 0.0,
        elevation: 0.0,
        brightness: Brightness.dark,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: _currentIndex.round() == 1.0
              ? AlwaysScrollableScrollPhysics()
              : NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * .75,
                child: PageView(
                  // PageView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  // preloadPagesCount: 1,
                  children: _buildPages(),
                ),
              ),
              OnboardingFooter(
                currentIndex: _currentIndex,
                onContinue: () {
                  // Background page
                  if (_currentIndex.round() == 1) {
                    setState(() {
                      _attemptedSubmission = true;
                    });
                    if (_formKey.currentState != null &&
                        _formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      _goToNextPage();
                    }

                    return;
                  }

                  // // Industry page
                  // if (_currentIndex.round() == 2) {
                  //   setState(() {
                  //     _industrySubmissionAttempted = true;
                  //   });
                  //   if (superuser.industries.length > 0 &&
                  //       superuser.industries.length <= 3) {
                  //     _goToNextPage();
                  //   }
                  //   return;
                  // }

                  if (_currentIndex.round() == 2) {
                    widget.completePages();
                    // SuperNavigator.push(
                    //   context: context,
                    //   widget: OnboardingSettings(),
                    //   fullScreen: false,
                    // );
                  }

                  _goToNextPage();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
