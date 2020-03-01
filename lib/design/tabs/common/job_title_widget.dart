import 'package:flutter/material.dart';
import 'package:frinx_job_pooler/model/job_description.dart';
import 'package:frinx_job_pooler/utils/global_app_constants.dart';

class JobTitleWidget extends StatelessWidget {

  final JobDescription jobDescription;

  const JobTitleWidget(this.jobDescription);

  @override
  Widget build(BuildContext context) {
    var constants = GlobalAppConstants.of(context);
    return Row(
      children: <Widget>[
        CircleAvatar(
          backgroundColor: Colors.blueGrey[900],
          child: Text(
            jobDescription.jobTitle.substring(0, 1),
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          width: constants.intendJobTitleFromId,
        ),
        Expanded(
          child: Text(jobDescription.jobTitle.toUpperCase(),
              style: TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.fade,
              maxLines: constants.maxLinesOfJobTitle,
              softWrap: true),
        ),
      ],
    );
  }
}
