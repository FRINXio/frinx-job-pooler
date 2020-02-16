import 'package:flutter/material.dart';
import 'package:frinx_job_pooler/utils/global_app_constants.dart';
import 'package:frinx_job_pooler/design//app_home.dart';

void main() {
  runApp(
    GlobalAppConstants(
      child: MaterialApp(
        home: AppHome(),
      ),
    ),
  );
}
