import 'package:flutter/material.dart';
import 'package:frinx_job_pooler/cache/jobs_cache.dart';
import 'package:frinx_job_pooler/design/tabs/templates/job_entry_template.dart';
import 'package:frinx_job_pooler/model/job_description.dart';

abstract class JobListStateTemplate extends State {
  final _jobsCache = JobsCache();
  Future<List<JobDescription>> _futureJobData;

  @override
  void initState() {
    super.initState();
    _futureJobData = getFilteredJobs(_jobsCache.getCachedJobData());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<JobDescription>>(
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Scaffold.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot connect to conductor'),
          backgroundColor: Colors.deepOrange,
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
                color: Colors.grey,
                size: constraints.biggest.width / 2.0,
              );
            },
          ),
        ),
      ),
    );
  }

  RefreshIndicator _handleFinishedLoading(
      AsyncSnapshot<List<JobDescription>> snapshot) {
    var jobData = snapshot.data;
    return RefreshIndicator(
      onRefresh: _refreshList,
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            getJobEntry(jobData[index], this._removeJobWithId),
        itemCount: jobData.length,
      ),
    );
  }

  void _removeJobWithId(String jobId) {
    setState(() {
      _futureJobData = _jobsCache.removeJobEntryFromCache(jobId);
    });
  }

  Future<Null> _refreshList() async {
    setState(() {
      _futureJobData = getFilteredJobs(_jobsCache.refreshJobData());
    });
  }

  Future<List<JobDescription>> getFilteredJobs(
      Future<List<JobDescription>> jobs);

  JobEntryTemplate getJobEntry(
      JobDescription jobDescription, Function jobRemovalFunction);
}
