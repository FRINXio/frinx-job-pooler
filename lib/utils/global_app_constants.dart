import 'package:flutter/widgets.dart';

class GlobalAppConstants extends InheritedWidget {
  final appTitle = 'FRINX Job Pool Machine';
  final tabJobPoolName = "Job pool";
  final tabMyJobsName = "My jobs";

  static GlobalAppConstants of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<GlobalAppConstants>();
  }

  const GlobalAppConstants({Widget child, Key key})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(GlobalAppConstants oldWidget) => false;
}
