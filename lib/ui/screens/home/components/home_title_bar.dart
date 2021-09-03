import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/connection_search_string.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';
import 'package:superconnector_vm/core/utils/nav/super_navigator.dart';
import 'package:superconnector_vm/ui/components/images/superuser_image.dart';
import 'package:superconnector_vm/ui/screens/authenticated/account/account.dart';

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
  late AnimationController controller;
  late SequenceAnimation sequenceAnimation;
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();
  FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    ConnectionSearchString connectionSearchString =
        Provider.of<ConnectionSearchString>(context);

    return Column(
      children: [
        // AnimatedBuilder(
        //   animation: controller,
        //   builder: (context, child) => Opacity(
        //     opacity: sequenceAnimation['fade-in'].value,
        //     child: Container(
        //       color: Colors.blue,
        //       padding: const EdgeInsets.only(left: 18.0),
        //       transform: Matrix4.translationValues(
        //         sequenceAnimation["margin-slide"].value,
        //         0.0,
        //         0.0,
        //       ),
        //       child: Text(
        //         'Family',
        //         style: TextStyle(
        //           color: Colors.black,
        //           fontSize: 40.0,
        //           fontWeight: FontWeight.w700,
        //           letterSpacing: -.5,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        Container(
          height: 55.0,
          width: width,
          child: Stack(
            children: [
              // AnimatedPositioned(
              //   width: _isSearching ? 200.0 : 50.0,
              //   height: _isSearching ? 50.0 : 200.0,
              //   top: _isSearching ? 50.0 : 150.0,
              //   duration: const Duration(seconds: 2),
              //   curve: Curves.fastOutSlowIn,
              //   child: GestureDetector(
              //     onTap: () {
              //       setState(() {
              //         _isSearching = !_isSearching;
              //       });
              //     },
              //     child: Container(
              //       color: Colors.blue,
              //       child: const Center(child: Text('Tap me')),
              //     ),
              //   ),
              // ),
              // if (!_isSearching)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 350),
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
                  duration: Duration(milliseconds: _isSearching ? 0 : 800),
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
                duration: const Duration(milliseconds: 350),
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
                    duration: const Duration(milliseconds: 350),
                    opacity: _isSearching ? 1 : 0,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        _searchController.clear();
                        connectionSearchString.set('');
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
                      SuperNavigator.push(
                        context: context,
                        widget: Account(),
                        fullScreen: false,
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

class ConnectionSearchBar extends StatelessWidget {
  const ConnectionSearchBar({
    Key? key,
    required this.searchController,
    required this.focusNode,
    required this.close,
  }) : super(key: key);

  final TextEditingController searchController;
  final FocusNode focusNode;
  final Function close;

  @override
  Widget build(BuildContext context) {
    ConnectionSearchString connectionSearchString =
        Provider.of<ConnectionSearchString>(context);

    OutlineInputBorder border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.transparent,
        width: 1.0,
      ),
      borderRadius: BorderRadius.circular(40.0),
    );

    return TextField(
      focusNode: focusNode,
      autofocus: false,
      autocorrect: false,
      enabled: true,
      keyboardAppearance: Brightness.dark,
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w600,
        fontSize: 20.0,
        // backgroundColor: ConstantColors.SECONDARY,
      ),
      cursorColor: ConstantColors.PRIMARY,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.fromLTRB(
          21.0,
          9.0,
          5.0,
          9.0,
        ),
        disabledBorder: border,
        enabledBorder: border,
        border: border,
        focusedBorder: border,
        filled: true,
        fillColor: Colors.black.withOpacity(.04),
        // suffixIcon: GestureDetector(
        //   behavior: HitTestBehavior.opaque,
        //   onTap: () {
        //     searchController.clear();
        //     connectionSearchString.set('');
        //     FocusScope.of(context).unfocus();
        //     close();
        //   },
        //   child: Container(
        //     width: 18.0,
        //     margin: EdgeInsets.only(left: 12.0, right: 8.0),
        //     child: Padding(
        //       padding: const EdgeInsets.only(
        //         top: 7.0,
        //         right: 5.0,
        //         left: 5.0,
        //         bottom: 5.0,
        //       ),
        //       child: Image.asset(
        //         'assets/images/authenticated/x-button.png',
        //         height: 18,
        //         width: 18,
        //       ),
        //     ),
        //   ),
        // ),
      ),
      controller: searchController,
      onEditingComplete: () {
        FocusScope.of(context).unfocus();
      },
      onChanged: (text) {
        connectionSearchString.set(text);
        print(connectionSearchString.string);
      },
    );
  }
}
