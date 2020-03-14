import 'package:flutter/material.dart';

import 'design/app_home.dart';
import 'widget_settings.dart';

void main() {
  runApp(
    WidgetSettings(
      child: MaterialApp(
        home: AppHome(),
      ),
    ),
  );
}
