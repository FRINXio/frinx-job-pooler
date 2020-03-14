import 'package:flutter/material.dart';

import '../../model/job_entry.dart';
import '../../model/job_state.dart';
import '../../utils/requests_broker.dart';
import '../../widget_settings.dart';
import 'common/job_button.dart';
import 'job_list_template.dart';

class JobPoolTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scrollbar(child: _JobList()),
    );
  }
}

class _JobList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _JobListState();
  }
}

class _JobListState extends JobListTemplate {
  @override
  Future<List<JobEntry>> getFilteredJobs(Future<List<JobEntry>> jobs) {
    return jobs.then((list) => list
        .where((entry) => entry.jobState == JobState.wait_for_acceptance)
        .toList());
  }

  @override
  List<Widget> getJobEntryRows(BuildContext context, JobEntry jobEntry) {
    var rows = super.getJobEntryRows(context, jobEntry);
    rows.add(
      JobButton(WidgetSettings.of(context).titleOfAcceptJobButton,
          () => _handleButtonPressed(context, jobEntry)),
    );
    return rows;
  }

  void _handleButtonPressed(BuildContext context, JobEntry jobEntry) {
    RequestsBroker().postAcceptingJob(jobEntry.jobId);
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text('Job \'${jobEntry.jobTitle}\' has been accepted'),
      ),
    );
    removeJobFromCache(jobEntry);
  }
}
