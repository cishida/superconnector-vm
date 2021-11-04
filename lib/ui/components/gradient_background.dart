import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:superconnector_vm/ui/components/bottom_sheet_tab.dart';
import 'package:superconnector_vm/ui/components/underline.dart';

class GradientBackground extends StatelessWidget {
  const GradientBackground({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.child,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          width: size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(
                      'assets/images/authenticated/dark-blue-orange-gradient.png',
                    ),
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: Column(
                  children: [
                    Center(
                      child: BottomSheetTab(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        bottom: 19.0,
                      ),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              title,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5!
                                  .copyWith(
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
                                subtitle,
                                style: Theme.of(context).textTheme.bodyText1!,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Underline(
                      color: Colors.white.withOpacity(.2),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 7.0,
              ),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
