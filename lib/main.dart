import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'design/app_home.dart';
import 'utils/shared_constants.dart';
import 'widget_settings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _provideDefaultSharedPreferences();
  runApp(
    WidgetSettings(
      child: MaterialApp(
        home: AppHome(),
      ),
    ),
  );
}

_provideDefaultSharedPreferences() async {
  var prefs = await SharedPreferences.getInstance();
  final List<Future<bool>> futuresOfSetDefaults = [];
  if (!prefs.containsKey(SharedConstants.PREFS_IP_ADDRESS)) {
    futuresOfSetDefaults.add(prefs.setString(
        SharedConstants.PREFS_IP_ADDRESS, SharedConstants.DEF_IP_ADDRESS));
  }
  if (!prefs.containsKey(SharedConstants.PREFS_PORT)) {
    futuresOfSetDefaults.add(
        prefs.setInt(SharedConstants.PREFS_PORT, SharedConstants.DEF_PORT));
  }
  if (!prefs.containsKey(SharedConstants.PREFS_HTTP_CLIENT_TIMEOUT)) {
    futuresOfSetDefaults.add(prefs.setInt(
        SharedConstants.PREFS_HTTP_CLIENT_TIMEOUT,
        SharedConstants.DEF_HTTP_CLIENT_TIMEOUT));
  }
  if (!prefs.containsKey(SharedConstants.PREFS_JOB_POOL_NAME)) {
    futuresOfSetDefaults.add(prefs.setString(
        SharedConstants.PREFS_JOB_POOL_NAME,
        SharedConstants.DEF_JOB_POOL_NAME));
  }
  await Future.wait(futuresOfSetDefaults);
}
