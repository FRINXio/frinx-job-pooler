import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frinx_job_pooler/design/tabs/common/job_button.dart';
import 'package:frinx_job_pooler/model/job_entry.dart';
import 'package:frinx_job_pooler/model/job_state.dart';
import 'package:frinx_job_pooler/rest/requests_broker.dart';

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
  static const String _BUTTON_TITLE = 'Report installation completed';

  @override
  Future<List<JobEntry>> getFilteredJobs(Future<List<JobEntry>> jobs) {
    return jobs.then((list) => list
        .where((entry) =>
            entry.jobState == JobState.wait_for_installation_complete)
        .toList());
  }

  @override
  List<Widget> getJobEntryRows(BuildContext context, JobEntry jobEntry) {
    var rows = super.getJobEntryRows(context, jobEntry);
    rows.add(
      JobButton(_BUTTON_TITLE, () => _handleButtonPressed(context, jobEntry)),
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
