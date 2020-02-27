import 'package:flutter/material.dart';
import 'package:frinx_job_pooler/model/job_description.dart';
import 'package:frinx_job_pooler/utils/global_app_constants.dart';

class JobDescriptionWidget extends StatelessWidget {
  final JobDescription jobDescription;

  const JobDescriptionWidget(this.jobDescription);

  @override
  Widget build(BuildContext context) {
    var constants = GlobalAppConstants.of(context);
    return Container(
      child: Row(
        children: <Widget>[
          Icon(
            Icons.description,
            size: constants.sizeJobPoolIcon,
            color: Colors.blueGrey[500],
          ),
          SizedBox(width: constants.intendIconFromText),
          Expanded(
            child: Text(
              jobDescription.description,
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
