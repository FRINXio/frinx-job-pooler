import 'package:flutter/material.dart';
import 'package:frinx_job_pooler/cache/JobsCache.dart';
import 'package:frinx_job_pooler/design/tabs/templates/job_entry_template.dart';
import 'package:frinx_job_pooler/model/job_description.dart';

abstract class JobStateTemplate extends State {
  final jobsCache = JobsCache();

  Future<List<JobDescription>> _futureJobData;
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _futureJobData = getFilteredJobs(jobsCache.getCachedJobData());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<JobDescription>>(
      future: _futureJobData,
      builder: (context, snapshot) {
        var jobData = snapshot.data;
        if (snapshot.connectionState == ConnectionState.done) {
          return RefreshIndicator(
            key: refreshKey,
            onRefresh: _refreshList,
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) =>
                  getJobEntry(jobData[index], this._removeJobWithId),
              itemCount: jobData.length,
            ),
          );
        } else {
          return Align(
              alignment: Alignment.center,
              child: new CircularProgressIndicator());
        }
      },
    );
  }

  void _removeJobWithId(String jobId) {
    setState(() {
      _futureJobData = jobsCache.removeJobEntryFromCache(jobId);
    });
  }

  Future<Null> _refreshList() async {
    setState(() {
      _futureJobData = getFilteredJobs(jobsCache.refreshJobData());
    });
  }

  Future<List<JobDescription>> getFilteredJobs(
      Future<List<JobDescription>> jobs);

  JobEntryTemplate getJobEntry(
      JobDescription jobDescription, Function jobRemovalFunction);
}
