import 'package:flutter/material.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    Key? key,
    required TextEditingController controller,
    this.enabled = false,
    this.shouldAutofocus = false,
  })  : _controller = controller,
        super(key: key);

  final TextEditingController _controller;
  final bool enabled;
  final bool shouldAutofocus;

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.transparent,
        width: 1.0,
      ),
      borderRadius: BorderRadius.circular(10.0),
    );
    return Container(
      // color: Colors.white,
      padding: const EdgeInsets.fromLTRB(
        18.0,
        0.0,
        18.0,
        0.0,
      ),
      child: TextFormField(
        autofocus: shouldAutofocus,
        autocorrect: false,
        enabled: enabled,
        keyboardAppearance: Brightness.dark,
        style: TextStyle(
          color: ConstantColors.SEARCH_BAR_TEXT,
          fontWeight: FontWeight.normal,
          fontSize: 18.0,
          // backgroundColor: ConstantColors.SECONDARY,
        ),
        decoration: InputDecoration(
          isDense: true,
          hintText: "Search",
          hintStyle: TextStyle(
            color: ConstantColors.SEARCH_BAR_TEXT,
          ),
          contentPadding: EdgeInsets.fromLTRB(
            0.0,
            0.0,
            0.0,
            0.0,
          ),
          disabledBorder: border,
          enabledBorder: border,
          border: border,
          focusedBorder: border,
          filled: true,
          fillColor: ConstantColors.SEARCH_BAR_BACKGROUND,
          prefixIcon: Container(
            width: 18.0,
            margin: EdgeInsets.only(left: 12.0, right: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Image.asset(
                'assets/images/authenticated/search-icon-gray.png',
                height: 18,
                width: 18,
              ),
            ),
          ),
        ),
        controller: _controller,
        onEditingComplete: () {
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }
}
