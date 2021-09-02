import 'package:flutter/material.dart';
import 'package:superconnector_vm/core/utils/constants/strings.dart';
import 'package:superconnector_vm/ui/components/bottom_sheet_tab.dart';
import 'package:superconnector_vm/ui/components/overlay_input.dart';
import 'package:superconnector_vm/ui/components/underline.dart';
import 'package:superconnector_vm/ui/screens/authenticated/contacts/contacts.dart';
import 'package:superconnector_vm/ui/screens/authenticated/contacts/relations/components/relation_tile.dart';

class Relations extends StatefulWidget {
  const Relations({Key? key}) : super(key: key);

  @override
  _RelationsState createState() => _RelationsState();
}

class _RelationsState extends State<Relations> {
  String _customRelation = '';

  void _toContacts(String tag) {
    Navigator.of(context).pop();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.93,
          child: Contacts(
            tag: tag,
          ),
        );
      },
    );
    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

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
                itemCount: ConstantStrings.FAMILY_RELATIONS.length + 2,
                itemBuilder: (context, index) {
                  final List<String> relations =
                      ConstantStrings.FAMILY_RELATIONS + ['Custom', 'Group'];
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      if (relations[index] == 'Custom') {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            opaque: false,
                            pageBuilder: (BuildContext context, _, __) {
                              // 'Custom Relation'
                              // 'Pick a name for your relation.'
                              return OverlayInput(
                                fieldName: 'Relation',
                                exampleText:
                                    _customRelation.length.toString() + ' / 50',
                                explanation: Center(
                                  child: Column(
                                    children: [
                                      Text(
                                        'Custom Relation',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5!
                                            .copyWith(
                                              color: Colors.white,
                                            ),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(
                                        'Pick a name for your relation.',
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1!
                                            .copyWith(
                                              color: Colors.white,
                                            ),
                                      ),
                                      SizedBox(
                                        height: 92.0,
                                      ),
                                    ],
                                  ),
                                ),
                                textCapitalization: TextCapitalization.words,
                                textInputAction: TextInputAction.done,
                                onChanged: (text) {
                                  setState(() {
                                    _customRelation = text;
                                  });
                                },
                                onSubmit: (text) async {
                                  _toContacts(text);
                                },
                              );
                            },
                          ),
                        );
                      } else {
                        _toContacts(relations[index]);
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
