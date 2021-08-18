import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/connection/connection.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/models/video/video.dart';
import 'package:superconnector_vm/core/services/superuser/superuser_service.dart';
import 'package:superconnector_vm/core/services/video/video_service.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';
import 'package:superconnector_vm/core/utils/formatters/timestamp_formatter.dart';
import 'package:superconnector_vm/core/utils/nav/super_navigator.dart';
import 'package:superconnector_vm/ui/screens/authenticated/components/connections/components/connection_names.dart';
import 'package:superconnector_vm/ui/screens/authenticated/components/connections/components/connection_photos.dart';
import 'package:superconnector_vm/ui/screens/authenticated/components/connections/video_tile.dart';
import 'package:superconnector_vm/ui/screens/authenticated/connection_carousel/connection_carousel.dart';
import 'package:superconnector_vm/ui/screens/authenticated/connection_grid/connection_grid.dart';

class ConnectionTile extends StatefulWidget {
  const ConnectionTile({
    Key? key,
    required this.connection,
    this.shouldIgnoreTaps = false,
  }) : super(key: key);

  final Connection connection;
  final bool shouldIgnoreTaps;

  @override
  _ConnectionTileState createState() => _ConnectionTileState();
}

class _ConnectionTileState extends State<ConnectionTile> {
  VideoService _videoService = VideoService();
  SuperuserService _superuserService = SuperuserService();
  List<Superuser> _superusers = [];

  Future _loadUsers() async {
    List<Superuser> tempSuperusers = [];
    final currentSuperuser = Provider.of<Superuser?>(context, listen: false);

    for (var i = 0; i < widget.connection.userIds.length; i++) {
      List<String> ids = tempSuperusers.map((e) => e.id).toList();

      if (currentSuperuser != null &&
          widget.connection.userIds[i] != currentSuperuser.id) {
        Superuser? superuser = await _superuserService
            .getSuperuserFromId(widget.connection.userIds[i]);
        if (superuser != null && !ids.contains(superuser.id)) {
          tempSuperusers.add(superuser);
        }
      }
    }

    setState(() {
      _superusers = tempSuperusers;
    });
  }

  @override
  void didUpdateWidget(ConnectionTile oldWidget) {
    super.didUpdateWidget(oldWidget);

    _loadUsers();
  }

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.shouldIgnoreTaps) {
          return;
        }

        SuperNavigator.push(
          context: context,
          widget: ConnectionGrid(
            connection: widget.connection,
          ),
          fullScreen: false,
        );
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: Row(
              children: [
                ConnectionPhotos(
                  photoUrls: _superusers.map((e) => e.photoUrl).toList(),
                  emptyImageCount: widget.connection.phoneNumberNameMap.length,
                ),
                SizedBox(
                  width: 9.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ConnectionNames(
                        names: widget.connection.isExampleConversation
                            ? ['Example Conversation']
                            : _superusers.map((e) => e.fullName).toList(),
                        phoneNumberNameMap:
                            widget.connection.phoneNumberNameMap,
                      ),
                      // Text('Names broken if seeing this'),
                      Text(
                        TimestampFormatter().getChatTileTime(
                          Timestamp.fromDate(
                            widget.connection.mostRecentActivity!,
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Text(
                      widget.connection.streakCount.toString(),
                      style: TextStyle(
                        color: Colors.black.withOpacity(.87),
                        fontSize: 17.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    Image.asset(
                      'assets/images/authenticated/streak-icon.png',
                      width: 10.0,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 146.0,
            padding: const EdgeInsets.only(
              left: 16.0,
            ),
            child: StreamProvider<List<Video>>.value(
              value: _videoService.getConnectionVideoStream(
                widget.connection.id,
              ),
              initialData: [],
              child: Consumer<List<Video>>(builder: (context, videos, child) {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: min(videos.length, 5),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      behavior: widget.shouldIgnoreTaps
                          ? HitTestBehavior.translucent
                          : HitTestBehavior.opaque,
                      onTap: () {
                        if (widget.shouldIgnoreTaps) {
                          return;
                        }

                        SuperNavigator.push(
                          context: context,
                          widget: ConnectionCarousel(
                            connection: widget.connection,
                            videos: videos,
                            initialIndex: index,
                          ),
                          fullScreen: false,
                        );
                      },
                      child: VideoTile(
                        video: videos[index],
                      ),
                    );
                  },
                );
              }),
            ),
          ),
          Container(
            height: 1.0,
            margin: const EdgeInsets.only(
              top: 15.0,
            ),
            color: ConstantColors.DIVIDER_GRAY,
          ),
        ],
      ),
    );
  }
}
