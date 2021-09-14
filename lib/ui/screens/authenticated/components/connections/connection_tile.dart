import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/connection/connection.dart';
import 'package:superconnector_vm/core/models/connection_search_term.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/models/video/video.dart';
import 'package:superconnector_vm/core/services/superuser/superuser_service.dart';
import 'package:superconnector_vm/core/services/video/video_service.dart';
import 'package:superconnector_vm/core/utils/block/block_utility.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';
import 'package:superconnector_vm/core/utils/nav/super_navigator.dart';
import 'package:superconnector_vm/ui/components/overlays/overlay_explanation.dart';
import 'package:superconnector_vm/ui/components/overlays/overlay_input.dart';
import 'package:superconnector_vm/ui/components/underline.dart';
import 'package:superconnector_vm/ui/screens/authenticated/components/connections/components/connection_names.dart';
import 'package:superconnector_vm/ui/screens/authenticated/components/connections/components/connection_photos.dart';
import 'package:superconnector_vm/ui/screens/authenticated/components/connections/components/vm_connection_tile.dart';
import 'package:superconnector_vm/ui/screens/authenticated/components/connections/video_tile.dart';
import 'package:superconnector_vm/ui/screens/authenticated/connection_carousel/connection_carousel.dart';
import 'package:superconnector_vm/ui/screens/authenticated/connection_grid/connection_grid.dart';
import 'package:superconnector_vm/ui/screens/authenticated/contacts/relations/relations.dart';

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

class _ConnectionTileState extends State<ConnectionTile>
    with AutomaticKeepAliveClientMixin {
  VideoService _videoService = VideoService();
  SuperuserService _superuserService = SuperuserService();
  List<Superuser> _superusers = [];
  late Timer _periodicUpdate;
  String _groupName = '';
  List<String> _filteredNames = [];

  Future _loadUsers() async {
    List<Superuser> tempSuperusers = [];
    final currentSuperuser = Provider.of<Superuser?>(context, listen: false);

    if (currentSuperuser == null) {
      return;
    }

    for (var i = 0; i < widget.connection.userIds.length; i++) {
      List<String> ids = tempSuperusers.map((e) => e.id).toList();

      if (widget.connection.userIds[i] != currentSuperuser.id) {
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

    if (oldWidget.connection.id != widget.connection.id) {
      _loadUsers();
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUsers();
    _periodicUpdate = Timer.periodic(Duration(seconds: 30), (Timer t) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _periodicUpdate.cancel();
    super.dispose();
  }

  void _handleNav({
    required Function onComplete,
  }) {
    final superuser = Provider.of<Superuser?>(
      context,
      listen: false,
    );
    if (superuser == null) {
      return;
    }

    final String? tag = widget.connection.tags[superuser.id];

    if ((tag == null || tag.isEmpty) &&
        !widget.connection.isExampleConversation) {
      if (widget.connection.userIds.length +
              widget.connection.phoneNumberNameMap.length >
          2) {
        Navigator.of(context)
            .push(
              PageRouteBuilder(
                opaque: false,
                pageBuilder: (BuildContext context, _, __) {
                  return OverlayInput(
                    fieldName: 'Relation',
                    explanation: OverlayExplanation(
                      title: 'Group Name',
                      subtitle: 'Only you can see your group names.',
                    ),
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.done,
                    onChanged: (text) {
                      if (mounted) {
                        setState(() {
                          _groupName = text;
                        });
                      }
                    },
                    onSubmit: (text) async {
                      // onComplete();
                      widget.connection.tags[superuser.id] = _groupName;
                      widget.connection.update();
                    },
                  );
                },
              ),
            )
            .then(
              (value) => onComplete(),
            );
      } else {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return FractionallySizedBox(
              heightFactor: 0.93,
              child: Relations(
                connection: widget.connection,
              ),
            );
          },
        ).then(
          (value) => onComplete(),
        );
      }
    } else {
      onComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final superuser = Provider.of<Superuser?>(context);
    if (superuser == null) {
      return Container();
    }

    ConnectionSearchTerm connectionSearchTerm =
        Provider.of<ConnectionSearchTerm>(
      context,
      // listen: false,
    );

    _filteredNames = []; //_superusers.map((e) => e.fullName).toList();

    _superusers.map((e) => e.fullName).toList().forEach((fullName) {
      if (connectionSearchTerm.get() == '' ||
          (connectionSearchTerm.get() != '' &&
              fullName.toLowerCase().contains(
                    connectionSearchTerm.get().toLowerCase(),
                  )) ||
          (widget.connection.tags[superuser.id] != null &&
              widget.connection.tags[superuser.id]!
                  .toLowerCase()
                  .contains(connectionSearchTerm.get().toLowerCase()))) {
        _filteredNames.add(fullName);
      }
    });

    widget.connection.phoneNumberNameMap.values.toList().forEach((fullName) {
      if (connectionSearchTerm.get() == '' ||
          (connectionSearchTerm.get() != '' &&
              fullName.toLowerCase().contains(
                    connectionSearchTerm.get().toLowerCase(),
                  )) ||
          (widget.connection.tags[superuser.id] != null &&
              widget.connection.tags[superuser.id]!
                  .toLowerCase()
                  .contains(connectionSearchTerm.get().toLowerCase()))) {
        _filteredNames.add(fullName);
      }
    });

    if (_filteredNames.length == 0) {
      return Container();
    }

    return StreamProvider<List<Video>>.value(
      value: _videoService.getConnectionVideoStream(
        widget.connection.id,
        limit: 5,
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

              _handleNav(
                onComplete: () {
                  SuperNavigator.push(
                    context: context,
                    widget: ConnectionGrid(
                      connection: widget.connection,
                    ),
                    fullScreen: false,
                  );
                },
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
                              // TimestampFormatter().getChatTileTime(
                              //   Timestamp.fromDate(
                              //     widget.connection.mostRecentActivity!,
                              //   ),
                              // ),
                              widget.connection.isExampleConversation
                                  ? 'Tap to try features'
                                  : (videos.length == 0
                                      ? 'Send a welcome video'
                                      : (widget.connection.tags[superuser.id] ??
                                              'Choose your family relation')
                                          .toString()),
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w400,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(bottom: 17.0),
                      //   child: Row(
                      //     children: [
                      //       Text(
                      //         widget.connection.streakCount.toString(),
                      //         style: TextStyle(
                      //           color: textColor,
                      //           fontSize: 17.0,
                      //           fontWeight: FontWeight.w700,
                      //         ),
                      //       ),
                      //       SizedBox(
                      //         width: 4.0,
                      //       ),
                      //       Image.asset(
                      //         'assets/images/authenticated/streak-icon.png',
                      //         width: 10.0,
                      //         color: textColor,
                      //       ),
                      //     ],
                      //   ),
                      // ),
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
                            _handleNav(
                              onComplete: () {
                                BlockUtility blockUtility = BlockUtility(
                                  context: context,
                                  superuser: superuser,
                                  connection: widget.connection,
                                );
                                blockUtility.handleBlockedRecordNavigation();
                              },
                            );
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

                          _handleNav(
                            onComplete: () {
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

  @override
  bool get wantKeepAlive => true;
}
