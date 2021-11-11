import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/caption/caption.dart';
import 'package:superconnector_vm/core/providers/camera_provider.dart';
import 'package:superconnector_vm/core/services/caption/caption_service.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';
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
      child: StreamProvider<List<Caption>>.value(
        value: CaptionService().getCaptions(),
        initialData: [],
        child: Consumer<List<Caption>>(
          builder: (context, captions, child) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: captions.length,
                    itemBuilder: (context, index) {
                      return TrendingTile(
                        caption: captions[index],
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class TrendingTile extends StatefulWidget {
  const TrendingTile({
    Key? key,
    required this.caption,
  }) : super(key: key);

  final Caption caption;

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

    final cameraProvider = Provider.of<CameraProvider>(
      context,
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          _isPressed = true;
        });

        cameraProvider.caption = widget.caption.value;

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
                        (widget.caption.order + 1).toString(),
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
                      widget.caption.value,
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
