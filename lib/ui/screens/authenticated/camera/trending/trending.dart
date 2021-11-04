import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/camera/camera_handler.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';
import 'package:superconnector_vm/core/utils/constants/strings.dart';
import 'package:superconnector_vm/ui/components/gradient_background.dart';
import 'package:superconnector_vm/ui/components/underline.dart';

class Trending extends StatefulWidget {
  const Trending({Key? key}) : super(key: key);

  @override
  _TrendingState createState() => _TrendingState();
}

class _TrendingState extends State<Trending> {
  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      title: 'Trending',
      subtitle: 'Based on an analysis of anonymized captions.',
      child: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: ConstantStrings.TRENDING_LIST.length,
              itemBuilder: (context, index) {
                return TrendingTile(
                  index: index,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TrendingTile extends StatefulWidget {
  const TrendingTile({
    Key? key,
    required this.index,
  }) : super(key: key);

  final int index;

  @override
  State<TrendingTile> createState() => _TrendingTileState();
}

class _TrendingTileState extends State<TrendingTile> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final double leftPadding = 16.0;
    final double rightPadding = 20.0;
    final double numberWidth = 28.0;
    final double chevronWidth = 7.0;

    final cameraHandler = Provider.of<CameraHandler>(
      context,
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          _isPressed = true;
        });

        cameraHandler.caption = ConstantStrings.TRENDING_LIST[widget.index];

        Future.delayed(Duration(milliseconds: 50)).then(
          (value) {
            Navigator.of(context).pop();
            setState(() {
              _isPressed = false;
            });
          },
        );
      },
      child: Container(
        color: _isPressed
            ? ConstantColors.FAB_BACKGROUND.withOpacity(.08)
            : Colors.transparent,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: leftPadding,
                right: rightPadding,
                top: rightPadding,
                bottom: rightPadding,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: numberWidth,
                    width: numberWidth,
                    padding: const EdgeInsets.only(
                      left: .5,
                      bottom: .5,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(numberWidth / 2),
                      ),
                      color: Colors.black.withOpacity(.04),
                    ),
                    child: Center(
                      child: Text(
                        widget.index.toString(),
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.black.withOpacity(.3),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      right: leftPadding +
                          numberWidth -
                          rightPadding -
                          chevronWidth,
                    ),
                    child: Text(
                      ConstantStrings.TRENDING_LIST[widget.index],
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.black.withOpacity(.87),
                      ),
                    ),
                  ),
                  Image.asset(
                    'assets/images/authenticated/account-chevron-right.png',
                    width: chevronWidth,
                    color: Colors.black.withOpacity(.2),
                  ),
                ],
              ),
            ),
            Underline(
              color: Colors.black.withOpacity(.08),
            ),
          ],
        ),
      ),
    );
  }
}
