import 'package:flutter/material.dart';

class BarButton extends StatelessWidget {
  const BarButton({
    Key? key,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  final String title;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(
        title,
        style: Theme.of(context).textTheme.button,
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            8.0,
          ),
        ),
      ),
      onPressed: () => onPressed(),
    );
  }
}
