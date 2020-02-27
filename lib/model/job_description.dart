import 'package:frinx_job_pooler/model/job_state.dart';

class JobDescription {
  final int jobId;
  final String jobTitle;
  final String description;
  final String location;
  final JobCoordinates jobCoordinates;
  final JobState jobState;
  String workflowOutput;

  JobDescription(this.jobId, this.jobTitle,
      {this.description, this.location, this.jobCoordinates, this.jobState});

  JobDescription.myJobs(this.jobId, this.jobTitle,
      {this.description, this.location, this.jobCoordinates,
        this.workflowOutput, this.jobState});
}

class JobCoordinates {
  final double latitude;
  final double longitude;

  JobCoordinates(this.latitude, this.longitude);
}
