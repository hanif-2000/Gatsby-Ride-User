import 'package:GetsbyRideshare/core/static/enums.dart';
import 'package:GetsbyRideshare/core/utility/helper.dart';
import 'package:flutter/material.dart';
import 'package:GetsbyRideshare/core/utility/extension.dart';

import 'components/dialog_button.dart';
import 'components/dialog_container.dart';

class CustomCancelDialog extends StatelessWidget {
  final Function positiveAction;
  const CustomCancelDialog({Key? key, required this.positiveAction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DialogContainer(
      withPadding: true,
      withMargin: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
            child: Text(
              appLoc.wouldYouLikeToCancel,
              style: const TextStyle(fontSize: 15.0).useHiraginoKakuW3Font(),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          mediumVerticalSpacing(),
          ConfirmationButtons(
            positiveAction: positiveAction,
          ),
          smallVerticalSpacing()
        ],
      ),
    );
  }
}

class ConfirmationButtons extends StatelessWidget {
  final Function positiveAction;
  const ConfirmationButtons({
    Key? key,
    required this.positiveAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DialogButton.setPositiveButton(
                  action: () => positiveAction(),
                  style: dialogStyle.style1,
                  color: Colors.red)
              .button,
        ),
        Expanded(
          child: DialogButton.setNegativeButton(
                  action: () => Navigator.pop(context),
                  style: dialogStyle.style1,
                  color: Colors.black,
                  text: appLoc.no)
              .button,
        ),
      ],
    );
  }
}
