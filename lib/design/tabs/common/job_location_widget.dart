import 'package:flutter/material.dart';
import 'package:frinx_job_pooler/model/job_description.dart';
import 'package:frinx_job_pooler/utils/global_app_constants.dart';
import 'package:frinx_job_pooler/utils/map_utils.dart';

class JobLocationWidget extends StatelessWidget {
  final JobDescription jobDescription;

  const JobLocationWidget(this.jobDescription);

  @override
  Widget build(BuildContext context) {
    var constants = GlobalAppConstants.of(context);
    return Container(
      child: Row(
        children: <Widget>[
          _getGpsIconWidget(constants, jobDescription.jobCoordinates),
          SizedBox(width: constants.intendIconFromText),
          Expanded(
            child: Text(
              jobDescription.location,
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
      GlobalAppConstants constants, JobCoordinates jobCoordinates) {
    Widget iconWidget = Icon(
      Icons.gps_fixed,
      size: constants.sizeJobPoolIcon,
      color: Colors.blueGrey[500],
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
