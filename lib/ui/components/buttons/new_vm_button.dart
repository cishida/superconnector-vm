import 'package:flutter/material.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';
import 'package:superconnector_vm/core/utils/nav/super_navigator.dart';

class NewVMButton extends StatelessWidget {
  const NewVMButton({
    Key? key,
    this.isInverted = false,
  }) : super(key: key);

  final bool isInverted;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: isInverted ? Colors.white : ConstantColors.PRIMARY,
      child: Icon(
        Icons.add,
        color: isInverted ? ConstantColors.PRIMARY : Colors.white,
      ),
      onPressed: () => SuperNavigator.handleRecordNavigation(context),
    );
  }
}
