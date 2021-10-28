import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/connection/connection.dart';
import 'package:superconnector_vm/core/models/selected_contacts.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/services/superuser/superuser_service.dart';
import 'package:superconnector_vm/core/utils/constants/strings.dart';
import 'package:superconnector_vm/ui/screens/authenticated/contacts/contacts_selection/components/contact_item.dart';
import 'package:superconnector_vm/ui/screens/authenticated/contacts/contacts_selection/components/superuser_item.dart';

class ContactsSelection extends StatefulWidget {
  const ContactsSelection({
    Key? key,
    required this.onTapContact,
    required this.onTapSuperuser,
    required this.isSelectable,
    this.filter = '',
    required this.contacts,
  }) : super(key: key);

  final Function(Contact) onTapContact;
  final Function(Superuser) onTapSuperuser;
  final bool isSelectable;
  final String filter;
  final Iterable<Contact> contacts;

  @override
  _ContactsSelectionState createState() => _ContactsSelectionState();
}

class _ContactsSelectionState extends State<ContactsSelection> {
  List<Contact> _sortedContacts = [];
  // List<Superuser>? _superusers;
  SuperuserService _superuserService = SuperuserService();
  // List<Connection> _connections = [];

  // Future _loadUsers() async {
  //   if (!widget.isSelectable) {
  //     setState(() {
  //       _superusers = [];
  //     });
  //     return;
  //   }

  //   List<Superuser> tempSuperusers = [];
  //   _connections = [];
  //   final currentSuperuser = Provider.of<Superuser?>(
  //     context,
  //     listen: false,
  //   );
  //   var connections = Provider.of<List<Connection>>(
  //     context,
  //     listen: false,
  //   );

  //   if (currentSuperuser == null) {
  //     return;
  //   }

  //   var filteredConnections =
  //       connections.where((e) => e.userIds.length == 2).toList();

  //   for (var i = 0; i < filteredConnections.length; i++) {
  //     List<String> ids = tempSuperusers.map((e) => e.id).toList();

  //     for (var id in filteredConnections[i].userIds) {
  //       if (id != currentSuperuser.id && !ids.contains(id)) {
  //         Superuser? superuser = await _superuserService.getSuperuserFromId(id);

  //         if (superuser != null) {
  //           tempSuperusers.add(superuser);
  //           filteredConnections[i].superusers.add(superuser);
  //           _connections.add(filteredConnections[i]);
  //         }
  //       }
  //     }
  //   }

  //   if (mounted) {
  //     setState(() {
  //       _superusers = tempSuperusers;
  //     });
  //   }
  // }

  @override
  void initState() {
    super.initState();

    // Future.delayed(Duration.zero, () {
    //   _loadUsers();
    // });

    _sortedContacts = widget.contacts.toList();
    _sortedContacts.sort((a, b) {
      return a.displayName!.compareTo(b.displayName!);
    });
  }

  @override
  Widget build(BuildContext context) {
    var selectedContacts = Provider.of<SelectedContacts>(
      context,
    );

    var currentSuperuser = Provider.of<Superuser?>(
      context,
    );

    var connections = Provider.of<List<Connection>>(
      context,
    );

    // if (connections.length > 0 &&
    //     (_superusers == null || _superusers!.length == 0)) {
    //   _loadUsers();
    // }

    if (currentSuperuser == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    List<Contact> filteredContacts = _sortedContacts.where((contact) {
      return widget.filter == '' ||
          (widget.filter != '' &&
              contact.displayName!
                  .toLowerCase()
                  .contains(widget.filter.toLowerCase()));
    }).toList();

    List<Connection> filteredConnections = connections.where((connection) {
      return connection.userIds.length + connection.phoneNumberNameMap.length ==
              2 &&
          connection.superusers.isNotEmpty &&
          !connection.userIds.contains(ConstantStrings.SUPERCONNECTOR_ID);
    }).toList();

    return Padding(
      padding: const EdgeInsets.only(top: 11.0),
      child: ListView.builder(
        itemCount: filteredContacts.length +
            filteredConnections.length +
            1, // Extra for self
        itemBuilder: (context, index) {
          if (index == 0) {
            return SuperuserItem(
              superuser: currentSuperuser,
              tag: 'Me',
              isSelectable: true,
              isSelected: true,
            );
          }
          int effectiveIndex = index - 1;

          if (effectiveIndex < filteredConnections.length) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => widget.onTapSuperuser(
                  filteredConnections[effectiveIndex].superusers.first),
              child: SuperuserItem(
                superuser: filteredConnections[effectiveIndex].superusers[0],
                tag: filteredConnections[effectiveIndex]
                    .tags[currentSuperuser.id],
                isSelectable: widget.isSelectable,
                isSelected: selectedContacts.containsSuperuser(
                  filteredConnections[effectiveIndex].superusers[0],
                ),
              ),
            );
          }

          effectiveIndex = effectiveIndex - filteredConnections.length;

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => widget.onTapContact(filteredContacts[effectiveIndex]),
            child: ContactItem(
              contact: filteredContacts[effectiveIndex],
              isSelectable: widget.isSelectable,
              isSelected: selectedContacts.contains(
                filteredContacts[effectiveIndex],
              ),
            ),
          );
        },
      ),

      // GroupedListView<dynamic, String>(
      //   elements: filteredContacts,
      //   groupBy: (contact) => (contact as Contact).displayName![0],
      //   groupSeparatorBuilder: (String groupByValue) => ContactsGroupSeparator(
      //     text: groupByValue,
      //   ),
      //   itemBuilder: (context, contact) {
      //     return GestureDetector(
      //       behavior: HitTestBehavior.opaque,
      //       onTap: () => widget.onTapContact(contact),
      //       child: ContactItem(
      //         contact: contact,
      //         isSelected: selectedContacts.containsContact(contact),
      //       ),
      //     );
      //   },
      //   itemComparator: (contact1, contact2) => (contact1 as Contact)
      //       .displayName!
      //       .compareTo((contact2 as Contact).displayName!), // optional
      //   useStickyGroupSeparators: true, // optional
      //   floatingHeader: true, // optional
      //   order: GroupedListOrder.ASC, // optional
      // ),
    );
  }
}
