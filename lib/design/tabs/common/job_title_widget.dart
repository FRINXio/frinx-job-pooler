import 'package:flutter/material.dart';
import 'package:frinx_job_pooler/model/job_entry.dart';
import 'package:frinx_job_pooler/utils/global_app_constants.dart';

class JobTitleWidget extends StatelessWidget {
  final JobEntry jobEntry;

  const JobTitleWidget(this.jobEntry);

  @override
  Widget build(BuildContext context) {
    var constants = GlobalAppConstants.of(context);
    return Row(
      children: <Widget>[
        CircleAvatar(
          backgroundColor: Colors.blueGrey[900],
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
