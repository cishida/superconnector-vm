import 'package:flutter/material.dart';

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
    return TextField(
      autofocus: shouldAutofocus,
      autocorrect: false,
      enabled: enabled,
      keyboardAppearance: Brightness.light,
      style: TextStyle(
        color: Colors.black.withOpacity(.6),
        fontWeight: FontWeight.normal,
        fontSize: 18.0,
        // backgroundColor: ConstantColors.SECONDARY,
      ),
      decoration: InputDecoration(
        isDense: true,
        hintText: "Search",
        hintStyle: TextStyle(
          color: Colors.black.withOpacity(.6),
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
        fillColor: Colors.black.withOpacity(.08),
        prefixIcon: Container(
          width: 18.0,
          margin: EdgeInsets.only(left: 12.0, right: 8.0),
          child: Padding(
            padding: const EdgeInsets.only(
              top: 7.0,
              right: 5.0,
              left: 5.0,
              bottom: 5.0,
            ),
            child: Image.asset(
              'assets/images/authenticated/search-icon-gray.png',
              color: Colors.black.withOpacity(.6),
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
    );
  }
}
