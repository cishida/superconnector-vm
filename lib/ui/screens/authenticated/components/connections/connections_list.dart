import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:superconnector_vm/core/models/connection/connection.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/utils/constants/values.dart';
import 'package:superconnector_vm/ui/screens/authenticated/components/connections/components/camera_rolls_shimmer.dart';
import 'package:superconnector_vm/ui/screens/authenticated/components/connections/connection_tile.dart';

class ConnectionList extends StatefulWidget {
  @override
  _ConnectionListState createState() => _ConnectionListState();
}

class _ConnectionListState extends State<ConnectionList> {
  List<ConnectionTile> _buildTiles(List<Connection> connections) {
    List<ConnectionTile> tiles = [];

    int count = 0;

    connections.forEach((connection) {
      bool invertGradient = false;
      if (count % 2 != 0) {
        invertGradient = true;
      }
      tiles.add(
        ConnectionTile(
          connection: connection,
          invertGradient: invertGradient,
        ),
      );
      count++;
    });

    return tiles;
  }

  @override
  Widget build(BuildContext context) {
    final superuser = context.watch<Superuser?>();

    if (superuser == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Consumer<List<Connection>>(
        builder: (context, connections, child) {
          if (connections.length == 0) {
            return CameraRollsShimmer();
          }
          return ListView(
            addAutomaticKeepAlives: true,
            padding: const EdgeInsets.only(
              bottom: 200.0,
            ),
            children: _buildTiles(connections
                .where((connection) =>
                    !connection.deletedIds.contains(superuser.id))
                .toList()),
          );
        },
      );
    }
  }
}
