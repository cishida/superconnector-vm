import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/selected_contacts.dart';
import 'package:superconnector_vm/core/models/supercontact/supercontact.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/ui/screens/authenticated/contacts/contacts_selection/components/contacts_group_separator.dart';
import 'package:superconnector_vm/ui/screens/authenticated/contacts/supercontacts_selection/components/supercontact_item.dart';

class SupercontactSelection extends StatefulWidget {
  const SupercontactSelection({
    Key? key,
    this.filter = '',
  }) : super(key: key);

  final String filter;

  @override
  _SupercontactSelectionState createState() => _SupercontactSelectionState();
}

class _SupercontactSelectionState extends State<SupercontactSelection> {
  @override
  Widget build(BuildContext context) {
    final superuser = context.watch<Superuser?>();

    if (superuser == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    var selectedContacts = Provider.of<SelectedContacts>(context);

    return Consumer<List<Supercontact>>(
      builder: (context, supercontacts, child) {
        List<Supercontact> filteredSupercontacts =
            supercontacts.where((supercontact) {
          return widget.filter == '' ||
              (widget.filter != '' &&
                  supercontact.fullName
                      .toLowerCase()
                      .contains(widget.filter.toLowerCase()));
        }).toList();

        return Padding(
          padding: const EdgeInsets.only(top: 11.0),
          child: GroupedListView<dynamic, String>(
            elements: filteredSupercontacts,
            groupBy: (supercontact) =>
                (supercontact as Supercontact).fullName[0],
            groupSeparatorBuilder: (String groupByValue) =>
                ContactsGroupSeparator(
              text: groupByValue,
            ),
            itemBuilder: (context, supercontact) {
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  if (selectedContacts.containsSupercontact(supercontact)) {
                    selectedContacts.removeSupercontact(
                      supercontact.phoneNumber,
                    );
                  } else {
                    selectedContacts.addSupercontact(supercontact);
                  }
                },
                child: SupercontactItem(
                  supercontact: supercontact,
                  isSelected:
                      selectedContacts.containsSupercontact(supercontact),
                ),
              );
            },
            itemComparator: (supercontact1, supercontact2) =>
                (supercontact1 as Supercontact).fullName.compareTo(
                    (supercontact2 as Supercontact).fullName), // optional
            useStickyGroupSeparators: true, // optional
            floatingHeader: true, // optional
            order: GroupedListOrder.ASC, // optional
          ),
        );
      },
    );
  }
}
