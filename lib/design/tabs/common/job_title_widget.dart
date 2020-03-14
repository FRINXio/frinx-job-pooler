import 'package:flutter/material.dart';

import '../../../model/job_entry.dart';
import '../../../widget_settings.dart';

class JobTitleWidget extends StatelessWidget {
  final JobEntry jobEntry;

  const JobTitleWidget(this.jobEntry);

  @override
  Widget build(BuildContext context) {
    var constants = WidgetSettings.of(context);
    return Row(
      children: <Widget>[
        CircleAvatar(
          backgroundColor: constants.colorOfComponent,
          child: Text(
            jobEntry.jobTitle.substring(0, 1),
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          width: constants.intendJobTitleFromId,
        ),
        Expanded(
          child: Text(jobEntry.jobTitle.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.fade,
              maxLines: constants.maxLinesOfJobTitle,
              softWrap: true),
        ),
      ],
    );
  }
}
