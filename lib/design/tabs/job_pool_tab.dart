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
      JobButton(
          WidgetSettings.of(context).titleOfAcceptJobButton,
          () async => lockedButtons.containsKey(jobEntry)
              ? null
              : _handleButtonPressed(context, jobEntry)),
    );
    return rows;
  }

  Future<void> _handleButtonPressed(
      BuildContext context, JobEntry jobEntry) async {
    setState(() {
      lockedButtons[jobEntry] = false;
    });

    var response;
    try {
      response = await RequestsBroker().postAcceptingJob(jobEntry.jobId);
    } catch (error) {
      handleFailedRequest(context, jobEntry);
      return;
    }

    if (response.statusCode >= 400 && response.statusCode < 600) {
      handleFailedRequest(context, jobEntry);
      return;
    }
    moveJobToAcceptedState(jobEntry);
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text('Job \'${jobEntry.jobTitle}\' has been accepted'),
      ),
    );
  }
}
