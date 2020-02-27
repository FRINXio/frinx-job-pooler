import 'package:flutter/widgets.dart';

class GlobalAppConstants extends InheritedWidget {
  final appTitle = 'FRINX Job Pool Machine';
  final tabJobPoolName = "Job pool";
  final tabMyJobsName = "My jobs";

  final intendJobTitleFromId = 10.0;
  final intendIconFromText = 10.0;
  final maxLinesOfJobTitle = 2;
  final sizeJobPoolIcon = 60.0;

  final paddingOfJobEntry =
      const EdgeInsets.only(left: 10, right: 20, bottom: 10, top: 10);
  final paddingOfJobButton =
      const EdgeInsets.only(left: 20, right: 20, bottom: 10);

  static GlobalAppConstants of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<GlobalAppConstants>();
  }

  const GlobalAppConstants({Widget child, Key key})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(GlobalAppConstants oldWidget) => false;
}
