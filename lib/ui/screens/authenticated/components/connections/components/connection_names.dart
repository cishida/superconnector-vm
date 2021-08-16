import 'package:flutter/material.dart';

class ConnectionNames extends StatefulWidget {
  const ConnectionNames({
    Key? key,
    required this.names,
    required this.phoneNumberNameMap,
  }) : super(key: key);

  final List<String> names;
  final Map<String, String> phoneNumberNameMap;

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
      namesText,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      softWrap: false,
      style: TextStyle(
        fontSize: 17.0,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
