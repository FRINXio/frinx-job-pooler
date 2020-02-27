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
          _JobItem(jobData[index]),
      itemCount: jobData.length,
    );
  }
}

class _JobItem extends StatelessWidget {
  static const String ID_FORMAT = '%02d';
  static const String BUTTON_TITLE = 'Accept job';
  final JobDescription entry;

  const _JobItem(this.entry);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      key: PageStorageKey<JobDescription>(entry),
      title: new JobTitleWidget(entry),
      children: <Widget>[_buildJobDescriptionWidget(context, entry)],
    );
  }

  Widget _buildJobDescriptionWidget(
      BuildContext context, JobDescription jobEntry) {
    final List<Widget> rows = [];
    if (entry.description != null) {
      rows.add(JobDescriptionWidget(jobEntry));
    }
    if (entry.location != null) {
      rows.add(JobLocationWidget(jobEntry));
    }
    rows.add(
      JobButton(
        BUTTON_TITLE,
        () => Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('Job \'${entry.jobTitle}\' has been accepted'),
          ),
        ),
      ),
    );

    return Column(
      children: rows,
    );
  }
}
