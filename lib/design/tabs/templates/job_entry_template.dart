import 'package:flutter/material.dart';
import 'package:frinx_job_pooler/design/tabs/common/job_description_widget.dart';
import 'package:frinx_job_pooler/design/tabs/common/job_location_widget.dart';
import 'package:frinx_job_pooler/design/tabs/common/job_title_widget.dart';
import 'package:frinx_job_pooler/design/tabs/common/job_workflowOutput_widget.dart';
import 'package:frinx_job_pooler/model/job_description.dart';

abstract class JobEntryTemplate extends StatelessWidget {
  static const String BUTTON_TITLE = 'Report installation completed';

  final JobDescription jobDescription;
  final Function jobRemovalCallback;

  const JobEntryTemplate(this.jobDescription, this.jobRemovalCallback);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      key: PageStorageKey<JobDescription>(jobDescription),
      title: new JobTitleWidget(jobDescription),
      children: <Widget>[_buildJobDescriptionWidget(context)],
    );
  }

  Widget _buildJobDescriptionWidget(BuildContext context) {
    return Column(
      children: getStatelessRows(context),
    );
  }

  List<Widget> getStatelessRows(BuildContext context) {
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
    return rows;
  }
}
