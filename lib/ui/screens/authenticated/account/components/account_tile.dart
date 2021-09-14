import 'package:flutter/material.dart';
import 'package:superconnector_vm/ui/components/underline.dart';

class AccountTile extends StatefulWidget {
  const AccountTile({
    Key? key,
    required this.title,
    this.subtitle,
    this.showChevron = true,
    required this.onPress,
  }) : super(key: key);

  final String title;
  final String? subtitle;
  final bool showChevron;
  final Function onPress;

  @override
  _AccountTileState createState() => _AccountTileState();
}

class _AccountTileState extends State<AccountTile> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    double tileHeight = widget.subtitle != null ? 90.0 : 65.0;

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
            height: tileHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w600,
                              letterSpacing: .2,
                            ),
                          ),
                          if (widget.subtitle != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                widget.subtitle!,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                      Spacer(),
                      if (widget.showChevron)
                        Image.asset(
                          'assets/images/authenticated/account-chevron-right.png',
                          width: 7.0,
                        ),
                    ],
                  ),
                ),
                Spacer(),
                Underline(
                  color: Colors.white.withOpacity(.2),
                ),
              ],
            ),
          ),
          if (_isPressed)
            Container(
              color: Colors.white.withOpacity(.2),
              height: tileHeight,
              width: double.infinity,
            ),
        ],
      ),
    );
  }
}
