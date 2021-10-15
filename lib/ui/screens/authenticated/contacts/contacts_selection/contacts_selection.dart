import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/connection/connection.dart';
import 'package:superconnector_vm/core/models/selected_contacts.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/services/superuser/superuser_service.dart';
import 'package:superconnector_vm/ui/screens/authenticated/contacts/contacts_selection/components/contact_item.dart';
import 'package:superconnector_vm/ui/screens/authenticated/contacts/contacts_selection/components/superuser_item.dart';
import 'package:superconnector_vm/ui/screens/authenticated/contacts/supercontacts_selection/components/supercontact_item.dart';

class ContactsSelection extends StatefulWidget {
  const ContactsSelection({
    Key? key,
    required this.onTapContact,
    required this.isSelectable,
    this.filter = '',
    required this.contacts,
  }) : super(key: key);

  final Function(Contact) onTapContact;
  final bool isSelectable;
  final String filter;
  final Iterable<Contact> contacts;

  @override
  _ContactsSelectionState createState() => _ContactsSelectionState();
}

class _ContactsSelectionState extends State<ContactsSelection> {
  List<Contact> _sortedContacts = [];
  List<Superuser>? _superusers;
  SuperuserService _superuserService = SuperuserService();

  Future _loadUsers() async {
    List<Superuser> tempSuperusers = [];
    final currentSuperuser = Provider.of<Superuser?>(
      context,
      listen: false,
    );
    var connections = Provider.of<List<Connection>>(
      context,
      listen: false,
    );

    if (currentSuperuser == null) {
      return;
    }

    for (var i = 0; i < connections.length; i++) {
      List<String> ids = tempSuperusers.map((e) => e.id).toList();

      for (var id in connections[i].userIds) {
        if (id != currentSuperuser.id && !ids.contains(id)) {
          Superuser? superuser = await _superuserService.getSuperuserFromId(id);
          if (superuser != null) {
            tempSuperusers.add(superuser);
          }
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

    var connections = Provider.of<List<Connection>>(
      context,
    );

    if (connections.length > 0 &&
        (_superusers == null || _superusers!.length == 0)) {
      _loadUsers();
    }

    if (_superusers == null) {
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

    return Padding(
      padding: const EdgeInsets.only(top: 11.0),
      child: ListView.builder(
        itemCount: filteredContacts.length + _superusers!.length,
        itemBuilder: (context, index) {
          if (index < _superusers!.length) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => widget.onTapContact(filteredContacts[index]),
              child: SuperuserItem(
                superuser: _superusers![index],
                isSelectable: widget.isSelectable,
                isSelected: selectedContacts.contains(
                  filteredContacts[index],
                ),
              ),
            );
          }

          int effectiveIndex = index - _superusers!.length;

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
