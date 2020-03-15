import 'package:flutter/material.dart';

import '../../cache/jobs_cache.dart';
import '../../model/job_entry.dart';
import '../../model/job_state.dart';
import '../../widget_settings.dart';
import 'common/job_description_widget.dart';
import 'common/job_location_widget.dart';
import 'common/job_title_widget.dart';
import 'common/job_workflow_output_widget.dart';

abstract class JobListTemplate extends State {
  static const CONNECTION_LOST_MSG = 'Cannot connect to conductor';
  static const UNABLE_TO_SEND_REQUEST = 'Failed to send request to conductor.';

  final _jobsCache = JobsCache();
  final Map<JobEntry, bool> lockedButtons = {};

  Future<Map<JobEntry, JobState>> _futureJobData;

  @override
  void initState() {
    super.initState();
    _futureJobData = _jobsCache.getCachedJobData();
  }

  @override
  Widget build(BuildContext context) {
    lockedButtons.removeWhere((_, removed) => removed);
    return FutureBuilder<Map<JobEntry, JobState>>(
      future: getFilteredJobs(_futureJobData),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _handleLoadingError(context);
        } else if (snapshot.connectionState == ConnectionState.done) {
          return _handleFinishedLoading(snapshot);
        } else {
          return _handleLoadingInProgress();
        }
      },
    );
  }

  Align _handleLoadingInProgress() {
    return const Align(
        alignment: Alignment.center, child: const CircularProgressIndicator());
  }

  Align _handleLoadingError(BuildContext context) {
    var constants = WidgetSettings.of(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: const Text(CONNECTION_LOST_MSG),
          backgroundColor: constants.colorOfWarningSnackBar,
        ),
      );
    });
    return Align(
      alignment: Alignment.center,
      child: RefreshIndicator(
        onRefresh: _refreshList,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Icon(
                Icons.signal_wifi_off,
                color: constants.colorOfOverlayTabIcon,
                size: constraints.biggest.width / 2.0,
              );
            },
          ),
        ),
      ),
    );
  }

  RefreshIndicator _handleFinishedLoading(
      AsyncSnapshot<Map<JobEntry, JobState>> snapshot) {
    var jobData = List.of(snapshot.data.keys);
    return RefreshIndicator(
      onRefresh: _refreshList,
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            _getJobEntry(jobData[index]),
        itemCount: jobData.length,
      ),
    );
  }

  Future<Null> _refreshList() async {
    setState(() {
      _futureJobData = getFilteredJobs(_jobsCache.refreshJobData());
    });
  }

  Widget _getJobEntry(JobEntry jobEntry) {
    return ExpansionTile(
      key: PageStorageKey<JobEntry>(jobEntry),
      title: JobTitleWidget(jobEntry),
      children: <Widget>[
        Column(
          children: getJobEntryRows(context, jobEntry),
        )
      ],
    );
  }

  List<Widget> getJobEntryRows(BuildContext context, JobEntry jobEntry) {
    final List<Widget> rows = [];
    if (jobEntry.description != null) {
      rows.add(JobDescriptionWidget(jobEntry));
    }
    if (jobEntry.location != null) {
      rows.add(JobLocationWidget(jobEntry));
    }
    if (jobEntry.workflowOutput != null) {
      rows.add(JobWorkflowOutputWidget(jobEntry));
    }
    return rows;
  }

  void removeJobFromCache(JobEntry jobEntry) {
    setState(() {
      _futureJobData = _jobsCache.removeJobEntryFromCache(jobEntry.jobId);
      lockedButtons[jobEntry] = true;
    });
  }

  void moveJobToAcceptedState(JobEntry jobEntry) {
    setState(() {
      _futureJobData = _jobsCache.moveJobToAcceptedState(jobEntry.jobId);
      lockedButtons[jobEntry] = true;
    });
  }

  void handleFailedRequest(BuildContext context, JobEntry jobEntry) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: const Text(UNABLE_TO_SEND_REQUEST),
        backgroundColor: WidgetSettings.of(context).colorOfWarningSnackBar,
      ),
    );
    setState(() {
      lockedButtons.remove(jobEntry);
    });
  }

  Future<Map<JobEntry, JobState>> getFilteredJobs(
      Future<Map<JobEntry, JobState>> jobs);
}
