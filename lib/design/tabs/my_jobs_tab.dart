import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../model/job_entry.dart';
import '../../model/job_state.dart';
import '../../utils/requests_broker.dart';
import '../../widget_settings.dart';
import 'common/job_button.dart';
import 'job_list_template.dart';

class MyJobsTab extends StatelessWidget {
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
  Future<Map<JobEntry, JobState>> getFilteredJobs(
      Future<Map<JobEntry, JobState>> jobs) {
    return jobs.then((originalMap) => Map.from(originalMap)
        ..removeWhere((_, jobState) =>
            jobState == JobState.wait_for_installation_complete));
  }

  @override
  List<Widget> getJobEntryRows(BuildContext context, JobEntry jobEntry) {
    var rows = super.getJobEntryRows(context, jobEntry);
    rows.add(
      JobButton(WidgetSettings.of(context).titleOfInstallCompleteButton,
          () => _handleButtonPressed(context, jobEntry)),
    );
    return rows;
  }

  void _handleButtonPressed(BuildContext context, JobEntry jobEntry) {
    RequestsBroker().postFinishingJob(jobEntry.jobId);
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text('Job \'${jobEntry.jobTitle}\' has been completed'),
      ),
    );
    removeJobFromCache(jobEntry);
  }
}
