import 'package:flutter/material.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';

class ConnectionNames extends StatefulWidget {
  const ConnectionNames({
    Key? key,
    required this.names,
    required this.phoneNumberNameMap,
    this.unwatchedCount = 0,
  }) : super(key: key);

  final List<String> names;
  final Map<String, String> phoneNumberNameMap;
  final int unwatchedCount;

  @override
  _ConnectionNamesState createState() => _ConnectionNamesState();
}

class _ConnectionNamesState extends State<ConnectionNames> {
  @override
  Widget build(BuildContext context) {
    String namesText = '';
    widget.names.forEach((name) {
      if (namesText.isNotEmpty) {
        namesText += ', ';
      }
      namesText += (name);
    });

    widget.phoneNumberNameMap.values.forEach((name) {
      if (namesText.isNotEmpty) {
        namesText += ', ';
      }
      namesText += (name);
    });

    return Text(
      namesText +
          (widget.unwatchedCount > 0
              ? ' (' + widget.unwatchedCount.toString() + ')'
              : ''),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      softWrap: false,
      style: TextStyle(
        fontSize: 17.0,
        fontWeight: FontWeight.w600,
        color:
            widget.unwatchedCount > 0 ? ConstantColors.PRIMARY : Colors.black,
      ),
    );
  }
}
