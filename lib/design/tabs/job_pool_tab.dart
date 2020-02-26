import 'package:flutter/material.dart';
import 'package:frinx_job_pooler/model/job_description.dart';
import 'package:frinx_job_pooler/utils/global_app_constants.dart';
import 'package:frinx_job_pooler/utils/map_utils.dart';
import 'package:sprintf/sprintf.dart';

final List<JobDescription> jobData = <JobDescription>[
  JobDescription(1, 'Job 1',
      description: 'This is the first job',
      location: 'Mlynské nivy 4959/48,\n821 09 Bratislava,\Slovakia',
      jobCoordinates: JobCoordinates(-3.823216,-38.481700)),
  JobDescription(2, 'Job 2', description: 'This is the second job'),
];

class JobPoolTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scrollbar(
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) =>
              _JobItem(jobData[index]),
          itemCount: jobData.length,
        ),
      ),
    );
  }
}

class _JobItem extends StatelessWidget {
  static const String ID_FORMAT = '%02d';
  final JobDescription entry;

  const _JobItem(this.entry);

  @override
  Widget build(BuildContext context) {
    var constants = GlobalAppConstants.of(context);
    return ExpansionTile(
      key: PageStorageKey<JobDescription>(entry),
      title: _buildJobTitleWidget(constants, entry),
      children: <Widget>[_buildJobDescriptionWidget(constants, entry)],
    );
  }

  Widget _buildJobTitleWidget(GlobalAppConstants constants,
                              JobDescription jobDescription) {
    return Row(
      children: <Widget>[
        CircleAvatar(
          backgroundColor: Colors.blueGrey[900],
          child: Text(
            sprintf(ID_FORMAT, [jobDescription.jobId]),
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          width: constants.intendJobTitleFromId,
        ),
        Expanded(
          child: Text(jobDescription.jobTitle.toUpperCase(),
              style: TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.fade,
              maxLines: constants.maxLinesOfJobTitle,
              softWrap: true),
        ),
      ],
    );
  }

  Widget _buildJobDescriptionWidget(GlobalAppConstants constants,
                                    JobDescription jobEntry) {
    final List<Widget> rows = [];
    if (entry.description != null) {
      rows.add(_buildJobDescriptionEntry(constants, jobEntry.description));
    }
    if (entry.location != null) {
      rows.add(_buildJobLocationEntry(
          constants, jobEntry.location, jobEntry.jobCoordinates));
    }

    return Column(
      children: rows,
    );
  }

  Widget _buildJobDescriptionEntry(GlobalAppConstants constants,
                                   String description) {
    return Container(
      child: Row(
        children: <Widget>[
          Icon(
            Icons.description,
            size: constants.sizeJobPoolIcon,
            color: Colors.blueGrey[500],
          ),
          SizedBox(width: constants.intendIconFromText),
          Expanded(
            child: Text(
              description,
              softWrap: true,
              overflow: TextOverflow.fade,
              textAlign: TextAlign.justify,
            ),
          ),
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
      padding: constants.paddingOfJobEntry,
    );
  }

  Widget _buildJobLocationEntry(GlobalAppConstants constants, String location,
                                JobCoordinates jobCoordinates) {
    return Container(
      child: Row(
        children: <Widget>[
          _getGpsIconWidget(constants, jobCoordinates),
          SizedBox(width: constants.intendIconFromText),
          Expanded(
            child: Text(
              location,
              softWrap: true,
              overflow: TextOverflow.fade,
              textAlign: TextAlign.justify,
            ),
          ),
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
      padding: constants.paddingOfJobEntry,
    );
  }

  Widget _getGpsIconWidget(GlobalAppConstants constants,
                           JobCoordinates jobCoordinates) {
    Widget iconWidget = Icon(Icons.gps_fixed,
      size: constants.sizeJobPoolIcon,
      color: Colors.blueGrey[500],
    );
    if (jobCoordinates != null) {
      iconWidget = GestureDetector(
        child: iconWidget,
        onTap: () {
          MapUtils.openMap(jobCoordinates.latitude, jobCoordinates.longitude);
        },
      );
    }
    return iconWidget;
  }
}
