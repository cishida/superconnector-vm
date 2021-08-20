import 'package:contacts_service/contacts_service.dart';
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
import 'package:superconnector_vm/ui/screens/authenticated/components/search_bar.dart';
import 'package:superconnector_vm/ui/screens/authenticated/connection_grid/connection_grid.dart';
import 'package:superconnector_vm/ui/screens/authenticated/contacts/contacts_selection/contacts_selection.dart';
import 'package:superconnector_vm/ui/screens/authenticated/contacts/supercontacts_selection/supercontacts_selection.dart';
import 'package:superconnector_vm/ui/screens/authenticated/record/record.dart';

class Contacts extends StatefulWidget {
  const Contacts({
    Key? key,
    this.primaryAction,
    this.shouldShowHistory = false,
  }) : super(key: key);

  final Function? primaryAction;
  final bool shouldShowHistory;

  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  SupercontactService _supercontactService = SupercontactService();
  TextEditingController _controller = TextEditingController();
  Iterable<Contact>? _contacts;
  // List<Contact> _selectedContacts = [];
  int _segmentedControlValue = 0;
  String _filter = '';

  void _toggleContact({
    required Contact contact,
    required BuildContext context,
    int phoneIndex = 0,
  }) {
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

  Future _sendVM() async {
    var selectedContacts = Provider.of<SelectedContacts>(
      context,
      listen: false,
    );

    if (selectedContacts.isEmpty()) {
      return;
    }

    if (widget.primaryAction != null) {
      widget.primaryAction!();
      Navigator.of(context).pop();
      return;
    }

    if (widget.shouldShowHistory) {
      SuperNavigator.push(
        context: context,
        widget: Record(),
      );
    } else {
      Navigator.of(context).pop();
    }
  }

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
    print('build');

    TextStyle bottomNavStyle = TextStyle(
      color: ConstantColors.PRIMARY,
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
    );

    TextStyle segmentStyle = TextStyle(
      color: Colors.black,
      fontSize: 15.0,
      fontWeight: FontWeight.w600,
    );

    var selectedContacts = Provider.of<SelectedContacts>(
      context,
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: 40.0,
              height: 6.0,
              margin: const EdgeInsets.only(top: 60.0, bottom: 19.0),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(.20),
                borderRadius: BorderRadius.circular(3.0),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 18.0,
              ),
              decoration: BoxDecoration(
                color: ConstantColors.SEARCH_BAR_BACKGROUND,
                borderRadius: BorderRadius.circular(6.0),
              ),
              child: Column(
                children: [
                  SearchBar(
                    controller: _controller,
                    enabled: true,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemFill,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(6.0),
                        bottomRight: Radius.circular(6.0),
                      ),
                    ),
                    child: CupertinoSlidingSegmentedControl(
                      groupValue: _segmentedControlValue,
                      // backgroundColor: Colors.blue.shade200,
                      children: <int, Widget>{
                        0: Text(
                          'Connections',
                          style: segmentStyle,
                        ),
                        1: Text(
                          'Phone Contacts',
                          style: segmentStyle,
                        ),
                      },
                      onValueChanged: (value) {
                        setState(() {
                          _segmentedControlValue = value as int;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 9.0,
            ),
            Expanded(
              child: _segmentedControlValue == 0
                  ? SupercontactSelection(
                      filter: _filter,
                    )
                  : ContactsSelection(
                      toggleContact: (contact) => _toggleContact(
                        contact: contact,
                        context: context,
                      ),
                      filter: _filter,
                      contacts: _contacts,
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 55.0,
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              widget.shouldShowHistory
                  ? ViewHistoryButton(
                      bottomNavStyle: bottomNavStyle,
                    )
                  : GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Go Back',
                        style: bottomNavStyle,
                      ),
                    ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _sendVM,
                child: Text(
                  'Send VM',
                  style: TextStyle(
                    color: selectedContacts.isEmpty()
                        ? ConstantColors.GRAY_TEXT
                        : ConstantColors.PRIMARY,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ViewHistoryButton extends StatefulWidget {
  const ViewHistoryButton({
    Key? key,
    required this.bottomNavStyle,
  }) : super(key: key);

  final TextStyle bottomNavStyle;

  @override
  _ViewHistoryButtonState createState() => _ViewHistoryButtonState();
}

class _ViewHistoryButtonState extends State<ViewHistoryButton> {
  ConnectionService _connectionService = ConnectionService();
  Connection? _connection;

  @override
  Widget build(BuildContext context) {
    var selectedContacts = Provider.of<SelectedContacts>(
      context,
    );

    TextStyle disabledStyle = TextStyle(
      color: ConstantColors.GRAY_TEXT,
      fontSize: widget.bottomNavStyle.fontSize,
      fontWeight: widget.bottomNavStyle.fontWeight,
    );

    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) async {
      _connection = await _connectionService.getConnectionFromSelected(
        selectedContacts: selectedContacts,
      );
    });

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (_connection == null) {
          return;
        }

        SuperNavigator.push(
          context: context,
          widget: ConnectionGrid(
            connection: _connection!,
          ),
          fullScreen: true,
        );
      },
      child: Text(
        'View History',
        style: _connection == null ? disabledStyle : widget.bottomNavStyle,
      ),
    );
  }
}
