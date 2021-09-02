import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/connection/connection.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/utils/constants/strings.dart';
import 'package:superconnector_vm/ui/components/bottom_sheet_tab.dart';
import 'package:superconnector_vm/ui/components/overlays/overlay_explanation.dart';
import 'package:superconnector_vm/ui/components/overlays/overlay_input.dart';
import 'package:superconnector_vm/ui/components/underline.dart';
import 'package:superconnector_vm/ui/screens/authenticated/contacts/contacts.dart';
import 'package:superconnector_vm/ui/screens/authenticated/contacts/relations/components/relation_tile.dart';

class Relations extends StatefulWidget {
  const Relations({
    Key? key,
    this.connection,
  }) : super(key: key);

  final Connection? connection;

  @override
  _RelationsState createState() => _RelationsState();
}

class _RelationsState extends State<Relations> {
  void _toContacts({
    required String tag,
    bool isGroup = false,
  }) {
    Navigator.of(context).pop();

    if (widget.connection == null) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return FractionallySizedBox(
            heightFactor: 0.93,
            child: Contacts(
              tag: tag,
              isGroup: isGroup,
            ),
          );
        },
      );
    } else {
      final superuser = Provider.of<Superuser?>(
        context,
        listen: false,
      );
      if (superuser != null) {
        widget.connection!.tags.addAll({
          superuser.id: tag,
        });
        widget.connection!.update();
      }
    }
    // Navigator.of(context).pop();
  }

  void _onCustom(String relation) {
    final String title = relation == 'Group' ? 'Group Name' : 'Custom Relation';
    final String subtitle = relation == 'Group'
        ? 'Only you can see your group names.'
        : 'Pick a name for your relation.';

    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return OverlayInput(
            fieldName: 'Relation',
            explanation: OverlayExplanation(
              title: title,
              subtitle: subtitle,
            ),
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.done,
            onSubmit: (text) async {
              _toContacts(
                tag: text,
                isGroup: relation == 'Group',
              );
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    final List<String> addedItems = ['Custom'];
    if (widget.connection == null) {
      addedItems.add('Group');
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              'assets/images/authenticated/gradient-background.png',
            ),
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: BottomSheetTab(),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                bottom: 19.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'New Connection',
                    style: Theme.of(context).textTheme.headline5!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 20.0,
                        ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 5.0,
                    ),
                    child: Text(
                      'Choose your family relation',
                      style: Theme.of(context).textTheme.bodyText1!,
                    ),
                  ),
                ],
              ),
            ),
            Underline(
              color: Colors.white.withOpacity(.2),
            ),
            Expanded(
              child: ListView.builder(
                itemCount:
                    ConstantStrings.FAMILY_RELATIONS.length + addedItems.length,
                itemBuilder: (context, index) {
                  final List<String> relations =
                      ConstantStrings.FAMILY_RELATIONS + addedItems;
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      if (relations[index] == 'Custom' ||
                          relations[index] == 'Group') {
                        _onCustom(
                          relations[index],
                        );
                      } else {
                        _toContacts(
                          tag: relations[index],
                        );
                      }
                    },
                    child: RelationTile(
                      relation: relations[index],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
