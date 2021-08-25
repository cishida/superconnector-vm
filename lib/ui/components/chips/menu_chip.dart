import 'package:flutter/material.dart';

class MenuChip extends StatelessWidget {
  const MenuChip({
    Key? key,
    required this.onPressed,
    required this.title,
  }) : super(key: key);

  final Function onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
        child: InputChip(
          avatar: null,
          elevation: 0.0,
          labelPadding: const EdgeInsets.fromLTRB(18.0, 2.0, 18.0, 2.0),
          backgroundColor: Colors.transparent,
          onPressed: () => onPressed(),
          side: BorderSide(
            width: 1.0,
            color: Colors.white,
          ),
          label: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.0,
              fontWeight: FontWeight.w400,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}
