import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/connection/connection.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/models/video/video.dart';
import 'package:superconnector_vm/core/utils/block/block_utility.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';
import 'package:superconnector_vm/core/utils/constants/values.dart';
import 'package:superconnector_vm/core/utils/nav/super_navigator.dart';
import 'package:superconnector_vm/ui/components/buttons/chevron_back_button.dart';
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
  @override
  Widget build(BuildContext context) {
    Superuser? superuser = Provider.of<Superuser?>(context);

    if (superuser == null) {
      return Container();
    }

    TextStyle bottomNavStyle = TextStyle(
      color: Colors.white,
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
    );

    return Scaffold(
      backgroundColor: ConstantColors.DARK_BLUE,
      body: Stack(
        children: [
          Positioned(
            top: 0.0,
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: CarouselSlider(
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
          height: ConstantValues.BOTTOM_NAV_HEIGHT,
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
                onTap: () {
                  BlockUtility blockUtility = BlockUtility(
                    context: context,
                    superuser: superuser,
                    connection: widget.connection,
                  );
                  blockUtility.handleBlockedRecordNavigation();
                },
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
