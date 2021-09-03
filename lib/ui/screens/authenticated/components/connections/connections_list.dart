import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/connection/connection.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/ui/screens/authenticated/components/connections/connection_tile.dart';

class ConnectionList extends StatefulWidget {
  @override
  _ConnectionListState createState() => _ConnectionListState();
}

class _ConnectionListState extends State<ConnectionList> {
  List<ConnectionTile> _buildTiles(List<Connection> connections) {
    List<ConnectionTile> tiles = [];

    connections.forEach((connection) {
      tiles.add(
        ConnectionTile(
          connection: connection,
        ),
      );
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
          return ListView(
            addAutomaticKeepAlives: true,
            padding: const EdgeInsets.only(
              bottom: 200.0,
            ),
            children: _buildTiles(connections),
            // itemCount: connections.length,
            // itemBuilder: (context, index) {
            //   return ConnectionTile(
            //     connection: connections[index],
            //   );
            // },
          );
        },
      );
    }
  }
}
