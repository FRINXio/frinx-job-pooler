import 'package:flutter/material.dart';
import 'package:frinx_job_pooler/design/tabs/common/job_button.dart';
import 'package:frinx_job_pooler/design/tabs/templates/job_entry_template.dart';
import 'package:frinx_job_pooler/model/job_description.dart';
import 'package:frinx_job_pooler/model/job_state.dart';

import 'templates/job_state_template.dart';

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

class _JobListState extends JobStateTemplate {
  @override
  Future<List<JobDescription>> getFilteredJobs(
      Future<List<JobDescription>> jobs) {
    return jobs.then((list) =>
        list.where((entry) => entry.jobState == JobState.waiting).toList());
  }

  @override
  JobEntryTemplate getJobEntry(
      JobDescription jobDescription, Function jobRemovalFunction) {
    return _JobEntry(jobDescription, jobRemovalFunction);
  }
}

class _JobEntry extends JobEntryTemplate {
  static const String BUTTON_TITLE = 'Accept job';

  const _JobEntry(JobDescription jobDescription, Function jobRemovalCallback)
      : super(jobDescription, jobRemovalCallback);

  @override
  List<Widget> getStatelessRows(BuildContext context) {
    var rows = super.getStatelessRows(context);
    rows.add(
      JobButton(BUTTON_TITLE, () => _handleButtonPressed(context)),
    );
    return rows;
  }

  void _handleButtonPressed(BuildContext context) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text('Job \'${jobDescription.jobTitle}\' has been accepted'),
      ),
    );
    Function.apply(jobRemovalCallback, [jobDescription.jobId]);
  }
}
