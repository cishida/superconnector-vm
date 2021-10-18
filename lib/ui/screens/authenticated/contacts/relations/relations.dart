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
    this.tag = 'Family',
  }) : super(key: key);

  final Connection? connection;
  final String tag;

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
        widget.connection!.tagCategories.addAll({
          superuser.id: widget.tag,
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

    final List<String> tags = ['Write your own'];
    switch (widget.tag) {
      case 'Family':
        tags.addAll(ConstantStrings.FAMILY_RELATIONS);
        break;
      case 'Friend':
        tags.addAll(ConstantStrings.FRIEND_RELATIONS);
        break;
      case 'Professional':
        tags.addAll(ConstantStrings.PROFESSIONAL_RELATIONS);
        break;
      default:
        tags.addAll(ConstantStrings.FAMILY_RELATIONS);
        break;
    }

    // if (widget.connection == null) {
    //   tags.add('Group');
    // }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              'assets/images/authenticated/tag-background.png',
            ),
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: BottomSheetTab(),
            ),
            Padding(
              padding: const EdgeInsets.only(
                // left: 20.0,
                bottom: 19.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                      'Add a private tag to stay organized.',
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
              child: Container(
                color: Colors.white,
                child: ListView.builder(
                  itemCount: tags.length,
                  itemBuilder: (context, index) {
                    if (tags[index] == 'Write your own' ||
                        tags[index] == 'Group') {
                      return RelationTile(
                        relation: tags[index],
                        onPress: () => _onCustom(
                          tags[index],
                        ),
                      );
                    } else {
                      return RelationTile(
                        relation: tags[index],
                        onPress: () => _toContacts(
                          tag: tags[index],
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
