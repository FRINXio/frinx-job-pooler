import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WidgetSettings extends InheritedWidget {
  final titleOfAppBar = 'Job Pool Machine';
  final titleOfJobPoolTab = 'Job pool';
  final titleOfMyJobsTab = 'My jobs';
  final titleOfInstallCompleteButton = 'Report installation completed';
  final titleOfAcceptJobButton = 'Accept job';

  final colorOfBackground = Colors.blueGrey[100];
  final colorOfComponent = Colors.blueGrey[900];
  final colorOfWarningSnackBar = Colors.deepOrange;
  final colorOfIcon = Colors.blueGrey[500];
  final colorOfOverlayTabIcon = Colors.grey;
  final colorOfButtonText = Colors.white;

  final intendJobTitleFromId = 10.0;
  final intendIconFromText = 10.0;

  final maxLinesOfJobTitle = 2;
  final sizeJobPoolIcon = 60.0;

  final widthOfFrinxLogo = 100.0;

  final paddingOfJobEntry =
      const EdgeInsets.only(left: 10, right: 20, bottom: 10, top: 10);
  final paddingOfJobButton =
      const EdgeInsets.only(left: 20, right: 20, bottom: 10);

  static WidgetSettings of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<WidgetSettings>();
  }

  WidgetSettings({Widget child, Key key}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(WidgetSettings oldWidget) => false;
}
