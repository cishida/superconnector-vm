import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/connection/connection.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/models/video/video.dart';
import 'package:superconnector_vm/core/services/superuser/superuser_service.dart';
import 'package:superconnector_vm/core/services/video/video_service.dart';
import 'package:superconnector_vm/core/utils/block/block_utility.dart';
import 'package:superconnector_vm/core/utils/nav/super_navigator.dart';
import 'package:superconnector_vm/ui/components/app_bars/custom_app_bar.dart';
import 'package:superconnector_vm/ui/components/buttons/new_connection_button.dart';
import 'package:superconnector_vm/ui/screens/authenticated/connection_carousel/connection_carousel.dart';
import 'package:superconnector_vm/ui/screens/authenticated/connection_grid/components/connection_grid_header.dart';
import 'package:superconnector_vm/ui/screens/authenticated/connection_grid/components/video_grid_tile.dart';

class ConnectionGrid extends StatefulWidget {
  const ConnectionGrid({
    Key? key,
    required this.connection,
  }) : super(key: key);

  final Connection connection;

  @override
  _ConnectionGridState createState() => _ConnectionGridState();
}

class _ConnectionGridState extends State<ConnectionGrid> {
  VideoService _videoService = VideoService();
  final int _crossAxisCount = 3;
  SuperuserService _superuserService = SuperuserService();
  List<Superuser> _superusers = [];

  Future _loadUsers() async {
    final superuser = Provider.of<Superuser?>(context, listen: false);

    widget.connection.userIds.forEach((userId) async {
      if (superuser != null && userId != superuser.id) {
        Superuser? superuser =
            await _superuserService.getSuperuserFromId(userId);
        if (superuser != null) {
          _superusers.add(superuser);
        }
        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _loadUsers();
  }

  List<Widget> _buildVideoGridTiles(List<Video> videos) {
    final superuser = Provider.of<Superuser?>(context, listen: false);
    if (superuser == null) {
      return [];
    }

    List<Widget> gridTiles = [];

    for (var i = 0; i < videos.length; i++) {
      // if (i == 0) {
      //   gridTiles.add(
      //     VMConnectionTile(
      //       isGrid: true,
      //       onPressed: () {
      //         BlockUtility blockUtility = BlockUtility(
      //           context: context,
      //           superuser: superuser,
      //           connection: widget.connection,
      //         );
      //         blockUtility.handleBlockedRecordNavigation();
      //       },
      //     ),
      //   );
      //   continue;
      // }

      int effectiveIndex = i; // - 1;
      gridTiles.add(
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (videos[effectiveIndex].status == 'ready') {
              SuperNavigator.push(
                context: context,
                widget: ConnectionCarousel(
                  videos: videos,
                  connection: widget.connection,
                  initialIndex: effectiveIndex,
                ),
                fullScreen: false,
              );
            }
          },
          child: VideoGridTile(
            video: videos[effectiveIndex],
          ),
        ),
      );
    }

    return gridTiles;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    final double itemHeight = 182;
    final double itemWidth = size.width / _crossAxisCount;

    Superuser? superuser = Provider.of<Superuser?>(context);

    if (superuser == null) {
      return Container();
    }

    String nameText = '';
    if (_superusers.length + widget.connection.phoneNumberNameMap.length > 1) {
      if (widget.connection.tags[superuser.id] != null) {
        nameText = widget.connection.tags[superuser.id]!;
      } else {
        nameText =
            (_superusers.length + widget.connection.phoneNumberNameMap.length)
                    .toString() +
                ' people';
      }
    } else if (_superusers.length > 0) {
      nameText = _superusers.first.fullName;
    } else if (widget.connection.phoneNumberNameMap.isNotEmpty) {
      nameText = widget.connection.phoneNumberNameMap.values.first;
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        // backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(),
        floatingActionButton: NewConnectionButton(
          isInverted: true,
          onPressed: () {
            BlockUtility blockUtility = BlockUtility(
              context: context,
              superuser: superuser,
              connection: widget.connection,
            );
            blockUtility.handleBlockedRecordNavigation();
          },
        ),
        body: Column(
          children: [
            // SizedBox(
            //   height: MediaQuery.of(context).padding.top,
            // ),
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: ConnectionGridHeader(
                nameText: nameText,
                superusers: _superusers,
                connection: widget.connection,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: StreamProvider<List<Video>>.value(
                  value: _videoService.getConnectionVideoStream(
                    widget.connection.id,
                  ),
                  initialData: [],
                  child:
                      Consumer<List<Video>>(builder: (context, videos, child) {
                    List<Video> filteredVideos = videos;

                    if (widget.connection.userIds.length == 2) {
                      filteredVideos = BlockUtility.unblockedVideos(
                        superuser: superuser,
                        videos: videos,
                      );
                    }

                    return Column(
                      children: [
                        if (videos.isNotEmpty)
                          GridView.count(
                            padding: const EdgeInsets.all(0),
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            crossAxisCount: 3,
                            childAspectRatio: itemWidth / itemHeight,
                            mainAxisSpacing: 1.0,
                            crossAxisSpacing: 1.0,
                            children: _buildVideoGridTiles(filteredVideos),
                          ),
                        Container(
                          width: size.width,
                          height: max(
                              size.height -
                                  55 -
                                  MediaQuery.of(context).padding.top -
                                  (itemHeight * (videos.length / 3).ceil()),
                              300),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 38.0),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                'assets/images/authenticated/gradient-background.png',
                              ),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Video History',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Text(
                                'Your video history saves all the videos you share with each other. ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
