import 'package:flutter/material.dart';

import '../../../model/job_entry.dart';
import '../../../utils/map_utils.dart';
import '../../../widget_settings.dart';

class JobLocationWidget extends StatelessWidget {
  final JobEntry jobEntry;

  const JobLocationWidget(this.jobEntry);

  @override
  Widget build(BuildContext context) {
    var constants = WidgetSettings.of(context);
    return Container(
      child: Row(
        children: <Widget>[
          _getGpsIconWidget(constants, jobEntry.jobCoordinates),
          SizedBox(width: constants.intendIconFromText),
          Expanded(
            child: Text(
              jobEntry.location,
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

  Widget _getGpsIconWidget(
      WidgetSettings constants, JobCoordinates jobCoordinates) {
    Widget iconWidget = Icon(
      Icons.gps_fixed,
      size: constants.sizeJobPoolIcon,
      color: constants.colorOfIcon,
    );
    if (jobCoordinates != null) {
      iconWidget = GestureDetector(
        child: iconWidget,
        onTap: () {
          MapUtils.openMap(jobCoordinates.latitude, jobCoordinates.longitude);
        },
      );
    }
    return iconWidget;
  }
}
