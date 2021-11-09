// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:superconnector_vm/core/models/superuser/superuser.dart';
// import 'package:superconnector_vm/ui/components/gradient_background.dart';
// import 'package:superconnector_vm/ui/screens/authenticated/contacts/contacts_selection/contacts_selection.dart';

// class IntroSelection extends StatefulWidget {
//   const IntroSelection({Key? key}) : super(key: key);

//   @override
//   _IntroSelectionState createState() => _IntroSelectionState();
// }

// class _IntroSelectionState extends State<IntroSelection> {
//   @override
//   void initState() {
//     super.initState();
//     getContacts();
//     _controller.addListener(() {
//       if (mounted) {
//         setState(() {
//           _filter = _controller.text;
//         });
//       }
//     });
//   }

//   bool _isValidContact(Contact contact) {
//     bool hasName = contact.displayName != null && contact.displayName != '';
//     bool hasNumber = contact.phones != null && contact.phones!.isNotEmpty;

//     return hasName && hasNumber;
//   }

//   Future<void> getContacts() async {
//     final Iterable<Contact> contacts = await ContactsService.getContacts();
//     setState(() {
//       _contacts = contacts.where((contact) {
//         return _isValidContact(contact);
//       });
//     });

//     final superuser = Provider.of<Superuser?>(context, listen: false);
//     if (_contacts != null && superuser != null) {
//       _supercontactService.syncContacts(superuser, _contacts!.toList());
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GradientBackground(
//       title: 'Intro',
//       subtitle: 'Choose 2 people to introduce',
//       child: ContactsSelection(
//         isSelectable: true,
//         contacts: ,
//       ),
//     );
//   }
// }
