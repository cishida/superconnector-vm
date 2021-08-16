import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/selected_contacts.dart';
import 'package:superconnector_vm/ui/screens/authenticated/contacts/contacts_selection/components/contact_item.dart';
import 'package:superconnector_vm/ui/screens/authenticated/contacts/contacts_selection/components/contacts_group_separator.dart';

class ContactsSelection extends StatefulWidget {
  const ContactsSelection({
    Key? key,
    required this.toggleContact,
    // required this.selectedContacts,
    this.filter = '',
    required this.contacts,
  }) : super(key: key);

  final Function(Contact) toggleContact;
  // final List<Contact> selectedContacts;
  final String filter;
  final Iterable<Contact>? contacts;

  @override
  _ContactsSelectionState createState() => _ContactsSelectionState();
}

class _ContactsSelectionState extends State<ContactsSelection> {
  @override
  Widget build(BuildContext context) {
    if (widget.contacts == null) {
      return Center(
        child: const CircularProgressIndicator(),
      );
    }

    var selectedContacts = Provider.of<SelectedContacts>(
      context,
    );

    List<Contact> filteredContacts = widget.contacts!.where((contact) {
      return widget.filter == '' ||
          (widget.filter != '' &&
              contact.displayName!
                  .toLowerCase()
                  .contains(widget.filter.toLowerCase()));
    }).toList();

    return Padding(
      padding: const EdgeInsets.only(top: 11.0),
      child: GroupedListView<dynamic, String>(
        elements: filteredContacts,
        groupBy: (contact) => (contact as Contact).displayName![0],
        groupSeparatorBuilder: (String groupByValue) => ContactsGroupSeparator(
          text: groupByValue,
        ),
        itemBuilder: (context, contact) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => widget.toggleContact(contact),
            child: ContactItem(
              contact: contact,
              isSelected: selectedContacts.containsContact(contact),
            ),
          );
        },
        itemComparator: (contact1, contact2) => (contact1 as Contact)
            .displayName!
            .compareTo((contact2 as Contact).displayName!), // optional
        useStickyGroupSeparators: true, // optional
        floatingHeader: true, // optional
        order: GroupedListOrder.ASC, // optional
      ),
    );

    // return ListView.builder(
    //   itemCount: widget.contacts?.length ?? 0,
    //   itemBuilder: (BuildContext context, int index) {
    //     Contact contact = widget.contacts!.elementAt(index);
    //     return ListTile(
    //       contentPadding: const EdgeInsets.symmetric(
    //         vertical: 2,
    //         horizontal: 18,
    //       ),
    //       leading: (contact.avatar != null && contact.avatar!.isNotEmpty)
    //           ? CircleAvatar(
    //               backgroundImage: MemoryImage(contact.avatar!),
    //             )
    //           : CircleAvatar(
    //               child: Text(
    //                 contact.initials(),
    //               ),
    //               backgroundColor: Theme.of(context).accentColor,
    //             ),
    //       title: Text(contact.displayName ?? ''),
    //     );
    //   },
    // );
  }
}
