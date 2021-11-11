import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/connection_search_term.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';

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
    ConnectionSearchTerm connectionSearchTerm =
        Provider.of<ConnectionSearchTerm>(context);

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
      textInputAction: TextInputAction.search,
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
      ),
      controller: searchController,
      onEditingComplete: () {
        // FocusScope.of(context).unfocus();
      },
      onChanged: (text) {
        connectionSearchTerm.set(text);
      },
    );
  }
}
