import 'package:flutter/material.dart';
import 'package:superconnector_vm/ui/components/underline.dart';

class RelationTile extends StatefulWidget {
  const RelationTile({
    Key? key,
    required this.relation,
  }) : super(key: key);

  final String relation;

  @override
  _RelationTileState createState() => _RelationTileState();
}

class _RelationTileState extends State<RelationTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(
              left: 20.0,
            ),
            child: Text(
              widget.relation,
              style: Theme.of(context).textTheme.button!.copyWith(
                    letterSpacing: .15,
                  ),
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(left: 18.4),
            child: Underline(
              color: Colors.white.withOpacity(.2),
            ),
          ),
        ],
      ),
    );
  }
}
