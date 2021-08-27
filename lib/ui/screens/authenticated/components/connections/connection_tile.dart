import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/connection/connection.dart';
import 'package:superconnector_vm/core/models/selected_contacts.dart';
import 'package:superconnector_vm/core/models/supercontact/supercontact.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/models/video/video.dart';
import 'package:superconnector_vm/core/services/superuser/superuser_service.dart';
import 'package:superconnector_vm/core/services/video/video_service.dart';
import 'package:superconnector_vm/core/utils/block/block_utility.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';
import 'package:superconnector_vm/core/utils/formatters/timestamp_formatter.dart';
import 'package:superconnector_vm/core/utils/nav/super_navigator.dart';
import 'package:superconnector_vm/ui/components/underline.dart';
import 'package:superconnector_vm/ui/screens/authenticated/components/connections/components/connection_names.dart';
import 'package:superconnector_vm/ui/screens/authenticated/components/connections/components/connection_photos.dart';
import 'package:superconnector_vm/ui/screens/authenticated/components/connections/components/vm_connection_tile.dart';
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
  late Timer _periodicUpdate;

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

    if (mounted) {
      setState(() {
        _superusers = tempSuperusers;
      });
    }
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
    _periodicUpdate = Timer.periodic(Duration(seconds: 30), (Timer t) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _periodicUpdate.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final superuser = Provider.of<Superuser?>(context);
    var selectedContacts = Provider.of<SelectedContacts>(context);
    var supercontacts = Provider.of<List<Supercontact>>(context);

    if (superuser == null) {
      return Container();
    }

    return StreamProvider<List<Video>>.value(
      value: _videoService.getConnectionVideoStream(
        widget.connection.id,
      ),
      initialData: [],
      child: Consumer<List<Video>>(
        builder: (context, videos, child) {
          List<Video> filteredVideos = videos;

          if (widget.connection.userIds.length == 2) {
            filteredVideos = BlockUtility.unblockedVideos(
              superuser: superuser,
              videos: videos,
            );
          }
          int unwatchedCount = filteredVideos
              .where(
                (element) => element.unwatchedIds.contains(
                  superuser.id,
                ),
              )
              .length;

          Color textColor =
              unwatchedCount > 0 ? ConstantColors.PRIMARY : Colors.black;
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
                        emptyImageCount:
                            widget.connection.phoneNumberNameMap.length,
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
                                  ? ['Example Connection']
                                  : _superusers.map((e) => e.fullName).toList(),
                              phoneNumberNameMap:
                                  widget.connection.phoneNumberNameMap,
                              unwatchedCount: unwatchedCount,
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
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 17.0),
                        child: Row(
                          children: [
                            Text(
                              widget.connection.streakCount.toString(),
                              style: TextStyle(
                                color: textColor,
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
                              color: textColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 146.0,
                  padding: const EdgeInsets.only(
                    left: 16.0,
                  ),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: min(filteredVideos.length + 1, 6),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return VMConnectionTile(
                          onPressed: () {
                            BlockUtility blockUtility = BlockUtility(
                              context: context,
                              superuser: superuser,
                              connection: widget.connection,
                              supercontacts: supercontacts,
                              selectedContacts: selectedContacts,
                            );
                            blockUtility.handleBlockedRecordNavigation();
                          },
                        );
                      }

                      int effectiveIndex = index - 1;

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
                              videos: filteredVideos,
                              initialIndex: effectiveIndex,
                            ),
                            fullScreen: false,
                          );
                        },
                        child: VideoTile(
                          video: filteredVideos[effectiveIndex],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Underline(),
              ],
            ),
          );
        },
      ),
    );
  }
}
