// import 'package:flutter/material.dart';

// class SendVMButton extends StatelessWidget {
//   const SendVMButton({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       behavior: HitTestBehavior.opaque,
//       onTap: () async {
//         if (_pressed) {
//           return;
//         }

//         setState(() {
//           _pressed = true;
//         });

//         var selectedContacts = Provider.of<SelectedContacts>(
//           context,
//           listen: false,
//         );

//         if (_betterController != null &&
//             _betterController!.isPlaying() != null &&
//             _betterController!.isPlaying()!) {
//           await _betterController!.pause();
//         }

//         if (widget.connection == null) {
//           SuperNavigator.handleContactsNavigation(
//             context: context,
//             sendVM: sendVM,
//           );
//         } else {
//           selectedContacts.addConnection(widget.connection!);
//           sendVM();

//           Navigator.of(context).popUntil((route) => route.isFirst);

//           Provider.of<BottomNavProvider>(
//             context,
//             listen: false,
//           ).setIndex(1);
//         }

//         setState(() {
//           _pressed = false;
//         });
//       },
//       child: Padding(
//         padding: const EdgeInsets.only(top: 4.0),
//         child: Image.asset(
//           'assets/images/authenticated/record/send-vm-button.png',
//           width: 46.0,
//         ),
//       ),
//     );
//   }
// }
