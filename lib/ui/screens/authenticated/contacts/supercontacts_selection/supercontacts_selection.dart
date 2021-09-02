// import 'package:flutter/material.dart';
// import 'package:grouped_list/grouped_list.dart';
// import 'package:provider/provider.dart';
// import 'package:superconnector_vm/core/models/selected_contacts.dart';
// import 'package:superconnector_vm/core/models/supercontact/supercontact.dart';
// import 'package:superconnector_vm/core/models/superuser/superuser.dart';
// import 'package:superconnector_vm/ui/screens/authenticated/contacts/contacts_selection/components/contacts_group_separator.dart';
// import 'package:superconnector_vm/ui/screens/authenticated/contacts/supercontacts_selection/components/supercontact_item.dart';

// class SupercontactSelection extends StatefulWidget {
//   const SupercontactSelection({
//     Key? key,
//     this.filter = '',
//     required this.toContacts,
//   }) : super(key: key);

//   final String filter;
//   final Function toContacts;

//   @override
//   _SupercontactSelectionState createState() => _SupercontactSelectionState();
// }

// class _SupercontactSelectionState extends State<SupercontactSelection> {
//   @override
//   Widget build(BuildContext context) {
//     final superuser = context.watch<Superuser?>();

//     if (superuser == null) {
//       return Center(
//         child: CircularProgressIndicator(),
//       );
//     }

//     var selectedContacts = Provider.of<SelectedContacts>(context);

//     return Consumer<List<Supercontact>>(
//       builder: (context, supercontacts, child) {
//         List<Supercontact> filteredSupercontacts =
//             supercontacts.where((supercontact) {
//           return widget.filter == '' ||
//               (widget.filter != '' &&
//                   supercontact.fullName
//                       .toLowerCase()
//                       .contains(widget.filter.toLowerCase()));
//         }).toList();

//         filteredSupercontacts = filteredSupercontacts
//             .where(
//               (supercontact) => !superuser.blockedUsers.keys.toList().contains(
//                     supercontact.targetUserId,
//                   ),
//             )
//             .toList();
//         filteredSupercontacts.sort((a, b) => b.fullName.compareTo(a.fullName));

//         if (filteredSupercontacts.length == 0) {
//           return ContactsRedirectGraphic(
//             toContacts: widget.toContacts,
//           );
//         }

//         return Padding(
//           padding: const EdgeInsets.only(top: 11.0),
//           child: GroupedListView<dynamic, String>(
//             elements: filteredSupercontacts,
//             groupBy: (supercontact) =>
//                 (supercontact as Supercontact).fullName[0],
//             groupSeparatorBuilder: (String groupByValue) =>
//                 ContactsGroupSeparator(
//               text: groupByValue,
//             ),
//             itemBuilder: (context, supercontact) {
//               supercontact = supercontact as Supercontact;

//               return Column(
//                 children: [
//                   GestureDetector(
//                     behavior: HitTestBehavior.opaque,
//                     onTap: () {
//                       if (selectedContacts.containsSupercontact(supercontact)) {
//                         selectedContacts.removeSupercontact(
//                           supercontact.phoneNumber,
//                         );
//                       } else {
//                         selectedContacts.addSupercontact(supercontact);
//                       }
//                     },
//                     child: SupercontactItem(
//                       supercontact: supercontact,
//                       isSelected:
//                           selectedContacts.containsSupercontact(supercontact),
//                     ),
//                   ),
//                   if (supercontact.id == filteredSupercontacts.last.id)
//                     ContactsRedirectGraphic(
//                       toContacts: widget.toContacts,
//                     ),
//                 ],
//               );
//             },
//             itemComparator: (supercontact1, supercontact2) =>
//                 (supercontact1 as Supercontact).fullName.compareTo(
//                     (supercontact2 as Supercontact).fullName), // optional
//             useStickyGroupSeparators: true, // optional
//             floatingHeader: true, // optional
//             order: GroupedListOrder.ASC, // optional
//           ),
//         );
//       },
//     );
//   }
// }

// class ContactsRedirectGraphic extends StatelessWidget {
//   const ContactsRedirectGraphic({
//     Key? key,
//     required this.toContacts,
//   }) : super(key: key);

//   final Function toContacts;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         SizedBox(height: 67.0),
//         Text(
//           'Want more connections?',
//           style: TextStyle(
//             fontSize: 20.0,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         SizedBox(
//           height: 6.0,
//         ),
//         Text(
//           'You can VM anyone in your phone contacts\nto connect with them.',
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontSize: 17.0,
//             fontWeight: FontWeight.w400,
//           ),
//         ),
//         SizedBox(
//           height: 32.0,
//         ),
//         ElevatedButton(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 38.0),
//             child: Text(
//               'View Phone Contacts',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 18.0,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//           style: ElevatedButton.styleFrom(
//             minimumSize: Size(0, 50),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(
//                 8.0,
//               ),
//             ),
//           ),
//           onPressed: () => toContacts(),
//         ),
//         SizedBox(
//           height: 38.0,
//         ),
//         Image.asset(
//           'assets/images/authenticated/sitting-people.png',
//           height: 331.0,
//         ),
//       ],
//     );
//   }
// }
