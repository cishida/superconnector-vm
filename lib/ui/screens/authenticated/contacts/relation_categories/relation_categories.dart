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
import 'package:superconnector_vm/ui/screens/authenticated/contacts/relations/relations.dart';

class RelationCategories extends StatefulWidget {
  const RelationCategories({
    Key? key,
    this.connection,
  }) : super(key: key);

  final Connection? connection;

  @override
  _RelationCategoriesState createState() => _RelationCategoriesState();
}

class _RelationCategoriesState extends State<RelationCategories> {
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

  void _toRelations({
    required String tag,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.93,
          child: Relations(),
        );
      },
    );
  }

  void _onCustom() {
    final String title = 'Write your own';
    final String subtitle = 'Pick a name for your relation.';

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
                isGroup: false,
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
    tags.addAll(ConstantStrings.RELATION_CATEGORIES);
    tags.add('None');

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
              child: ListView.builder(
                itemCount: tags.length,
                itemBuilder: (context, index) {
                  if (tags[index] == 'Write your own') {
                    return RelationTile(
                      relation: tags[index],
                      onPress: () => _onCustom(),
                    );
                  } else {
                    return RelationTile(
                      relation: tags[index],
                      onPress: () => _toRelations(
                        tag: tags[index],
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
