import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/selected_contacts.dart';
import 'package:superconnector_vm/core/utils/constants/values.dart';
import 'package:superconnector_vm/core/utils/nav/super_navigator.dart';
import 'package:superconnector_vm/ui/components/buttons/chevron_back_button.dart';

class RecordOverlay extends StatelessWidget {
  const RecordOverlay({
    Key? key,
    this.isRecording = false,
  }) : super(key: key);

  final bool isRecording;

  String _getNamesFromContacts(
      BuildContext context, SelectedContacts selectedContacts) {
    String names = '';

    selectedContacts.getSelectedSupercontacts.forEach((element) {
      if (names.isEmpty) {
        names += element.fullName;
      } else {
        names += ', ' + element.fullName;
      }
    });
    selectedContacts.getSelectedContacts.forEach((element) {
      String contactName = '';
      if (element.givenName != null && element.givenName!.isNotEmpty) {
        contactName += element.givenName!;
      }
      if (element.familyName != null && element.familyName!.isNotEmpty) {
        if (contactName.isNotEmpty) {
          contactName += ' ';
        }
        contactName += element.familyName!;
      }

      if (names.isEmpty) {
        names += contactName;
      } else {
        names += ', ' + contactName;
      }
    });

    if (names.isEmpty) {
      names = 'Add Recipient(s)';
    } else {
      names = 'To ' + names;
    }

    return names;
  }

  @override
  Widget build(BuildContext context) {
    var selectedContacts = Provider.of<SelectedContacts>(
      context,
    );

    return Stack(
      children: [
        Positioned(
          top: 50.0,
          left: 0.0,
          child: ChevronBackButton(
            onBack: () {
              selectedContacts.reset();
              Navigator.pop(context);
            },
          ),
        ),
        if (!selectedContacts.isEmpty())
          Positioned.fill(
            top: 50.0,
            right: 62.0,
            left: 62.0,
            child: Align(
              alignment: Alignment.topCenter,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  SuperNavigator.handleContactsNavigation(
                    context: context,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 6.0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32.0),
                    color: Colors.white.withOpacity(.20),
                  ),
                  child: Text(
                    _getNamesFromContacts(context, selectedContacts),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        // if (!isRecording)
        Positioned(
          top: 60.0,
          right: 10.0,
          child: AnimatedOpacity(
            opacity: !isRecording ? 1.0 : 0.0,
            duration: const Duration(
              milliseconds: ConstantValues.CAMERA_OVERLAY_FADE_MILLISECONDS,
            ),
            child: Column(
              children: [
                CameraIcon(
                  title: 'Flip',
                  imageName:
                      'assets/images/authenticated/record/camera-flip-icon.png',
                  onPress: () {},
                ),
                // CameraIcon(
                //   title: 'Attach',
                //   imageName:
                //       'assets/images/authenticated/record/camera-attachment-icon.png',
                //   onPress: () {},
                // ),
                // CameraIcon(
                //   title: 'Link',
                //   imageName:
                //       'assets/images/authenticated/record/camera-link-icon.png',
                //   onPress: () {},
                // ),
                // CameraIcon(
                //   title: 'Caption',
                //   imageName:
                //       'assets/images/authenticated/record/camera-caption-icon.png',
                //   onPress: () {},
                // ),
                // CameraIcon(
                //   title: 'Filters',
                //   imageName:
                //       'assets/images/authenticated/record/camera-filter-icon.png',
                //   onPress: () {},
                // ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CameraIcon extends StatelessWidget {
  const CameraIcon({
    Key? key,
    required this.imageName,
    required this.title,
    required this.onPress,
  }) : super(key: key);

  final String imageName;
  final String title;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onPress(),
      child: Column(
        children: [
          Image.asset(
            imageName,
            width: 24.0,
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 4.0,
              bottom: 26.0,
            ),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
