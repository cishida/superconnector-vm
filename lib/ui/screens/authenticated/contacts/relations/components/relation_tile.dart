import 'package:flutter/material.dart';
import 'package:superconnector_vm/ui/components/underline.dart';

class RelationTile extends StatefulWidget {
  const RelationTile({
    Key? key,
    required this.relation,
    required this.onPress,
  }) : super(key: key);

  final String relation;
  final Function onPress;

  @override
  _RelationTileState createState() => _RelationTileState();
}

class _RelationTileState extends State<RelationTile> {
  bool _isPressed = false;
  double _tileHeight = 60.0;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onPress();
        setState(() {
          _isPressed = false;
        });
      },
      onTapDown: (details) {
        setState(() {
          _isPressed = true;
        });
      },
      onTapCancel: () {
        Future.delayed(Duration(milliseconds: 100))
            .then((value) => setState(() {
                  _isPressed = false;
                }));
      },
      child: Stack(
        children: [
          Container(
            height: _tileHeight,
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
                          color: Colors.black,
                        ),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(left: 18.4),
                  child: Underline(
                    color: Colors.black.withOpacity(.08),
                  ),
                ),
              ],
            ),
          ),
          if (_isPressed)
            Container(
              color: Colors.white.withOpacity(.2),
              height: _tileHeight,
              width: double.infinity,
            ),
        ],
      ),
    );
  }
}
