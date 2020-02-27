import 'package:flutter/material.dart';

class JobButton extends StatelessWidget {
  final String buttonTitle;
  final VoidCallback onPressedAction;

  const JobButton(this.buttonTitle, this.onPressedAction);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SizedBox(
      width: double.infinity,
      child: RaisedButton(
        onPressed: onPressedAction,
        child: Text(
          buttonTitle,
          style: TextStyle(color: Colors.white),
        ),
        color: Colors.blueGrey[900],
      ),
    );
  }
}