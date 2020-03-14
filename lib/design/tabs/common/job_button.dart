import 'package:flutter/material.dart';

import '../../../widget_settings.dart';

class JobButton extends StatelessWidget {
  final String buttonTitle;
  final VoidCallback onPressedAction;

  const JobButton(this.buttonTitle, this.onPressedAction);

  @override
  Widget build(BuildContext context) {
    var constants = WidgetSettings.of(context);
    return Padding(
      padding: constants.paddingOfJobEntry,
      child: SizedBox(
        width: double.infinity,
        child: RaisedButton(
          onPressed: onPressedAction,
          child: Text(
            buttonTitle,
            style: TextStyle(color: constants.colorOfButtonText),
          ),
          color: constants.colorOfComponent,
        ),
      ),
    );
  }
}
