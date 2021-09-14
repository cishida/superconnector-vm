import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/connection_search_term.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';
import 'package:superconnector_vm/ui/components/images/superuser_image.dart';
import 'package:superconnector_vm/ui/screens/authenticated/account/account.dart';
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
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();
  FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    ConnectionSearchTerm connectionSearchTerm =
        Provider.of<ConnectionSearchTerm>(context);

    return Column(
      children: [
        Container(
          height: 55.0,
          width: width,
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 150),
                left: _isSearching ? -200 : 0.0,
                bottom: 7.0,
                child: Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: Text(
                    'Family',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 40.0,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -.5,
                    ),
                  ),
                ),
              ),
              // if (!_isSearching) Spacer(),
              Positioned(
                right: 22 + 42 + 12 - 8,
                bottom: 8.0,
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: _isSearching ? 0 : 600),
                  opacity: _isSearching ? 0 : 1,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      if (mounted) {
                        setState(() {
                          _isSearching = true;
                        });
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
                right: 60.0,
                left: _isSearching ? 0 : MediaQuery.of(context).size.width,
                bottom: 8.0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11.0,
                  ),
                  child: Stack(
                    children: [
                      Container(
                        height: 44.0,
                        child: ConnectionSearchBar(
                          searchController: _searchController,
                          focusNode: _focusNode,
                          close: () {
                            setState(() {
                              _isSearching = false;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              if (_isSearching)
                Positioned(
                  right: 74.0,
                  top: 8.0,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 150),
                    opacity: _isSearching ? 1 : 0,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        _searchController.clear();
                        connectionSearchTerm.set('');
                        FocusScope.of(context).unfocus();
                        setState(() {
                          _isSearching = false;
                        });
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

              Positioned(
                right: 0.0,
                bottom: 9.0,
                child: Container(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      // SuperNavigator.push(
                      //   context: context,
                      //   widget: Account(),
                      //   fullScreen: false,
                      // );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Account(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                        right: 12.0,
                        left: 11.0,
                      ),
                      child: SuperuserImage(
                        url: widget.superuser.photoUrl,
                        radius: 21.0,
                        bordered: false,
                      ),
                    ),
                  ),
                ),
              ),
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
