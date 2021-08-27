import 'package:flutter/material.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';

class SuperDialog extends StatefulWidget {
  const SuperDialog({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.primaryActionTitle,
    required this.primaryAction,
    this.secondaryActionTitle,
    this.secondaryAction,
    this.shouldAnimate = true,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final String primaryActionTitle;
  final Function primaryAction;
  final String? secondaryActionTitle;
  final Function? secondaryAction;
  final bool shouldAnimate;

  @override
  _SuperDialogState createState() => _SuperDialogState();
}

class _SuperDialogState extends State<SuperDialog>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: Duration(milliseconds: widget.shouldAnimate ? 200 : 0),
        vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);

    // animation.addStatusListener((status) {
    // if (status == AnimationStatus.completed) {
    //   controller.reverse();
    // } else if (status == AnimationStatus.dismissed) {
    //   controller.forward();
    // }
    // });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return FadeTransition(
      opacity: animation,
      child: Dialog(
        insetPadding: const EdgeInsets.all(12.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 3,
        child: Container(
          width: size.width,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 35.0,
              right: 30.0,
              top: 32.0,
              bottom: 24.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(
                  height: 8.0,
                ),
                Text(
                  widget.subtitle,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                SizedBox(
                  height: 17.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (widget.secondaryAction != null)
                      GestureDetector(
                        onTap: () {
                          widget.secondaryAction!();
                        },
                        child: Text(
                          widget.secondaryActionTitle!,
                          style: TextStyle(
                            color: ConstantColors.PRIMARY,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    SizedBox(width: 40.0),
                    GestureDetector(
                      onTap: () {
                        widget.primaryAction();
                      },
                      child: Row(
                        children: [
                          Text(
                            widget.primaryActionTitle,
                            style: TextStyle(
                              color: ConstantColors.PRIMARY,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 3.0, left: 6.0),
                            child: Image.asset(
                              'assets/images/authenticated/onboarding/right-arrow-icon.png',
                              width: 18.0,
                              height: 13.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
