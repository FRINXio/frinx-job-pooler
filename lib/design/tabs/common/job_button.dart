import 'package:flutter/material.dart';
import 'package:frinx_job_pooler/utils/global_app_constants.dart';

class JobButton extends StatelessWidget {
  final String buttonTitle;
  final VoidCallback onPressedAction;

  const JobButton(this.buttonTitle, this.onPressedAction);

  @override
  Widget build(BuildContext context) {
    var constants = GlobalAppConstants.of(context);
    return Padding(
      padding: constants.paddingOfJobEntry,
      child: SizedBox(
        width: double.infinity,
        child: RaisedButton(
          onPressed: onPressedAction,
          child: Text(
            buttonTitle,
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.blueGrey[900],
        ),
      ),
    );
  }
}
