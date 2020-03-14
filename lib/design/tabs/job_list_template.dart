import 'package:flutter/material.dart';

import '../../cache/jobs_cache.dart';
import '../../model/job_entry.dart';
import '../../widget_settings.dart';
import 'common/job_description_widget.dart';
import 'common/job_location_widget.dart';
import 'common/job_title_widget.dart';
import 'common/job_workflow_output_widget.dart';

abstract class JobListTemplate extends State {
  static const CONNECTION_LOST_MSG = 'Cannot connect to conductor';

  final _jobsCache = JobsCache();
  Future<List<JobEntry>> _futureJobData;

  @override
  void initState() {
    super.initState();
    _futureJobData = getFilteredJobs(_jobsCache.getCachedJobData());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<JobEntry>>(
      future: _futureJobData,
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
      AsyncSnapshot<List<JobEntry>> snapshot) {
    var jobData = snapshot.data;
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
    });
  }

  Future<List<JobEntry>> getFilteredJobs(Future<List<JobEntry>> jobs);
}
