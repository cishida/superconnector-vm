import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/connection/connection.dart';
import 'package:superconnector_vm/core/models/selected_contacts.dart';
import 'package:superconnector_vm/core/models/supercontact/supercontact.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/models/video/video.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';
import 'package:superconnector_vm/core/utils/nav/super_navigator.dart';
import 'package:superconnector_vm/ui/components/buttons/chevron_back_button.dart';
import 'package:superconnector_vm/ui/components/dialogs/super_dialog.dart';
import 'package:superconnector_vm/ui/screens/authenticated/connection_carousel/components/carousel_video_player.dart';
import 'package:superconnector_vm/ui/screens/authenticated/connection_grid/connection_grid.dart';

class ConnectionCarousel extends StatefulWidget {
  const ConnectionCarousel({
    Key? key,
    required this.connection,
    required this.videos,
    this.initialIndex = 0,
  }) : super(key: key);

  final Connection connection;
  final List<Video> videos;
  final int initialIndex;

  @override
  _ConnectionCarouselState createState() => _ConnectionCarouselState();
}

class _ConnectionCarouselState extends State<ConnectionCarousel> {
  void _showBlockedCard({
    required Superuser superuser,
    required String blockedId,
  }) async {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Stack(
          children: [
            SuperDialog(
              title: 'Blocked',
              subtitle:
                  'If you continue, you’ll unblock them so you can send a reply.',
              primaryActionTitle: 'Continue',
              primaryAction: () async {
                await superuser.unblock(blockedId);
                Navigator.pop(context);
                _toRecord();
              },
              secondaryActionTitle: 'Cancel',
              secondaryAction: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _handleReply() {
    Superuser? superuser = Provider.of<Superuser?>(
      context,
      listen: false,
    );

    if (superuser == null) {
      return;
    }

    String targetUserId =
        widget.connection.userIds.firstWhere((e) => e != superuser.id);

    // if 1 on 1 connection and blocked user
    if (widget.connection.userIds.length == 2 &&
        superuser.blockedUserIds.contains(targetUserId)) {
      _showBlockedCard(
        superuser: superuser,
        blockedId: targetUserId,
      );
      return;
    }

    _toRecord();
  }

  void _toRecord() {
    var selectedContacts = Provider.of<SelectedContacts>(
      context,
      listen: false,
    );
    var supercontacts = Provider.of<List<Supercontact>>(
      context,
      listen: false,
    );

    selectedContacts.setContactsFromConnection(
      connection: widget.connection,
      supercontacts: supercontacts,
    );
    SuperNavigator.handleRecordNavigation(context);
  }

  @override
  Widget build(BuildContext context) {
    TextStyle bottomNavStyle = TextStyle(
      color: ConstantColors.TURQUOISE,
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
    );

    var selectedContacts = Provider.of<SelectedContacts>(context);
    var supercontacts = Provider.of<List<Supercontact>>(context);

    return Scaffold(
      backgroundColor: ConstantColors.DARK_BLUE,
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   brightness: Brightness.dark,
      //   elevation: 0.0,
      //   toolbarHeight: 0.0,
      // ),
      body: Stack(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: double.infinity,
              viewportFraction: 1.0,
              scrollDirection: Axis.vertical,
              enableInfiniteScroll: false,
              initialPage: widget.initialIndex,
            ),
            items: widget.videos.map(
              (video) {
                return Builder(
                  builder: (BuildContext context) {
                    return CarouselVideoPlayer(
                      video: video,
                    );
                  },
                );
              },
            ).toList(),
          ),
          Positioned(
            top: 50.0,
            left: 8.0,
            child: ChevronBackButton(
              onBack: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: ConstantColors.DARK_BLUE,
        child: Container(
          height: 55.0,
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  SuperNavigator.push(
                    context: context,
                    widget: ConnectionGrid(
                      connection: widget.connection,
                    ),
                    fullScreen: false,
                  );
                },
                child: Text(
                  'View History',
                  style: bottomNavStyle,
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => _handleReply(),
                child: Text(
                  'Send Reply',
                  style: bottomNavStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
