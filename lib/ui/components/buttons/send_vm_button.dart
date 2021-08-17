import 'package:flutter/material.dart';
import 'package:superconnector_vm/core/utils/nav/super_navigator.dart';

class SendVMButton extends StatelessWidget {
  const SendVMButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(
        Icons.add,
      ),
      onPressed: () => SuperNavigator.handleRecordNavigation(context),
    );
  }
}
