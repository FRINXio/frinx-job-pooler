import 'package:flutter/material.dart';
import 'package:frinx_job_pooler/model/job_entry.dart';
import 'package:frinx_job_pooler/utils/global_app_constants.dart';

class JobWorkflowOutputWidget extends StatelessWidget {
  final JobEntry jobEntry;

  const JobWorkflowOutputWidget(this.jobEntry);

  @override
  Widget build(BuildContext context) {
    var constants = GlobalAppConstants.of(context);
    return Container(
      child: Row(
        children: <Widget>[
          Icon(
            Icons.work,
            size: constants.sizeJobPoolIcon,
            color: Colors.blueGrey[500],
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
