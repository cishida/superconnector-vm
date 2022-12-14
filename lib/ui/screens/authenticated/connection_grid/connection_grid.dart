import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/connection/connection.dart';
import 'package:superconnector_vm/core/models/photo/photo.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/models/video/video.dart';
import 'package:superconnector_vm/core/services/photo/photo_service.dart';
import 'package:superconnector_vm/core/services/superuser/superuser_service.dart';
import 'package:superconnector_vm/core/services/video/video_service.dart';
import 'package:superconnector_vm/core/utils/block/block_utility.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';
import 'package:superconnector_vm/core/utils/nav/super_navigator.dart';
import 'package:superconnector_vm/ui/components/app_bars/custom_app_bar.dart';
import 'package:superconnector_vm/ui/screens/authenticated/connection_carousel/connection_carousel.dart';
import 'package:superconnector_vm/ui/screens/authenticated/connection_grid/components/connection_grid_header.dart';
import 'package:superconnector_vm/ui/screens/authenticated/connection_grid/components/media_grid_tile.dart';

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
  PhotoService _photoService = PhotoService();
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

  List<Widget> _buildVideoGridTiles(List media) {
    final superuser = Provider.of<Superuser?>(context, listen: false);
    if (superuser == null) {
      return [];
    }

    List<Widget> gridTiles = [];

    for (var i = 0; i < media.length; i++) {
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
      if (media[effectiveIndex] is Video) {
        gridTiles.add(
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              if (media[effectiveIndex].status == 'ready') {
                SuperNavigator.push(
                  context: context,
                  widget: ConnectionCarousel(
                    media: media,
                    connection: widget.connection,
                    initialIndex: effectiveIndex,
                  ),
                  fullScreen: false,
                );
              }
            },
            child: MediaGridTile(
              video: media[effectiveIndex],
            ),
          ),
        );
      } else {
        gridTiles.add(
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              if (media[effectiveIndex].status == 'ready') {
                SuperNavigator.push(
                  context: context,
                  widget: ConnectionCarousel(
                    media: media,
                    connection: widget.connection,
                    initialIndex: effectiveIndex,
                  ),
                  fullScreen: false,
                );
              }
            },
            child: MediaGridTile(
              photo: media[effectiveIndex],
            ),
          ),
        );
      }
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
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(
          backgroundColor: Colors.white,
          systemUiOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        floatingActionButton: Container(
          height: 64.0,
          width: 64.0,
          decoration: BoxDecoration(
            color: ConstantColors.PRIMARY,
            borderRadius: BorderRadius.circular(32.0),
          ),
          child: FittedBox(
            child: FloatingActionButton(
              elevation: 10,
              backgroundColor: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  color: ConstantColors.PRIMARY,
                  borderRadius: BorderRadius.circular(32.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 1.0),
                  child: Center(
                    child: Image.asset(
                      'assets/images/authenticated/bottom_nav/bottom-nav-camera.png',
                      width: 30.0,
                    ),
                  ),
                ),
              ),
              onPressed: () {
                BlockUtility blockUtility = BlockUtility(
                  context: context,
                  superuser: superuser,
                  connection: widget.connection,
                );
                blockUtility.handleBlockedRecordNavigation();
              },
            ),
          ),
        ),

        // NewConnectionButton(
        //   isInverted: true,
        //   onPressed: () {
        //     BlockUtility blockUtility = BlockUtility(
        //       context: context,
        //       superuser: superuser,
        //       connection: widget.connection,
        //     );
        //     blockUtility.handleBlockedRecordNavigation();
        //   },
        // ),
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
                child: MultiProvider(
                  providers: [
                    StreamProvider<List<Video>>.value(
                      value: _videoService.getConnectionVideoStream(
                        widget.connection.id,
                        // limit: 5,
                      ),
                      initialData: [],
                    ),
                    StreamProvider<List<Photo>>.value(
                      value: _photoService.getConnectionPhotoStream(
                        widget.connection.id,
                        // limit: 5,
                      ),
                      initialData: [],
                    ),
                  ],
                  child: Consumer2<List<Video>, List<Photo>>(
                    builder: (context, videos, photos, child) {
                      List<Video> filteredVideos = videos;
                      List<Photo> filteredPhotos = photos;

                      if (widget.connection.userIds.length == 2) {
                        filteredVideos = BlockUtility.unblockedVideos(
                          superuser: superuser,
                          videos: videos,
                        );

                        filteredPhotos = BlockUtility.unblockedPhotos(
                          superuser: superuser,
                          photos: photos,
                        );
                      }

                      int itemCount =
                          filteredVideos.length + filteredPhotos.length;
                      List media = [];

                      media.addAll(filteredVideos);
                      media.addAll(filteredPhotos);
                      media.sort((a, b) {
                        return b.created.compareTo(a.created);
                      });

                      return Column(
                        children: [
                          if (itemCount > 0)
                            GridView.count(
                              padding: const EdgeInsets.all(0),
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              crossAxisCount: 3,
                              childAspectRatio: itemWidth / itemHeight,
                              mainAxisSpacing: 1.0,
                              crossAxisSpacing: 1.0,
                              children: _buildVideoGridTiles(media),
                            ),
                          Container(
                            width: size.width,
                            height: max(
                                size.height -
                                    55 -
                                    MediaQuery.of(context).padding.top -
                                    (itemHeight *
                                        (filteredVideos.length / 3).ceil()),
                                300),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 38.0,
                            ),
                            margin: const EdgeInsets.only(top: 1.0),
                            decoration: BoxDecoration(
                              color: ConstantColors.OFF_WHITE,
                              // image: DecorationImage(
                              //   fit: BoxFit.cover,
                              //   image: AssetImage(
                              //     'assets/images/authenticated/gradient-background.png',
                              //   ),
                              // ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                // Text(
                                //   'Video History',
                                //   style: TextStyle(
                                //     fontSize: 22,
                                //     fontWeight: FontWeight.w700,
                                //     color: Colors.white,
                                //   ),
                                // ),
                                // SizedBox(
                                //   height: 12,
                                // ),
                                // Text(
                                //   'This helps you browse all the videos you???ve shared with each other.',
                                //   style: TextStyle(
                                //     fontSize: 16,
                                //     fontWeight: FontWeight.w400,
                                //     color: Colors.white,
                                //   ),
                                // ),
                                // FloatingActionButton(
                                //   elevation: 10,
                                //   backgroundColor: Colors.transparent,
                                //   child: Container(
                                //     width: 64.0,
                                //     height: 64.0,
                                //     decoration: BoxDecoration(
                                //       color: Colors.white,
                                //       borderRadius: BorderRadius.circular(32.0),
                                //     ),
                                //     child: Padding(
                                //       padding: const EdgeInsets.only(top: 2.0),
                                //       child: Icon(
                                //         Icons.add,
                                //         color: ConstantColors.PRIMARY,
                                //       ),
                                //     ),
                                //   ),
                                //   onPressed: () {
                                //     BlockUtility blockUtility = BlockUtility(
                                //       context: context,
                                //       superuser: superuser,
                                //       connection: widget.connection,
                                //     );
                                //     blockUtility.handleBlockedRecordNavigation();
                                //   },
                                // ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
            // ),
          ],
        ),
      ),
    );
  }
}
