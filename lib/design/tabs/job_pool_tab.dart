import 'package:flutter/material.dart';
import 'package:frinx_job_pooler/design/tabs/common/job_button.dart';
import 'package:frinx_job_pooler/design/tabs/common/job_description_widget.dart';
import 'package:frinx_job_pooler/design/tabs/common/job_location_widget.dart';
import 'package:frinx_job_pooler/design/tabs/common/job_title_widget.dart';
import 'package:frinx_job_pooler/model/job_description.dart';

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

class _JobListState extends State<_JobList> {
  final List<JobDescription> jobData = <JobDescription>[
    JobDescription(1, 'Job 1',
        description: 'This is the first job',
        location: 'Mlynské nivy 4959/48,\n821 09 Bratislava,\Slovakia',
        jobCoordinates: JobCoordinates(-3.823216, -38.481700)),
    JobDescription(2, 'Job 2', description: 'This is the second job'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) =>
          _JobEntry(jobData[index], this._removeJobWithId),
      itemCount: jobData.length,
    );
  }

  void _removeJobWithId(int jobId) {
    setState(() {
      jobData.removeWhere((entry) => entry.jobId == jobId);
    });
  }
}

class _JobEntry extends StatelessWidget {
  static const String ID_FORMAT = '%02d';
  static const String BUTTON_TITLE = 'Accept job';

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
        content: Text('Job \'${jobDescription.jobTitle}\' has been accepted'),
      ),
    );
    Function.apply(jobRemovalCallback, [jobDescription.jobId]);
  }
}
