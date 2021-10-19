import 'package:flutter/material.dart';
import 'package:superconnector_vm/core/models/connection/connection.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';
import 'package:superconnector_vm/core/utils/constants/strings.dart';
import 'package:superconnector_vm/ui/components/bottom_sheet_tab.dart';
import 'package:superconnector_vm/ui/components/underline.dart';
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
  // void _toContacts({
  //   required String tag,
  //   bool isGroup = false,
  // }) {
  //   Navigator.of(context).pop();

  //   if (tag == 'None') {
  //     return;
  //   }

  //   if (widget.connection == null) {
  //     showModalBottomSheet(
  //       context: context,
  //       isScrollControlled: true,
  //       builder: (context) {
  //         return FractionallySizedBox(
  //           heightFactor: 0.93,
  //           child: Contacts(
  //             tag: tag,
  //             isGroup: isGroup,
  //           ),
  //         );
  //       },
  //     );
  //   } else {
  //     final superuser = Provider.of<Superuser?>(
  //       context,
  //       listen: false,
  //     );
  //     if (superuser != null) {
  //       widget.connection!.tags.addAll({
  //         superuser.id: tag,
  //       });
  //       widget.connection!.update();
  //     }
  //   }
  //   // Navigator.of(context).pop();
  // }

  void _toRelations({
    required String tag,
  }) {
    Navigator.of(context).pop();

    if (tag == 'None') {
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.93,
          child: Relations(
            tag: tag,
            connection: widget.connection,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    final List<String> tags = [];
    tags.addAll(ConstantStrings.RELATION_CATEGORIES);
    tags.add('None');

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: size.width,
        decoration: BoxDecoration(
          color: ConstantColors.DARK_BLUE,
          // image: DecorationImage(
          //   fit: BoxFit.cover,
          //   image: AssetImage(
          //     'assets/images/authenticated/tag-category-background.png',
          //   ),
          // ),
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
                    'Private Tag',
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
                      'What type of tag do you want to add?',
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
                    return RelationTile(
                      relation: tags[index],
                      onPress: () => _toRelations(
                        tag: tags[index],
                      ),
                    );
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
