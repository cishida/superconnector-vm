import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/connection_search_term.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';
import 'package:superconnector_vm/core/utils/nav/authenticated_controller.dart';
import 'package:superconnector_vm/core/utils/nav/super_navigator.dart';
import 'package:superconnector_vm/ui/screens/home/components/connection_search_bar.dart';

class HomeTitleBar extends StatefulWidget {
  const HomeTitleBar({
    Key? key,
    required this.superuser,
  }) : super(key: key);

  final Superuser superuser;

  @override
  _HomeTitleBarState createState() => _HomeTitleBarState();
}

class _HomeTitleBarState extends State<HomeTitleBar>
    with SingleTickerProviderStateMixin {
  // bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();
  FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    ConnectionSearchTerm connectionSearchTerm =
        Provider.of<ConnectionSearchTerm>(context);
    AuthenticatedController authenticatedController =
        Provider.of<AuthenticatedController>(context);

    if (authenticatedController.isSearching) {
      _focusNode.requestFocus();
    }

    return Column(
      children: [
        Container(
          height: 55.0,
          width: width,
          child: Stack(
            children: [
              // AnimatedPositioned(
              //   duration: const Duration(milliseconds: 150),
              //   left: authenticatedController.isSearching ? -300 : 0.0,
              //   bottom: 20.0,
              //   child: Padding(
              //     padding: const EdgeInsets.only(
              //       left: 18.0,
              //     ),
              //     child: Image.asset(
              //       'assets/images/authenticated/superconnector-title.png',
              //       width: width * .527,
              //     ),
              //   ),
              // ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 150),
                left: authenticatedController.isSearching ? -400 : 0.0,
                bottom: 7.0,
                child: Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: Text(
                    'Camera Rolls',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 40.0,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -.5,
                    ),
                  ),
                ),
              ),
              if (!authenticatedController.isSearching)
                Positioned(
                  right: 70,
                  bottom: 12.0,
                  child: AnimatedOpacity(
                    duration: Duration(
                        milliseconds:
                            authenticatedController.isSearching ? 0 : 600),
                    opacity: authenticatedController.isSearching ? 0 : 1,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        SuperNavigator.handleContactsNavigation(
                          context: context,
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/images/authenticated/add-connection-button.png',
                          width: 20.0,
                        ),
                      ),
                    ),
                  ),
                ),
              if (!authenticatedController.isSearching)
                Positioned(
                  right: 20,
                  bottom: 8.0,
                  child: AnimatedOpacity(
                    duration: Duration(
                        milliseconds:
                            authenticatedController.isSearching ? 0 : 600),
                    opacity: authenticatedController.isSearching ? 0 : 1,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        if (mounted) {
                          authenticatedController.setIsSearching(true);
                        }
                        _focusNode.requestFocus();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/images/authenticated/search-icon.png',
                          width: 26.0,
                        ),
                      ),
                    ),
                  ),
                ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 150),
                right: 0.0,
                left: authenticatedController.isSearching
                    ? 0
                    : MediaQuery.of(context).size.width,
                bottom: 8.0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18.0,
                  ),
                  child: Stack(
                    children: [
                      Container(
                        height: 44.0,
                        child: ConnectionSearchBar(
                          searchController: _searchController,
                          focusNode: _focusNode,
                          close: () {
                            authenticatedController.setIsSearching(false);
                            // setState(() {
                            //   authenticatedController.isSearching = false;
                            // });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              if (authenticatedController.isSearching)
                Positioned(
                  right: 20.0,
                  top: 8.0,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 150),
                    opacity: authenticatedController.isSearching ? 1 : 0,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        _searchController.clear();
                        connectionSearchTerm.set('');
                        FocusScope.of(context).unfocus();
                        authenticatedController.setIsSearching(false);
                        // setState(() {
                        //   authenticatedController.isSearching = false;
                        // });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 20.0,
                          child: Image.asset(
                            'assets/images/authenticated/x-button.png',
                            height: 18,
                            width: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              // Positioned(
              //   right: 0.0,
              //   bottom: 9.0,
              //   child: Container(
              //     child: GestureDetector(
              //       behavior: HitTestBehavior.opaque,
              //       onTap: () {
              //         // SuperNavigator.push(
              //         //   context: context,
              //         //   widget: Account(),
              //         //   fullScreen: false,
              //         // );
              //         Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //             builder: (context) => Account(),
              //           ),
              //         );
              //       },
              //       child: Padding(
              //         padding: const EdgeInsets.only(
              //           right: 12.0,
              //           left: 11.0,
              //         ),
              //         child: SuperuserImage(
              //           url: widget.superuser.photoUrl,
              //           radius: 21.0,
              //           bordered: false,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
        Container(
          height: 1.0,
          color: ConstantColors.ED_GRAY,
        ),
      ],
    );
  }
}
