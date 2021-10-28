import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/camera/camera_handler.dart';
import 'package:superconnector_vm/core/models/connection/connection.dart';
import 'package:superconnector_vm/core/models/connection_search_term.dart';
import 'package:superconnector_vm/core/models/selected_contacts.dart';
import 'package:superconnector_vm/core/models/supercontact/supercontact.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/services/auth/auth_service.dart';
import 'package:superconnector_vm/core/services/connection/connection_service.dart';
import 'package:superconnector_vm/core/services/supercontact/supercontact_service.dart';
import 'package:superconnector_vm/core/services/superuser/superuser_service.dart';
import 'package:superconnector_vm/core/utils/nav/authenticated_controller.dart';

/// Used to create user-dependent objects that need to be accessible by all widgets.
/// This widgets should live above the [MaterialApp].
/// See [AuthWidget], a descendant widget that consumes the snapshot generated by this builder.
class AuthWidgetBuilder extends StatelessWidget {
  const AuthWidgetBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);
  final Widget Function(BuildContext, AsyncSnapshot<SuperFirebaseUser>) builder;

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return StreamBuilder<SuperFirebaseUser>(
      stream: authService.onAuthStateChanged,
      builder:
          (BuildContext context, AsyncSnapshot<SuperFirebaseUser> snapshot) {
        if (snapshot.data == null) {
          return Container();
        }

        final SuperFirebaseUser superFirebaseUser = snapshot.data!;
        return MultiProvider(
          providers: [
            Provider<SuperFirebaseUser>.value(value: superFirebaseUser),
            ChangeNotifierProvider(
              create: (_) => SelectedContacts(),
            ),
            ChangeNotifierProvider(
              create: (_) => ConnectionSearchTerm(),
            ),
            StreamProvider<Superuser?>.value(
              initialData: Superuser(created: DateTime.now()),
              value: SuperuserService(id: superFirebaseUser.id).superuser,
            ),
            // StreamProvider<List<UserConnection>>.value(
            //   value: UserConnectionService()
            //       .getUserConnections(superFirebaseUser.id),
            //   initialData: [],
            // ),
            StreamProvider<List<Connection>>.value(
              value: ConnectionService()
                  .getConnectionsWithUsers(superFirebaseUser.id),
              initialData: [],
            ),
            StreamProvider<List<Supercontact>>.value(
              value:
                  SupercontactService().getSupercontacts(superFirebaseUser.id),
              initialData: [],
            ),
            ChangeNotifierProvider(
              create: (_) => AuthenticatedController(),
            ),
            ChangeNotifierProvider(
              create: (_) => CameraHandler(),
            ),
            // NOTE: Any other user-bound providers here can be added here
          ],
          child: builder(context, snapshot),
        );
        // return builder(context, snapshot);
      },
    );
  }
}
