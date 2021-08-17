import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/services/supercontact/supercontact_service.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';
import 'package:superconnector_vm/core/utils/nav/super_navigator.dart';
import 'package:superconnector_vm/ui/components/app_bars/light_app_bar.dart';
import 'package:superconnector_vm/ui/components/buttons/send_vm_button.dart';
import 'package:superconnector_vm/ui/components/images/superuser_image.dart';
import 'package:superconnector_vm/ui/screens/authenticated/account/account.dart';
import 'package:superconnector_vm/ui/screens/authenticated/components/connections/connections_list.dart';
import 'package:superconnector_vm/ui/screens/home/components/home_title_bar.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isValidContact(Contact contact) {
    bool hasName = contact.displayName != null && contact.displayName != '';
    bool hasNumber = contact.phones != null && contact.phones!.isNotEmpty;

    return hasName && hasNumber;
  }

  // Would love to sync contacts early but would required contact access
  Future<void> _syncContacts() async {
    Iterable<Contact> contacts = await ContactsService.getContacts();
    contacts = contacts.where((contact) {
      return _isValidContact(contact);
    });

    final superuser = Provider.of<Superuser?>(context, listen: false);
    if (superuser != null) {
      SupercontactService().syncContacts(
        superuser,
        contacts.toList(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Superuser? superuser = Provider.of<Superuser?>(context);

    // WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) {
    //   if (superuser != null && superuser.numContacts == 0) {
    //      _syncContacts();
    //   }
    // });

    if (superuser == null) {
      return Container();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: LightAppBar(),
          floatingActionButton: SendVMButton(),
          body: SafeArea(
            child: Container(
              color: ConstantColors.OFF_WHITE,
              child: Column(
                children: [
                  HomeTitleBar(
                    superuser: superuser,
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: ConnectionList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
