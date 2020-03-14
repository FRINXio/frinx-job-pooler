import 'package:flutter/material.dart';

import '../../../model/job_entry.dart';
import '../../../widget_settings.dart';

class JobDescriptionWidget extends StatelessWidget {
  final JobEntry jobEntry;

  const JobDescriptionWidget(this.jobEntry);

  @override
  Widget build(BuildContext context) {
    var constants = WidgetSettings.of(context);
    return Container(
      child: Row(
        children: <Widget>[
          Icon(
            Icons.description,
            size: constants.sizeJobPoolIcon,
            color: constants.colorOfIcon,
          ),
          SizedBox(width: constants.intendIconFromText),
          Expanded(
            child: Text(
              jobEntry.description,
              softWrap: true,
              overflow: TextOverflow.fade,
              textAlign: TextAlign.justify,
            ),
          ),
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
      padding: constants.paddingOfJobEntry,
    );
  }
}
