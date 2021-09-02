import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/connection/connection.dart';
import 'package:superconnector_vm/core/models/selected_contacts.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/services/connection/connection_service.dart';
import 'package:superconnector_vm/core/services/supercontact/supercontact_service.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';
import 'package:superconnector_vm/core/utils/nav/super_navigator.dart';
import 'package:superconnector_vm/core/utils/sms_utility.dart';
import 'package:superconnector_vm/ui/components/bottom_sheet_tab.dart';
import 'package:superconnector_vm/ui/components/dialogs/super_dialog.dart';
import 'package:superconnector_vm/ui/components/underline.dart';
import 'package:superconnector_vm/ui/screens/authenticated/components/search_bar.dart';
import 'package:superconnector_vm/ui/screens/authenticated/connection_grid/connection_grid.dart';
import 'package:superconnector_vm/ui/screens/authenticated/contacts/components/group_selection_button.dart';
import 'package:superconnector_vm/ui/screens/authenticated/contacts/contacts_selection/contacts_selection.dart';

class Contacts extends StatefulWidget {
  const Contacts({
    Key? key,
    required this.tag,
    required this.isGroup,
  }) : super(key: key);

  final String tag;
  final bool isGroup;

  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  SupercontactService _supercontactService = SupercontactService();
  TextEditingController _controller = TextEditingController();
  Iterable<Contact>? _contacts;
  String _filter = '';

  Future _toggleContact({
    required Contact contact,
    required BuildContext context,
    int phoneIndex = 0,
  }) async {
    if (contact.phones == null || contact.phones!.length == 0) {
      return;
    }
    String? phoneNumber = contact.phones!.toList()[phoneIndex].value;
    if (phoneNumber == null) {
      return;
    }

    var selectedContacts = Provider.of<SelectedContacts>(
      context,
      listen: false,
    );

    if (selectedContacts.containsContact(contact)) {
      selectedContacts.removeContact(contact);
    } else {
      selectedContacts.addContact(contact);
    }

    print(selectedContacts.getSelectedContacts);

    setState(() {});
  }

  Future _setOrCreateConnection() async {
    final superuser = Provider.of<Superuser?>(context, listen: false);
    final connections = Provider.of<List<Connection>>(context, listen: false);
    var selectedContacts = Provider.of<SelectedContacts>(
      context,
      listen: false,
    );
    final analytics = Provider.of<FirebaseAnalytics>(
      context,
      listen: false,
    );

    if (superuser == null) {
      return;
    }

    Map connectionMap = await ConnectionService().getOrCreateConnection(
      currentUserId: superuser.id,
      selectedContacts: selectedContacts,
      connections: connections,
      analytics: analytics,
      tag: widget.tag,
    );

    Connection connection = connectionMap['connection'];
    bool wasCreated = connectionMap['wasCreated'];

    selectedContacts.reset();
    Navigator.of(context).pop();

    if (connection.phoneNumberNameMap.isNotEmpty && wasCreated) {
      List<String> phoneNumbers = connection.phoneNumberNameMap.keys.toList();

      _showInviteCard(phoneNumbers);
    } else {
      SuperNavigator.push(
        context: context,
        widget: ConnectionGrid(connection: connection),
      );
    }
  }

  Future _onTapContact({
    required Contact contact,
    required BuildContext context,
    int phoneIndex = 0,
  }) async {
    if (contact.phones == null || contact.phones!.length == 0) {
      return;
    }
    String? phoneNumber = contact.phones!.toList()[phoneIndex].value;
    if (phoneNumber == null) {
      return;
    }

    var selectedContacts = Provider.of<SelectedContacts>(
      context,
      listen: false,
    );

    if (selectedContacts.containsContact(contact)) {
      selectedContacts.removeContact(contact);
    } else {
      selectedContacts.addContact(contact);
    }

    _setOrCreateConnection();
  }

  Future _showInviteCard(
    List<String> phoneNumbers,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Stack(
          children: [
            SuperDialog(
              title: 'Confirmation',
              subtitle:
                  'Send them a Superconnector invitation so they can connect with you.',
              primaryActionTitle: 'Continue',
              primaryAction: () async {
                String body =
                    "Just added you to my family in Superconnector! Let's connect: https://www.superconnector.com/";

                await SMSUtility.send(body, phoneNumbers);
                Navigator.pop(context);
              },
              secondaryActionTitle: 'Cancel',
              secondaryAction: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  // Future _sendVM() async {
  //   var selectedContacts = Provider.of<SelectedContacts>(
  //     context,
  //     listen: false,
  //   );

  //   if (selectedContacts.isEmpty()) {
  //     return;
  //   }

  //   if (widget.primaryAction != null) {
  //     widget.primaryAction!();
  //     Navigator.of(context).pop();
  //     return;
  //   }

  //   if (widget.shouldShowHistory) {
  //     SuperNavigator.push(
  //       context: context,
  //       widget: Record(),
  //     );
  //   } else {
  //     Navigator.of(context).pop();
  //   }
  // }

  @override
  void initState() {
    super.initState();
    getContacts();
    _controller.addListener(() {
      if (mounted) {
        setState(() {
          _filter = _controller.text;
        });
      }
    });
  }

  bool _isValidContact(Contact contact) {
    bool hasName = contact.displayName != null && contact.displayName != '';
    bool hasNumber = contact.phones != null && contact.phones!.isNotEmpty;

    return hasName && hasNumber;
  }

  Future<void> getContacts() async {
    final Iterable<Contact> contacts = await ContactsService.getContacts();
    setState(() {
      _contacts = contacts.where((contact) {
        return _isValidContact(contact);
      });
    });

    final superuser = Provider.of<Superuser?>(context, listen: false);
    if (_contacts != null && superuser != null) {
      _supercontactService.syncContacts(superuser, _contacts!.toList());
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: widget.isGroup
          ? GroupSelectionButton(onPressed: () {
              _setOrCreateConnection();
            })
          : Container(),
      body: Container(
        width: size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              'assets/images/authenticated/gradient-background-reversed.png',
            ),
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: BottomSheetTab(),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                bottom: 19.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Send Request',
                    style: Theme.of(context).textTheme.headline5!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 20.0,
                        ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 5.0,
                    ),
                    child: Text(
                      widget.isGroup
                          ? 'Add people to your family group.'
                          : 'Invite your ' +
                              widget.tag.toLowerCase() +
                              ' to connect.',
                      style: Theme.of(context).textTheme.bodyText1!,
                    ),
                  ),
                ],
              ),
            ),
            Underline(
              color: Colors.white.withOpacity(.2),
            ),
            SizedBox(
              height: 7.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18.0,
              ),
              child: SearchBar(
                controller: _controller,
                enabled: true,
              ),
            ),
            if (_contacts != null && _contacts!.length > 0)
              Expanded(
                child: ContactsSelection(
                  onTapContact: (contact) => widget.isGroup
                      ? _toggleContact(
                          contact: contact,
                          context: context,
                        )
                      : _onTapContact(
                          contact: contact,
                          context: context,
                        ),
                  isSelectable: widget.isGroup,
                  filter: _filter,
                  contacts: _contacts!,
                ),
              ),
          ],
        ),
      ),
    );

    // return Scaffold(
    //   body: SafeArea(
    //     child: Column(
    //       children: [
    //         GestureDetector(
    //           behavior: HitTestBehavior.opaque,
    //           onTap: () => Navigator.of(context).pop(),
    //           child: Container(
    //             width: 40.0,
    //             height: 6.0,
    //             margin: const EdgeInsets.only(top: 60.0, bottom: 19.0),
    //             decoration: BoxDecoration(
    //               color: Colors.black.withOpacity(.20),
    //               borderRadius: BorderRadius.circular(3.0),
    //             ),
    //           ),
    //         ),
    //         Container(
    //           margin: const EdgeInsets.symmetric(
    //             horizontal: 18.0,
    //           ),
    //           decoration: BoxDecoration(
    //             color: ConstantColors.SEARCH_BAR_BACKGROUND,
    //             borderRadius: BorderRadius.circular(6.0),
    //           ),
    //           child: Column(
    //             children: [
    //               SearchBar(
    //                 controller: _controller,
    //                 enabled: true,
    //               ),
    //               Container(
    //                 width: MediaQuery.of(context).size.width,
    //                 decoration: BoxDecoration(
    //                   color: CupertinoColors.systemFill,
    //                   borderRadius: BorderRadius.only(
    //                     bottomLeft: Radius.circular(6.0),
    //                     bottomRight: Radius.circular(6.0),
    //                   ),
    //                 ),
    //                 child: CupertinoSlidingSegmentedControl(
    //                   groupValue: _segmentedControlValue,
    //                   // backgroundColor: Colors.blue.shade200,
    //                   children: <int, Widget>{
    //                     0: Text(
    //                       'Connections',
    //                       style: segmentStyle,
    //                     ),
    //                     1: Text(
    //                       'Phone Contacts',
    //                       style: segmentStyle,
    //                     ),
    //                   },
    //                   onValueChanged: (value) {
    //                     setState(() {
    //                       _segmentedControlValue = value as int;
    //                     });
    //                   },
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //         SizedBox(
    //           height: 9.0,
    //         ),
    //         Expanded(
    //           child: _segmentedControlValue == 0
    //               ? SupercontactSelection(
    //                   filter: _filter,
    //                   toContacts: () {
    //                     setState(() {
    //                       _segmentedControlValue = 1;
    //                     });
    //                   })
    //               : ContactsSelection(
    //                   toggleContact: (contact) => _toggleContact(
    //                     contact: contact,
    //                     context: context,
    //                   ),
    //                   filter: _filter,
    //                   contacts: _contacts,
    //                 ),
    //         ),
    //       ],
    //     ),
    //   ),
    //   bottomNavigationBar: BottomAppBar(
    //     child: Container(
    //       height: 55.0,
    //       padding: const EdgeInsets.symmetric(
    //         horizontal: 20.0,
    //       ),
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: [
    //           widget.shouldShowHistory
    //               ? ViewHistoryButton(
    //                   bottomNavStyle: bottomNavStyle,
    //                 )
    //               : GestureDetector(
    //                   behavior: HitTestBehavior.opaque,
    //                   onTap: () {
    //                     Navigator.of(context).pop();
    //                   },
    //                   child: Text(
    //                     'Go Back',
    //                     style: bottomNavStyle,
    //                   ),
    //                 ),
    //           GestureDetector(
    //             behavior: HitTestBehavior.opaque,
    //             onTap: _sendVM,
    //             child: Text(
    //               'Send VM',
    //               style: TextStyle(
    //                 color: selectedContacts.isEmpty()
    //                     ? ConstantColors.GRAY_TEXT
    //                     : ConstantColors.PRIMARY,
    //                 fontSize: 18.0,
    //                 fontWeight: FontWeight.w600,
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}

// class ViewHistoryButton extends StatefulWidget {
//   const ViewHistoryButton({
//     Key? key,
//     required this.bottomNavStyle,
//   }) : super(key: key);

//   final TextStyle bottomNavStyle;

//   @override
//   _ViewHistoryButtonState createState() => _ViewHistoryButtonState();
// }

// class _ViewHistoryButtonState extends State<ViewHistoryButton> {
//   ConnectionService _connectionService = ConnectionService();
//   Connection? _connection;

//   @override
//   Widget build(BuildContext context) {
//     var selectedContacts = Provider.of<SelectedContacts>(
//       context,
//     );

//     TextStyle disabledStyle = TextStyle(
//       color: ConstantColors.GRAY_TEXT,
//       fontSize: widget.bottomNavStyle.fontSize,
//       fontWeight: widget.bottomNavStyle.fontWeight,
//     );

//     WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) async {
//       _connection = await _connectionService.getConnectionFromSelected(
//         selectedContacts: selectedContacts,
//       );
//     });

//     return GestureDetector(
//       behavior: HitTestBehavior.opaque,
//       onTap: () {
//         if (_connection == null) {
//           return;
//         }

//         SuperNavigator.push(
//           context: context,
//           widget: ConnectionGrid(
//             connection: _connection!,
//           ),
//           fullScreen: true,
//         );
//       },
//       child: Text(
//         'View History',
//         style: _connection == null ? disabledStyle : widget.bottomNavStyle,
//       ),
//     );
//   }
// }
