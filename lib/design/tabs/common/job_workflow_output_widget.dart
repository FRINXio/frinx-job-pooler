import 'package:flutter/material.dart';

import '../../../model/job_entry.dart';
import '../../../widget_settings.dart';

class JobWorkflowOutputWidget extends StatelessWidget {
  final JobEntry jobEntry;

  const JobWorkflowOutputWidget(this.jobEntry);

  @override
  Widget build(BuildContext context) {
    var constants = WidgetSettings.of(context);
    return Container(
      child: Row(
        children: <Widget>[
          Icon(
            Icons.work,
            size: constants.sizeJobPoolIcon,
            color: constants.colorOfIcon,
          ),
          SizedBox(width: constants.intendIconFromText),
          Expanded(
            child: Text(
              jobEntry.workflowOutput,
              softWrap: true,
              overflow: TextOverflow.fade,
            ),
          ),
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
      padding: constants.paddingOfJobEntry,
    );
  }
}
