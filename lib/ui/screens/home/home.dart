import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/services/supercontact/supercontact_service.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';
import 'package:superconnector_vm/core/utils/nav/super_navigator.dart';
import 'package:superconnector_vm/ui/components/images/superuser_image.dart';
import 'package:superconnector_vm/ui/screens/authenticated/account/account.dart';
import 'package:superconnector_vm/ui/screens/authenticated/components/connections/connections_list.dart';

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

    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) {
      if (superuser != null && superuser.numContacts == 0) {
        // _syncContacts();
      }
    });

    if (superuser == null) {
      return Container();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: ConstantColors.OFF_WHITE,
            brightness: Brightness.light,
            elevation: 0.0,
            toolbarHeight: 0.0,
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(
              Icons.add,
            ),
            onPressed: () => SuperNavigator.handleRecordNavigation(context),
          ),
          body: SafeArea(
            child: Container(
              color: ConstantColors.OFF_WHITE,
              child: Column(
                children: [
                  // Text('Authenticated'),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: Text(
                          'VMs',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 40.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          // _panelController.open();
                          SuperNavigator.handleContactsNavigation(
                            context: context,
                            shouldShowHistory: true,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 22.0),
                          child: Image.asset(
                            'assets/images/authenticated/search-icon.png',
                            width: 26.0,
                          ),
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          SuperNavigator.push(
                            context: context,
                            widget: Account(),
                            fullScreen: false,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 9.0),
                          child: SuperuserImage(
                            url: superuser.photoUrl,
                            radius: 21.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 1.0,
                    margin: const EdgeInsets.only(
                      top: 9.0,
                    ),
                    color: ConstantColors.ED_GRAY,
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
