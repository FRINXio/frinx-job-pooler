import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frinx_job_pooler/design/tabs/common/job_workflowOutput_widget.dart';
import 'package:frinx_job_pooler/model/job_description.dart';
import 'package:frinx_job_pooler/design/tabs/common/job_title_widget.dart';
import 'package:frinx_job_pooler/design/tabs/common/job_description_widget.dart';
import 'package:frinx_job_pooler/design/tabs/common/job_location_widget.dart';
import 'package:frinx_job_pooler/design/tabs/common/job_button.dart';

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

class _JobListState extends State<_JobList> {
  List<JobDescription> jobData = <JobDescription>[];
  Future<List<JobDescription>> _futureJobData;
  bool firstStart = true;

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _futureJobData = getMyJobData();
    refreshList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<JobDescription>>(
      future: _futureJobData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return RefreshIndicator(
            key: refreshKey,
            onRefresh: refreshList,
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) =>
                  _JobEntry(jobData[index], this._removeJobWithId),
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

  void _removeJobWithId(int jobId) {
    setState(() {
      jobData.removeWhere((entry) => entry.jobId == jobId);
    });
  }

  Future<List<JobDescription>> getMyJobData() async {
    await Future.delayed(Duration(seconds: 2));
     return <JobDescription>[
        JobDescription.myJobs(1, 'Job 1',
            description: 'This is the first job',
            location: 'Mlynské nivy 4959/48,\n821 09 Bratislava,\Slovakia',
            jobCoordinates: JobCoordinates(-3.823216, -38.481700),
            workflowOutput: "Configuration completed successfully.\n"
                "Post installation checks completed successfully.\n"
                "Job duration: 1hr 23min\n"
                "Job is finished. Thank you!"),
        JobDescription.myJobs(2, 'Job 2',
            description: 'This is the second job',
            location: 'Mlynské nivy 4959/48,\n821 09 Bratislava,\Slovakia',
            jobCoordinates: JobCoordinates(-3.823216, -38.481700),
            workflowOutput: "Configuration completed successfully.\n"
                "Post installation checks completed successfully.\n"
                "Job duration: 1hr 23min\n"
                "Job is finished. Thank you!")
      ];
    }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));

      setState(() {
        jobData = <JobDescription>[
          JobDescription.myJobs(1, 'Job 1',
              description: 'This is the first job',
              location: 'Mlynské nivy 4959/48,\n821 09 Bratislava,\Slovakia',
              jobCoordinates: JobCoordinates(-3.823216, -38.481700),
              workflowOutput: "Configuration completed successfully.\n"
                  "Post installation checks completed successfully.\n"
                  "Job duration: 1hr 23min\n"
                  "Job is finished. Thank you!"),
          JobDescription.myJobs(2, 'Job 2',
              description: 'This is the second job',
              location: 'Mlynské nivy 4959/48,\n821 09 Bratislava,\Slovakia',
              jobCoordinates: JobCoordinates(-3.823216, -38.481700),
              workflowOutput: "Configuration completed successfully.\n"
                  "Post installation checks completed successfully.\n"
                  "Job duration: 1hr 23min\n"
                  "Job is finished. Thank you!")
        ];
      });
    }
}

class _JobEntry extends StatelessWidget {
  static const String BUTTON_TITLE = 'Report installation completed';

  final JobDescription jobDescription;
  final Function jobRemovalCallback;

  const _JobEntry(this.jobDescription, this.jobRemovalCallback);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      key: PageStorageKey<JobDescription>(jobDescription),
      title: new JobTitleWidget(jobDescription),
      children: <Widget>[_buildJobDescriptionWidget(context)],
    );
  }

  Widget _buildJobDescriptionWidget(BuildContext context) {
    final List<Widget> rows = [];
    if (jobDescription.description != null) {
      rows.add(JobDescriptionWidget(jobDescription));
    }
    if (jobDescription.location != null) {
      rows.add(JobLocationWidget(jobDescription));
    }
    if (jobDescription.workflowOutput != null) {
      rows.add(JobWorkflowOutputWidget(jobDescription));
    }
    rows.add(
      JobButton(BUTTON_TITLE, () => _handleButtonPressed(context)),
    );

    return Column(
      children: rows,
    );
  }

  void _handleButtonPressed(BuildContext context) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text('Job \'${jobDescription.jobTitle}\' has been completed'),
      ),
    );
    Function.apply(jobRemovalCallback, [jobDescription.jobId]);
  }

}