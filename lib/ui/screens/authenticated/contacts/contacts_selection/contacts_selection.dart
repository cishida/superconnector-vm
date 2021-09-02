import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/selected_contacts.dart';
import 'package:superconnector_vm/ui/screens/authenticated/contacts/contacts_selection/components/contact_item.dart';

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
  @override
  void initState() {
    super.initState();

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
        itemCount: filteredContacts.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => widget.onTapContact(filteredContacts[index]),
            child: ContactItem(
              contact: filteredContacts[index],
              isSelectable: widget.isSelectable,
              isSelected: selectedContacts.contains(
                filteredContacts[index],
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
