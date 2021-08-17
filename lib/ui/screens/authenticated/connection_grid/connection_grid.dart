import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/connection/connection.dart';
import 'package:superconnector_vm/core/models/selected_contacts.dart';
import 'package:superconnector_vm/core/models/supercontact/supercontact.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/models/video/video.dart';
import 'package:superconnector_vm/core/services/superuser/superuser_service.dart';
import 'package:superconnector_vm/core/services/video/video_service.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';
import 'package:superconnector_vm/core/utils/nav/super_navigator.dart';
import 'package:superconnector_vm/ui/components/buttons/chevron_back_button.dart';
import 'package:superconnector_vm/ui/screens/authenticated/components/connections/components/connection_photos.dart';
import 'package:superconnector_vm/ui/screens/authenticated/connection_carousel/connection_carousel.dart';
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
    List<Widget> gridTiles = [];

    for (var i = 0; i < videos.length; i++) {
      gridTiles.add(
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            SuperNavigator.push(
              context: context,
              widget: ConnectionCarousel(
                videos: videos,
                connection: widget.connection,
                initialIndex: i,
              ),
              fullScreen: false,
            );
          },
          child: VideoGridTile(
            video: videos[i],
          ),
        ),
      );
    }

    return gridTiles;
  }

  @override
  Widget build(BuildContext context) {
    // Video video = Video(
    //   created: DateTime.now(),
    // );
    // var newVideoDoc = FirebaseFirestore.instance
    //     .collection('connections')
    //     .doc(widget.userConnection.connection!.id)
    //     .collection('videos')
    //     .doc()
    //     .set(video.toJson());

    var size = MediaQuery.of(context).size;

    final double itemHeight = 182;
    final double itemWidth = size.width / _crossAxisCount;

    var selectedContacts = Provider.of<SelectedContacts>(context);
    var supercontacts = Provider.of<List<Supercontact>>(context);

    String nameText = '';
    if (_superusers.length + widget.connection.phoneNumberNameMap.length > 1) {
      nameText =
          (_superusers.length + widget.connection.phoneNumberNameMap.length)
                  .toString() +
              ' people';
    } else if (_superusers.length > 0) {
      nameText = _superusers.first.fullName;
    } else if (widget.connection.phoneNumberNameMap.isNotEmpty) {
      nameText = widget.connection.phoneNumberNameMap.values.first;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        elevation: 0.0,
        toolbarHeight: 0.0,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
        ),
        onPressed: () {
          selectedContacts.setContactsFromConnection(
              connection: widget.connection, supercontacts: supercontacts);

          SuperNavigator.handleRecordNavigation(context);
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              height: 55.0,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ChevronBackButton(
                      color: ConstantColors.PRIMARY,
                      onBack: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () async {
                      print('username tapped');
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 19),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              nameText,
                              style: TextStyle(
                                color: ConstantColors.PRIMARY,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          ConnectionPhotos(
                            photoUrls:
                                _superusers.map((e) => e.photoUrl).toList(),
                            emptyImageCount:
                                widget.connection.phoneNumberNameMap.length,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: StreamProvider<List<Video>>.value(
                value: _videoService.getConnectionVideoStream(
                  widget.connection.id,
                ),
                initialData: [],
                child: Consumer<List<Video>>(builder: (context, videos, child) {
                  return GridView.count(
                    crossAxisCount: 3,
                    childAspectRatio: itemWidth / itemHeight,
                    mainAxisSpacing: 1.0,
                    crossAxisSpacing: 1.0,
                    children: _buildVideoGridTiles(videos),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
